function [img, meta] = loadMicroscopeImageStack( imageDir, fileName, channelId, seriesId, imageMicroscopeFormat )
% -----------------------------------------------------------------------
% 
% FUNCTION: Loads an image stacks from a file(s)
% 
% AUTHOR: 
% 
% 	Michaël Barbier
%   mbarbie1@its.jnj.com
% 
% -----------------------------------------------------------------------
%
    % Load image data from microscopy files
    if ( nargout < 2 )
        switch imageMicroscopeFormat
            case 'cv7000'
                pattern = fileName;
                fileList = imageListFromPattern( imageDir, strrep(pattern, 'C*', ['C0' num2str(channelId)]) );
                img = loadStackFromImageSequence(fileList);
            case 'multiChannel'
                [ img, ~ ] = loadStackFromMultiPageTif( fullfile(imageDir, fileName), 'tif', channelId, seriesId );
            case 'Opera'
                img = readImageStack( fullfile(imageDir, fileName), channelId, 1, seriesId);
            otherwise
                warning('Unknown imageMicroscopeFormat, using default');
                img = readImageStack( fullfile(imageDir, fileName), channelId, 1, seriesId);
        end
    else
        switch imageMicroscopeFormat
            case 'cv7000'
                pattern = fileName;
                fileList = imageListFromPattern( imageDir, strrep(pattern, 'C*', ['C0' num2str(channelId)]) );
                img = loadStackFromImageSequence(fileList);
                meta = [];
                warning('meta not available for cv7000 with this function');
            case 'multiChannel'
                [ img, meta ] = loadStackFromMultiPageTif( fullfile(imageDir, fileName), 'tif', channelId, seriesId );
            case 'Opera'
                [img, meta] = readImageStack( fullfile(imageDir, fileName), channelId, 1, seriesId);
            otherwise
                warning('Unknown imageMicroscopeFormat, using default');
                img = readImageStack( fullfile(imageDir, fileName), channelId, 1, seriesId);
        end
    end

end

