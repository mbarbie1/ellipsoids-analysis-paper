% SCRIPT: Batch processing MIPs generation
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

    options = loadjson('optionsMIP.json');

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
    for imageId = images

        %% PER IMAGE PARAMETERS
        options.input.imageId = imageId;
        [ options.input.pixelSize, options.input.size, options.input.channelIdNuclei, ...
            options.input.channelIdSpheroids, options.input.channelIdSpots,...
            options.input.sampleId, options.input.seriesId,...
            options.input.imageDir, options.input.fileName, options.input.filePath ]...
            = extractParametersImages(data.parTable, options);

        options.input.imageDir(1) = 'F';

        tstart = tic;

        j = j + 1;

        channelIds = [ options.input.channelIdSpots, options.input.channelIdNuclei ];
        channelLabels = {'EdU', 'nuclei'};
        for k = 1:length(channelIds)

            channelId = channelIds(k);
            channelLabel = channelLabels{k};
            img = loadMicroscopeImageStack( options.input.imageDir, options.input.filePath, channelId, options.input.seriesId, options.input.imageMicroscopeFormat );
            pixelSize = options.input.pixelSize;
            tstop = toc(tstart);
            fprintf('Processing time LoadImage = %i\n', tstop);

                %% MIP GENERATION
            try
                imgMIPZ = max(img,[],3);
                imgMIPZ = squeeze(imgMIPZ);
                subStruct.name = {'n'}; subStruct.value = {imageId}; subStruct.type = {'int'};
                tstart = tic;
                if ~exist(options.output.mip.dir, 'dir')
                    mkdir(pwd, options.output.mip.dir);
                end
                outputFormat = options.output.mip.format; 
                bitDepth = options.output.mip.bitDepth;
                ioMethod = options.output.mip.ioMethod;
                color = options.output.mip.color;
                regexString = options.output.mip.pattern;
                destinationPath = fullfile( options.output.mip.dir, [ channelLabel '_' getGeneralName(subStruct, regexString)] );
                try
                    writeImage( dip_array( imgMIPZ ), destinationPath, outputFormat, bitDepth, color, ioMethod)
                catch
                end
                tstop = toc(tstart);
                fprintf('Processing time saving %s = %i\n', options.output.mip.name, tstop);
            catch e
                warning('MIP projection failed: imageId = %i', imageId);
                logError( 1, e );
            end
        end


    end

%% END

    tstop = toc(tstartTotal);
    fprintf('Total processing time script = %i\n', tstop);
 