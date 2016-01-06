function [] = analyseImageBatchProcess( options, data )
% -----------------------------------------------------------------------
%
% FUNCTION: Batch processing function for the segmentation and spot
%           detection algorithm. The script runs the function analyseImage
%           on all images defined by the options, the measurement results
%           are saved in a single table (as excel, json, or mat file)
% 
% AUTHOR: 
% 
% 	Michaël Barbier
%   mbarbie1@its.jnj.com
% 
% -----------------------------------------------------------------------
%
    fprintf('Starting script: Ellipsoid segmentation algorithm and positive nuclei detection\n');
    tstartTotal = tic;

%% IMPORT SAMPLES

   
    if ( length(options.input.sampleIdsRange)~= 2 )
        images = options.input.sampleIds;
    else
        images = options.input.sampleIdsRange(1):options.input.sampleIdsRange(2);
    end
    fprintf('Starting batch process on the imageIds: (%i)\n', images);

%% RUN FOR EACH SAMPLE

    j = 0;
    msra = cell(length(images),1);
    spotTable = msra;
    for imageId = images

        j = j + 1;
        clearvars -except images imageId options tstartTotal data j msra spotTable imageSummary

        if strcmp(options.segmentation.segmentationMethod, 'manual')
            subStruct.name = {'n'}; subStruct.value = {imageId}; subStruct.type = {'int'};
            regexString = options.input.roiPattern;
            ROIFilename = getGeneralName(subStruct, regexString);
            ROIImageDir = options.input.roiDir;
            roi = ReadImageJROI( fullfile(ROIImageDir, ROIFilename) );
        end
        
        %% PER IMAGE PARAMETERS
        options.input.imageId = imageId;
        [ options.input.pixelSize, options.input.size, options.input.channelIdNuclei, ...
            options.input.channelIdSpheroids, options.input.channelIdSpots,...
            options.input.sampleId, options.input.seriesId,...
            options.input.imageDir, options.input.fileName, options.input.filePath ]...
            = extractParametersImages(data, options);

        %% IMAGE ANALYSIS
        %disp(options.input.fileName)
        try
            %[ msra, lab, labEllipse, imgSpheroids, spotTable, imgSpots ] = analyseImage(options);
            [ msra{j}, ~, ~, mip, spotTable{j}, ~, radialProfiles ] = analyseImage(options);
            succesfullAnalysis = true;
            imageSummary(j) = getSummary(options, succesfullAnalysis, '', mip, msra{j}, spotTable{j});
        catch e
            warning('Analysis failed: imageId = %i', imageId);
            logError( 1, e );
            succesfullAnalysis = false;
            imageSummary(j) = getSummary(options, succesfullAnalysis, logErrorString( e ), [], [], []);
        end

    end

%% SAVE ALL MEASUREMENTS

    spotsAll = vertcat( spotTable{:} );
    for j = 1:length(options.output.spotsAll)
        if (options.output.spotsAll{j}.write)
            fprintf('Saving all spot detection measurements (%s)\n', options.output.spotsAll{j}.format);
            tstart = tic;
            if ~exist(options.output.spotsAll{j}.dir, 'dir')
                mkdir(pwd, options.output.spotsAll{j}.dir);
            end
            filePath = fullfile(options.output.spotsAll{j}.dir, options.output.spotsAll{j}.fileName);
            if exist(filePath, 'file')
                delete(filePath);
            end
            saveMeasurements( spotsAll, filePath, options.output.spotsAll{j}.format );
            tstop = toc(tstart);
            fprintf('Saving time all spot detection measurements (%s) = %i\n', options.output.spotsAll{j}.format, tstop);
        end
    end

    msraAll = vertcat( msra{:} );
    for j = 1:length(options.output.msrAll)
        if (options.output.msrAll{j}.write)
            fprintf('Saving all spheroid measurements (%s)\n', options.output.msrAll{j}.format);
            tstart = tic;
            if ~exist(options.output.msrAll{j}.dir, 'dir')
                mkdir(pwd, options.output.msrAll{j}.dir);
            end
            filePath = fullfile(options.output.msrAll{j}.dir, options.output.msrAll{j}.fileName);
            if exist(filePath, 'file')
                delete(filePath);
            end
            saveMeasurements( msraAll, filePath, options.output.msrAll{j}.format );
            tstop = toc(tstart);
            fprintf('Saving time all spheroid measurements (%s) = %i\n', options.output.msrAll{j}.format, tstop);
        end
    end

    for j = 1:length(options.output.summary)
        if (options.output.summary{j}.write)
            fprintf('Saving summary of the measurements for each imageId (%s)\n', options.output.summary{j}.format);
            tstart = tic;
            if ~exist(options.output.summary{j}.dir, 'dir')
                mkdir(pwd, options.output.summary{j}.dir);
            end
            filePath = fullfile(options.output.summary{j}.dir, options.output.summary{j}.fileName);
            if exist(filePath, 'file')
                delete(filePath);
            end
            saveMeasurements( imageSummary, filePath, options.output.summary{j}.format );
            tstop = toc(tstart);
            fprintf('Saving time all spheroid measurements (%s) = %i\n', options.output.summary{j}.format, tstop);
        end
    end

%% END

    tstop = toc(tstartTotal);
    fprintf('Total processing time script = %i\n', tstop);
   