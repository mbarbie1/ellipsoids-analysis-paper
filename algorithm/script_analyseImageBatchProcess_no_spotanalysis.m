% SCRIPT: Batch processing function for the segmentation and spot
%           detection algorithm. The script runs the function analyseImage
%           on all images defined by the options, the measurement results
%           are save in a single table (as excel, json, or mat file)
%           The options of the script are given by a
%           separate options file which is a .json file, the default name
%           is: optionsBatchProcess.json. This options file refers also to
%           a file which should contain the description of the images 
%           (list of samples/images), the
%           default name is: conditions_embedded_Kjersti.xlsx. 
%
%           The options file allows picking out samples, for example:
%                   "input": {
%                       "sampleIdsRange": 					[209,237],
%                       "sampleIds": 						[1],
%                       ...
%           tells the script to take the range of sample-ID's (from the
%           sample list file, under the column sampleId) from 209 til 237 
%           (237 included). Another example where the options contain:
%                   "input": {
%                       "sampleIdsRange": 					[],
%                       "sampleIds": 						[1,34,55,200],
%                       ...
%           defines a non-valid sample-ID range, therefore the script looks
%           at "sampleIds", such that the samples which are picked out are 
%           the ones with sample-ID equal to 1, 34, 55, and 200.
%
%
% Necessary files for running the script:
%           - (optionsBatchProcess.json): json file describing the input,
%               output and algorithm parameters
%           - (conditions_embedded_Kjersti.xlsx): a .mat or excel file 
%               containing the table of samples with
%               necessary data describing the samples, e.g., the filename,
%               directory, channel definitions, pixel size, ...
%
%
%
%
% AUTHOR: 
%
% 	Michaël Barbier
%   mbarbie1@its.jnj.com
% 
% ----------------------------------------------------------------------- 
%
    clear
    fprintf('Starting script\n');
    tstartTotal = tic;

%% LOADING LIBRARIES

    % libs
    addpath(genpath('../lib'));
    % External libs
    addpath(genpath('../libExternal'));
    % DIPimage
    try
        run('C:\Program Files\DIPimage 2.6\dipstart.m');
    catch e
        return
    end

%% PARAMETERS

   %options = loadjson('optionsBatchProcess.json');
   % options = loadjson('input/optionsBatchProcess_Kjersti_floaters_EdU.json');
   % options = loadjson('input/optionsBatchProcess_Kjersti_floaters_ToPRO.json');
   % options = loadjson('input/optionsBatchProcess_Kristin_floaters.json');
   % options = loadjson('input/optionsBatchProcess_Marta.json');
   %options = loadjson('input/optionsBatchProcess_Marta_manual_10x.json');
   %options = loadjson('input/optionsBatchProcess_Vitor_manual_10x.json');
   % options = loadjson('input/optionsBatchProcess_Kjersti_embedded.json');
   % options = loadjson('input/optionsBatchProcess_Kristin_embedded_fixed.json');
   options = loadjson('input/optionsBatchProcess_Kristin_embedded_live.json');

%% IMPORT SAMPLES

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

%% RUN FOR EACH SAMPLE

    j = 0;
    msra = cell(length(images),1);
    disp(images);
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
            = extractParametersImages(data.parTable, options);

        %% IMAGE ANALYSIS
        disp(options.input.fileName)
        try
            %[ msra, lab, labEllipse, imgSpheroids, spotTable, imgSpots ] = analyseImage(options);
            
            [ msra{j}, ~, ~, mip, radialProfiles ] = analyseImage_no_spot_analysis(options);
            succesfullAnalysis = true;
            imageSummary(j) = getSummary(options, succesfullAnalysis, '', mip, msra{j}, []);
        catch e
            warning('Analysis failed: imageId = %i', imageId);
            logError( 1, e );
            succesfullAnalysis = false;
            imageSummary(j) = getSummary(options, succesfullAnalysis, logErrorString( e ), [], [], []);
        end

    end

%% SAVE ALL MEASUREMENTS

    msraAll = vertcat( msra{:} );
    for j = 1:length(options.output.msrAll)
        if (options.output.msrAll{j}.write)
            fprintf('Saving all measurements (%s)\n', options.output.msrAll{j}.format);
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
   