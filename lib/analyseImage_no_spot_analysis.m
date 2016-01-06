% FUNCTION: Segmentation and spot detection algorithm for the paper. 
%           Not optimized for speed, in particular not useful in a batch 
%           process (uses time-consuming 3D spot detection, 
%           saves unnecessary information to disk, ...).
%
% INPUT:
%
%           options             : struct with all the parameters for the
%                                   various steps:
%                                       - input data
%                                       - output data
%                                       - 2D segmentation
%                                       - ellipsoid fitting
%                                       - spot detection
%                                   The following json code shows an 
%                                   example of options struct in json
%                                   notation:
%
%             "options":
%                 {
%                     "output": 
%                     {
%                         "msr": [
%                             {
%                                 "dir":			"../example/output",
%                                 "fileName":		"msr.xlsx",
%                                 "format":		"excel"
%                             }
%                         ],
%                         "mat":	{
%                             "dir":			"../example/output",
%                             "pattern":		"imageId_[nnnn].mat",
%                             "format":		"mat"
%                         },
%                         "images": [
%                             {
%                                 "name":			"imgSpots",
%                                 "dir":			"../example/output",
%                                 "pattern":		"img_EdU_[nnnn].tif",
%                                 "format":		"tif",
%                                 "bitDepth":		"uint16",
%                                 "color":		"gray",
%                                 "ioMethod":		"Matlab"
%                             },
%                             {
%                                 "name":			"imgSpheroids",
%                                 "dir":			"../example/output",
%                                 "pattern":		"img_RFP_[nnnn].tif",
%                                 "format":		"tif",
%                                 "bitDepth":		"uint16",
%                                 "color":		"gray",
%                                 "ioMethod":		"Matlab"
%                             }
%                         ]
%                     },
%                     "input": {
%                         "sampleId":                         1,
%                         "imageId":                          1,
%                         "seriesId":                         [],
%                         "imageDir":                         "../example/input",
%                         "filePath":                         "S2_File.tif",
%                         "imageMicroscopeFormat":            "Opera",
%                         "spheroidSegmentationChannel":	  	"RFP",
%                         "nucleiSegmentationChannel":		"Hoechst",
%                         "spotDetectionChannel":         	"EdU",
%                         "channelIdSpheroids":               2,
%                         "channelIdNuclei":                  4,
%                         "channelIdSpots":                   1,
%                         "pixelSize":                        [ 1.3, 1.3, 10 ]
%                     },
%                     "segmentation": {
%                         "pixelSize":                        [ 1.3, 1.3, 10 ],
%                         "minRadius":                        6,
%                         "neighbourhoodRadius":              3,
%                         "maxRangeZ":                        24,
%                         "maxRadius":                        200,
%                         "removeBorderObjectsInPlane":       1,
%                         "removeBorderObjectsInZ":           1,
%                         "splitSpheroids":                   1,
%                         "borderZRemoveMethod":              "default",
%                         "thresholdIntensity":               1000,
%                         "method":                           "ProjZ"
%                     },
%                     "ellipsoidFit": {
%                         "centerMethod":                     "rimHeight",
%                         "zRadiusMethod":                    "averageRadius"
%                     },
%                     "spotDetection": {
%                         "method":                           "3D",
%                         "avgSpotRadius":                    6,
%                         "maxSpotRadius":                    8,
%                         "maxSpotDetectorRatio":             0.05
%                     }
%                 }
%
% 
% AUTHOR: 
%
% 	Michaël Barbier
%   mbarbie1@its.jnj.com
% 
% ----------------------------------------------------------------------- 
%
function [ msra, lab, labEllipse, imgSpheroids, radialProfiles ] = analyseImage_no_spot_analysis(options)

    sampleId = options.input.sampleId;
    imageId = options.input.imageId;
    fprintf('Starting analyseImage on imageId %i\n', imageId);
    tstartTotal = tic;


%% LOAD THE SPHEROID IMAGE

    tstart = tic;
    channelId = options.input.channelIdSpheroids;
    img = loadMicroscopeImageStack( options.input.imageDir, options.input.fileName, channelId, options.input.seriesId, options.input.imageMicroscopeFormat );
    pixelSize = options.input.pixelSize;
    tstop = toc(tstart);
    fprintf('Processing time LoadImage = %i\n', tstop);

