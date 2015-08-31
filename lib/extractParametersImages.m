function [ pixelSize, imgSize, channelIdNuclei, channelIdSpheroids, channelIdSpots, sampleId, seriesId, imageDir, fileName, filePath ] = extractParametersImages(dataTable, fctOps)

        imageId = fctOps.input.imageId;
        pixelSize = [ dataTable.pixelSizeX(imageId),dataTable.pixelSizeY(imageId), dataTable.pixelSizeZ(imageId) ];
        imgSize = [ dataTable.sizeX(imageId),dataTable.sizeY(imageId), dataTable.sizeZ(imageId) ];
        try
            channels = dataTable.channels(imageId);
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
            stains = dataTable.stains(imageId);
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

        imageDir = dataTable.imageDir(imageId);
        imageDir = imageDir{1};
        filePath = dataTable.imageFilePath(imageId);
        filePath = filePath{1};
        try
            fileName = dataTable.imageFileName(imageId);
            fileName = fileName{1};
        catch
            fileName = filePath;
        end
        try
            seriesId = dataTable.seriesId(imageId);
        catch
            warning('no seriesId found');
            seriesId = [];
        end
        
        sampleId = dataTable.sampleId(imageId);
end
