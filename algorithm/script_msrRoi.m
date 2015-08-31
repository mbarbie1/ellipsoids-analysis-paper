% SCRIPT: calculates the measurements for both the roi images given in the
%           parameter input file (that 2D segmentation roi's) and the masks
%           obtained from the 2D segmentation algorithm.
%           The options of the script are given by a
%           separate options file which is a .json file, the default name
%           is: optionsErrorGT.json.
% 
% AUTHOR: 
%
% 	Michaël Barbier
%   mbarbie1@its.jnj.com
% 
% ----------------------------------------------------------------------- 
%

%% LOADING LIBRARIES

    clear
    clf

    addpath(genpath('../lib'));
    % External libs
    addpath(genpath('../libExternal'));
    try
        run('C:\Program Files\DIPimage 2.6\dipstart.m');
    catch e
        warning(e.message);
        return
    end
    
%%
    options = loadjson('input/optionsErrorGT.json');

%% IMPORT SAMPLES (not GT)

    [pathstr, name, ext] = fileparts(options.input.sampleList);
    if (strcmp(ext, '.xlsx'))
        data.parTable = readtable(options.input.sampleList);
    else
        data = load(options.input.sampleList);
    end
    
    if ( length(options.input.sampleIdsRange)~= 2 )
        images = options.input.sampleIds;
    else
        images = options.input.sampleIdsRange(1):options.input.sampleIdsRange(2);
    end

%%
    for ii = 1:length(images);

        imageId = images(ii);
        %%% PER IMAGE PARAMETERS
        options.input.imageId = imageId;
        [ options.input.pixelSize, options.input.size, options.input.channelIdNuclei, ...
            options.input.channelIdSpheroids, options.input.channelIdSpots,...
            options.input.sampleId, options.input.seriesId,...
            options.input.imageDir, options.input.imageFileName, options.input.filePath ]...
            = extractParametersImages(data.parTable, options);
        options.input.imageDir
        pixelSize = options.input.pixelSize;

        % loading image
        channelId = options.input.channelIdSpheroids;
        filePath = options.input.filePath;
        tstart = tic;
        img = loadMicroscopeImageStack( options.input.imageDir, options.input.filePath, channelId, options.input.seriesId, options.input.imageMicroscopeFormat );

        % segmentation of the image
        options.segmentation.pixelSize = pixelSize;
        [mip, h, lab, contour] = spheroidSegmentation2D( img, options.segmentation );
         sz3D = imsize(img);

        % parameters of the GT ROI
        ROIFilename = ['RoiSet_' num2str(imageId) '.zip'];
        ROIImageDir = 'C:/Users/mbarbie1/Desktop/PAPER/GT_images';
        roi = ReadImageJROI( fullfile(ROIImageDir, ROIFilename) );
        n = length(roi);
        
        % segmentation measurements
        msrFields = {'size','center','Maximum','Minimum','Radius','ConvexArea','P2A','Feret','PodczeckShapes',...
            'mean','StdDev','MinVal','MaxVal','Skewness','ExcessKurtosis'};
        msr = measure(lab, mip, msrFields);
        msra = struct(msr);
        for m = 1:length(msr)
            msra(m,1).imageId = imageId;
        end

        % construct the roi masks
        imgCell = {mip};
        colorType = struct(...
            'color', {[255,0,0],[0,255,0],[0,0,255],[0,255,255],[255,0,255]}, ...
            'type', {1,2,3,4,5}, ...
            'name', {'separated','obscured','border','touching','not-obscured'} ...
            );
        % ROI gets updated and now contains new field such as:
        %   roi{j}.argb: color of the contour in [a,r,g,b] with each in the
        %                   range of 0..255
        %   roi{j}.type: index of the type of the class: 1, 2, ...
        %   roi{j}.name: name of the class: touching, obscured, ... 
        %   roi{j}.mask: dipimage submask of the contour
        %   roi{j}.minp: upper left corner coordinates of the bounding box
        %   roi{j}.maxp: lower right corner coordinates of the bounding box
        %   roi{j}.pRel: relative coordinates of the contour to the bounding
        %                   box
        %   roi{j}.pAbs: absolute coordinates of the contour
        %   roi{j}.img: cell array of sub-images (mip, heightmap, ...) 
        %   roi{j}.msr: measurements
        roi = roiToMasks_RoiManager(roi, imgCell, colorType, msrFields);

        % UNION give all unions of masks of overlapping bounding boxes of the
        % masks of the labeled image and the roi masks, also the ones which are
        % not overlapping.
        %   union.Amask: roi masks
        %   union.Bmask: lab masks with overlapping bounding box of roi Amask
        %   union.img: images corresponding to the union of the masks (mip, heightmap)
        % OVERLAP describes the overlap of the pixels of the roi and lab masks
        %   overlap.pixels = (nRoi x nLab) number of overlapping pixels
        %   overlap.isDaughter = (nRoi x nLab) 
        %   overlap.M = (nRoi x nLab) percentage of overlapping pixels of the
        %                               parent (roi)
        %   overlap.m = (nRoi x nLab) percentage of overlapping pixels of the
        %                               potential daughter (lab)
        %   overlap.numDaughters = (nRoi x 1) number of daughters (lab) for each
        %                           parent (roi)
        %   overlap.sizeM = (nRoi x 1) size of the parent (roi) mask
        %   overlap.sizem = (nRoi x 1) size of the potential daughter (lab)
        %   overlap.missedPixelsM = (nRoi x 1) number of pixels not in m but in
        %                                           M
        %   overlap.missedPixelsm = (nRoi x 1) number of pixels not in M but in
        %                                           m
        [union, overlap] = getUnionLabAndRoi(roi, lab, msr, imgCell);

        % plot the images with the contours of the roi and of the lab
        maskContour = newim(imsize(mip));
        for k = 1:n
            maskContour( sub2ind(maskContour, roi{k}.pAbs-1) ) = roi{k}.type;
        end
        contourGT = createContourOverlay( mip, maskContour);

        j = 0
        clear dataMsrGT2 dataMsrGT3 dataMsrLab dataRoiType dataOverlap dataM
        dataOverlap = zeros(n,1);
        dataRoiType = -1 * ones(n,1);
        dataM = zeros(n,1);
        overlapM = zeros(n,1);
        for k = 1:n
            if (overlap.numDaughters(k) > 0)
                j = j + 1;
                daughter = find( overlap.isDaughter(k,:) );
                for m = 1:length(daughter)
                    dataOverlap(k) = dataOverlap(k) + overlap.pixels(k,daughter(m));
                    dataM(k) = dataM(k) + overlap.M(k,daughter(m));
                    dataMsrLab(k) = msra(daughter(m));
                    dataMsrGT2(k) = roi{k}.msr;
                    dataMsrGT2(k).id = k;
                    dataRoiType(k) = roi{k}.type;
                    dataRoiColor(j,:) = roi{k}.argb(2:4);
                end
            else

            end
        end
        for k = 1:n
            dataMsrGT3(k) = roi{k}.msr;
            dataMsrGT3(k).id = k;
        end
        for k = 1:n
            dataMsrGT3(k).numDaughters = overlap.numDaughters(k);
            dataMsrGT3(k).daughters = overlap.daughters{k};
        end
        for k = 1:length(msra)
            msra(k).numParents = overlap.numParents(k);
            msra(k).parents = overlap.parents{k};
        end

        dataMsrLab_cell{ii} = dataMsrLab';
        dataMsrGT_cell{ii} = dataMsrGT2';
        dataMsrGT_ul_cell{ii} = dataMsrGT3';
        dataM_cell{ii} = dataM;
        dataOverlap_cell{ii} = dataOverlap;
        dataRoiType_cell{ii} = dataRoiType;

        imageId_cell{ii} = imageId * ones(n,1);
        roiId_cell{ii} = (1:n)';
        overlap_cell{ii} = overlap;
        
        dataNumParents_cell{ii} = msra;
        dataNumDaughters_cell{ii} = overlap.numDaughters(:);
    
    end
    
    % TODO
    msrLab_n = vertcat( dataNumParents_cell{:} );
    msrLab_all = vertcat( dataMsrLab_cell{:} );
    msrGT_n = vertcat( dataMsrGT_ul_cell{:} );
    msrGT_all = vertcat( dataMsrGT_cell{:} );
    M_all = vertcat( dataM_cell{:} );
    overlap_all = vertcat( dataOverlap_cell{:} );
    roiType_all = vertcat( dataRoiType_cell{:} );
    imageIdVec = vertcat( imageId_cell{:} );
    roiIdVec = vertcat( roiId_cell{:} );
    numDaughters_all = vertcat( dataNumDaughters_cell{:} );

    savejson('overlap',overlap_cell,'output/gt_error/overlap.json');

    writetable(struct2table(msrLab_n),'output/gt_error/msrLab_nLab.csv')
    writetable(struct2table(msrLab_all),'output/gt_error/msrLab.csv')
    writetable(struct2table(msrGT_all),'output/gt_error/msrGT.csv')
    writetable(struct2table(msrGT_n),'output/gt_error/msrGT_nGT.csv')
    T = table(imageIdVec, roiIdVec, roiType_all, overlap_all, M_all, numDaughters_all, 'VariableNames', { 'imageId', 'roiId' ,'roiType', 'overlap', 'M', 'numDaughters' });
    writetable( T, 'output/gt_error/overlap.csv');