%% SPHEROID SEGMENTATION + MEASUREMENTS

    % 2D segmentation of the image
    options.segmentation.pixelSize = pixelSize;
    switch options.segmentation.segmentationMethod
        case 'manual'
            subStruct.name = {'n'}; subStruct.value = {imageId}; subStruct.type = {'int'};
            regexString = options.input.roiPattern;
            ROIFilename = getGeneralName(subStruct, regexString);
            ROIImageDir = options.input.roiDir;
            roi = ReadImageJROI( fullfile(ROIImageDir, ROIFilename) );
            [imgMIPZ, imgMIPZH, lab, contour, roi] = manualSegmentation2D( img, roi, options.segmentation );
            % Fitting of ellipsoids to the lab image
            [labEllipse, center3D, principalAxesList3D, axesDimensionsList3D, centerProfiles, spheroidIndexStart, spheroidIndexStop] = fitSpheroidAxesRoi(img, imgMIPZ, imgMIPZH, roi, options.input.pixelSize, options.ellipsoidFit.centerMethod, options.ellipsoidFit.zRadiusMethod);
            radialProfiles = [];
            % Derive a valid range for the depth of the spheroid, which can be
            % used for the spot detection without missing any spots, from the 
            % intensity profiles through the spheroid centers
            [profileStop, profileStopRange, depthPercentage, depthType] = analyseAttenuationProfile(center3D(:,3), centerProfiles, spheroidIndexStart, spheroidIndexStop, options.attenuationAnalysis.profileAttenuationRatio );
            clear img;
            % Perform measurements on spheroid 2D masks and their ellipses.
            msr = ellipsoidValidationMeasurementsRoi( imgMIPZ, imgMIPZH, roi, center3D(:,3), labEllipse, pixelSize );
        otherwise
            [imgMIPZ, imgMIPZH, lab, contour] = spheroidSegmentation2D( img, options.segmentation );
            % Fitting of ellipsoids to the lab image
            [labEllipse, center3D, principalAxesList3D, axesDimensionsList3D, centerProfiles, spheroidIndexStart, spheroidIndexStop] = fitSpheroidAxes(img, imgMIPZ, imgMIPZH, lab, options.input.pixelSize, options.ellipsoidFit.centerMethod, options.ellipsoidFit.zRadiusMethod);
            % rad
            radialProfiles = [];
        % %    if ( exist( 'option.ellipsoidFit.radialProfiles', 'var' ) )
        %         if ( options.ellipsoidFit.radialProfiles )
        %             radialProfiles = spheroidRadialIntensityCurves2D( img, lab > 0, options.input.pixelSize);
        %             dipshow(radialProfiles);
        %         end
        % %    end
            % Derive a valid range for the depth of the spheroid, which can be
            % used for the spot detection without missing any spots, from the 
            % intensity profiles through the spheroid centers
            [profileStop, profileStopRange, depthPercentage, depthType] = analyseAttenuationProfile(center3D(:,3), centerProfiles, spheroidIndexStart, spheroidIndexStop, options.attenuationAnalysis.profileAttenuationRatio );
            % Plotting the middle slices of the spheroids of the top projection, add the ellipse contours, and construct a mosaic image
            [imgSH, labTop, overlayTop] = topSliceProjection( img, lab, center3D, principalAxesList3D, axesDimensionsList3D);
            % Plotting the middle slices of the spheroids of the side projection, add the ellipse contours, and construct a mosaic image
            %[ imgSide, labSide, overlaySide ] = sideSliceProjection( img, imgMIPZH, lab, options.input.pixelSize);
            [ imgSide, labSide, overlaySide ] = sideSliceProjection( img, imgMIPZH, lab, options.input.pixelSize, center3D, principalAxesList3D, axesDimensionsList3D );
            % Side-slice projection + analyzable depth labeled as a plot
            % Add lines/points showing the maximal intensity, center, and analyzable depth
            clear img;
            % Perform measurements on spheroid 2D masks and their ellipses.
            msr = ellipsoidValidationMeasurements( imgMIPZ, imgMIPZH, lab, labEllipse, options.input.pixelSize );
    end
    imgSpheroids = imgMIPZ;

