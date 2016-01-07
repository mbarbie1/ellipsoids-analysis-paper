function [ pixelSize, imgSize, channelIdNuclei, channelIdSpheroids, channelIdSpots, sampleId, seriesId, imageDir, fileName, filePath ] = extractParametersImages(dataTable, fctOps)
% -----------------------------------------------------------------------
% 
% FUNCTION: Extract the parameters from the table with sample descriptions,
%           the necessary values which should be specified in a column are
%           the following:
%
%       ------------------------------------------------------------------
%               Column Header   |   Example value           |   Data type
%       ------------------------------------------------------------------
%               sampleId        | 2                         | integer
%               seriesId        | 1,2,3... or []            | integer
%               imageId         | 23                        | integer
%               pixelSizeX      | 0.723                     | double
%               pixelSizeY      | 0.723                     | double
%               pixelSizeZ      | 5                         | double
%               sizeX           | 512                       | integer
%               sizeY           | 512                       | integer
%               sizeZ           | 50                        | integer
%               channels        | 4,1,2,3                   | comma separated string
%               stains          | EdU,DAPI,RFP,YFP          | comma separated string
%               imageDir        | 'c:/data/stack1'          | string
%               imageFileName   | 'image_PC3'               | string
%        ----------------------------------------------------------------- 
%
% AUTHOR: 
% 
% 	Micha�l Barbier
%   mbarbie1@its.jnj.com
% 
% -----------------------------------------------------------------------
%
        imageId = fctOps.input.imageId;
        row = find(dataTable.imageId == imageId, 1, 'first');
        try
            pixelSize = [ dataTable.pixelSizeX(row),dataTable.pixelSizeY(row), dataTable.pixelSizeZ(row) ];
        catch
            warning('extractParametersImages::No definitions in samples table for the pixel size. Trying to extract pixel size from OME metadata using bioformats')
            try
                [meta, ~] = getOmeMeta(dataTable.imageFilePath(row));
                pixelSize = [ meta.pixelSizeX, meta.pixelSizeY, meta.pixelSizeZ ];
            catch
                warning('No definitions for the pixel size found in samples table nor in the image metadata using bioformats')
                error('extractParametersImages::Cannot extract the pixel size from OME metadata using bioformats')
            end
        end
        try
            imgSize = [ dataTable.sizeX(row),dataTable.sizeY(row), dataTable.sizeZ(row) ];
        catch
            warning('extractParametersImages::No definitions in samples table for the image size. Trying to extract image size from OME metadata using bioformats')
            try
                [meta, ~] = getOmeMeta(dataTable.imageFilePath(row));
                imgSize = [ meta.sizeX, meta.sizeY, meta.sizeZ ];
            catch
                warning('No definitions for the image size found in samples table nor in the image metadata using bioformats')
                error('extractParametersImages::Cannot extract the image size from OME metadata using bioformats')
            end
        end
        try
            channels = dataTable.channels(row);
            channels = channels{1};
        catch
        end
        try
            channelIdSpheroids = fctOps.input.channelIdSpheroids;
            channelIdNuclei = fctOps.input.channelIdNuclei;
            channelIdSpots = fctOps.input.channelIdSpots;
        catch e
            warning('no channel-Ids defined: %s', e.message);
        end
        if ( exist('channels','var') )
            % channel-ids are defined in image description file
            channelsSplit = strsplit(channels,',');
            channels = cellfun(@str2num, channelsSplit);
            stains = dataTable.stains(row);
            stains = stains{1};
            channelIdSpheroids = channels( find( regexpcmp( strsplit(stains,','), fctOps.input.spheroidSegmentationChannel ) ) );
            channelIdNuclei = channels( find( regexpcmp( strsplit(stains,','), fctOps.input.nucleiSegmentationChannel ) ) );
            channelIdSpots = channels( find( regexpcmp( strsplit(stains,','), fctOps.input.spotDetectionChannel ) ) );
        else
            if ( exist('channelIdSpheroids','var') )
                % channel-ids are defined in options
            else
                warning('extractParametersImages: No channels definition');
                channelIdSpheroids = 2;
                channelIdNuclei = 3;
                channelIdSpots = 1;
            end
        end

        imageDir = dataTable.imageDir(row);
        imageDir = imageDir{1};
        filePath = dataTable.imageFilePath(row);
        filePath = filePath{1};
        try
            fileName = dataTable.imageFileName(row);
            fileName = fileName{1};
        catch
            fileName = filePath;
        end
        try
            seriesId = dataTable.seriesId(row);
        catch
            warning('no seriesId found');
            seriesId = [];
        end
        
        sampleId = dataTable.sampleId(row);
end