%% PREPARING AND SAVING OUTPUT MEASUREMENTS

    tstart = tic;
    fprintf('Preparing measurements for saving\n');
    msra = struct(msr);
    for j = 1:length(msr)
        msra(j,1).CenterRimHeight_3 = center3D(j,3);
        msra(j,1).PrincipalAxes1_1 = principalAxesList3D{j}{1}(1);
        msra(j,1).PrincipalAxes1_2 = principalAxesList3D{j}{1}(2);
        msra(j,1).PrincipalAxes1_3 = principalAxesList3D{j}{1}(3);
        msra(j,1).PrincipalAxes2_1 = principalAxesList3D{j}{2}(1);
        msra(j,1).PrincipalAxes2_2 = principalAxesList3D{j}{2}(2);
        msra(j,1).PrincipalAxes2_3 = principalAxesList3D{j}{2}(3);
        msra(j,1).PrincipalAxes3_1 = principalAxesList3D{j}{3}(1);
        msra(j,1).PrincipalAxes3_2 = principalAxesList3D{j}{3}(2);
        msra(j,1).PrincipalAxes3_3 = principalAxesList3D{j}{3}(3);
        msra(j,1).AxesRadius_1 = axesDimensionsList3D{j}(1);
        msra(j,1).AxesRadius_2 = axesDimensionsList3D{j}(2);
        msra(j,1).AxesRadius_3 = axesDimensionsList3D{j}(3);
        msra(j,1).ellipsoidVolume = 4/3 * pi * prod( axesDimensionsList3D{j}(:) );
        msra(j,1).ellipsoidVolumeUnit = 4/3 * pi * prod( axesDimensionsList3D{j}(:) .* pixelSize(:) );
        msra(j,1).spheroidIndexStart = spheroidIndexStart(j);
        msra(j,1).spheroidIndexStop = spheroidIndexStop(j);
        msra(j,1).spheroidRange = spheroidIndexStop(j) - spheroidIndexStart(j) + 1;
        msra(j,:).depthPercentage = depthPercentage(j,:);
        msra(j,:).attenuationIndex = profileStop(j,:);
        msra(j,:).attenuationRange = profileStopRange(j,:);
        msra(j,:).depthType = depthType(j,:);
        msra(j,:).profileAttenuationRatio = options.attenuationAnalysis.profileAttenuationRatio;
        msra(j,1).imageId = imageId;
        if strcmp( options.segmentation.segmentationMethod, 'manual')
            C = strsplit(roi{1,j}.strName,'_');
            disp(C{1});
            disp(C{2});
            msra(j,1).roiName = roi{1,j}.strName;
            msra(j,1).roiType = char(C{2});
            msra(j,1).roiLabel = str2double(char(C{1}))+1;
        end
    end
    tstop = toc(tstart);
    fprintf('Processing time preparing measurements = %i\n', tstop);
    %
    subStruct.name = {'n'}; subStruct.value = {imageId}; subStruct.type = {'int'};
    for j = 1:length(options.output.msr)
        if (options.output.msr{j}.write)
            regexString = options.output.msr{j}.pattern;
            fprintf('Saving measurements (%s)\n', options.output.msr{j}.format);
            tstart = tic;
            if ~exist(options.output.msr{j}.dir, 'dir')
                mkdir(pwd, options.output.msr{j}.dir);
            end
            saveMeasurements( msra, fullfile( options.output.msr{j}.dir, getGeneralName(subStruct, regexString)), options.output.msr{j}.format )
            tstop = toc(tstart);
            fprintf('Saving time measurements (%s) = %i\n', options.output.msr{j}.format, tstop);
        end
    end

%% PREPARING AND SAVING OUTPUT IMAGES


    subStruct.name = {'n'}; subStruct.value = {imageId}; subStruct.type = {'int'};
    for j = 1:length(options.output.images)

        if (options.output.images{j}.write)

            tstart = tic;
            if ~exist(options.output.images{j}.dir, 'dir')
                mkdir(pwd, options.output.images{j}.dir);
            end
            
            %%% 
            outputFormat = options.output.images{j}.format; 
            bitDepth = options.output.images{j}.bitDepth;
            ioMethod = options.output.images{j}.ioMethod;
            color = options.output.images{j}.color;
            regexString = options.output.images{j}.pattern;
            destinationPath = fullfile( options.output.images{j}.dir, getGeneralName(subStruct, regexString) );
            try
                writeImage( dip_array( eval(options.output.images{j}.name) ), destinationPath, outputFormat, bitDepth, color, ioMethod)
            catch
            end
            tstop = toc(tstart);
            fprintf('Processing time preparing and saving %s = %i\n', options.output.images{j}.name, tstop);
    
        end
        
    end

%% SAVING MATLAB PLOTS
    try
        subStruct.name = {'n'}; subStruct.value = {imageId}; subStruct.type = {'int'};
        for j = 1:length(options.output.plots)

            tstart = tic;
            if ~exist(options.output.plots{j}.dir, 'dir')
                mkdir(pwd, options.output.plots{j}.dir);
            end
            
            outputFormat = options.output.plots{j}.format;
            regexString = options.output.plots{j}.pattern;
            destinationPath = fullfile( options.output.plots{j}.dir, getGeneralName(subStruct, regexString) );
            if (options.output.images{j}.write)
                if ( strcmp('plotOverlaySide', options.output.plots{j}.name) )
                    tempOverlaySide = createContourOverlayTick( imgSide, labSide, 2 );
                    plotOverlaySide = sideSliceProjectionQC( tempOverlaySide, options.input.pixelSize, center3D, centerProfiles, spheroidIndexStart, profileStop );
                end
                print( eval(options.output.plots{j}.name), destinationPath, ['-d' outputFormat], '-r300');
            end
            tstop = toc(tstart);
            fprintf('Processing time preparing and saving %s = %i\n', options.output.plots{j}.name, tstop);
        end
    catch e
        warning('analyseImage: No plot defined');
    end


    
%% SAVING MAT OUTPUT
    
    if (options.output.mat.write)
        fprintf('Saving MAT output\n');
        tstart = tic;
        subStruct.name = {'n'}; subStruct.value = {imageId}; subStruct.type = {'int'}; 
        if ~exist(options.output.mat.dir, 'dir')
            mkdir(pwd, options.output.mat.dir);
        end
        regexString = options.output.mat.pattern;
        save( fullfile( options.output.mat.dir, getGeneralName(subStruct, regexString) ) );
        tstop = toc(tstart);
        fprintf('Processing time saving MAT-file %s = %i\n', getGeneralName(subStruct, regexString), tstop);
    end

%%    
    tstopTotal = toc(tstartTotal);
    fprintf('Total processing time analyseImage = %i\n', tstopTotal);

end
