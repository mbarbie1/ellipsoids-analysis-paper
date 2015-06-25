% This function reads an image from a file of certain format, bitdepth,
% using either Matlab image toolbox either Bioformats (bfmatlab library should be loaded)
function image = readImage(sourcePath, inputFormat, ioMethod, seriesId)

    switch ioMethod
        % Reading the image using Matlab image toolbox
        case 'Matlab',
            info = imfinfo(sourcePath);
            nImages = numel(info);
            if (nImages > 1)
                m = 0;
                % Loop over the images
                for k = 1:nImages
                    % Only use the 1e subfile in the image file if there
                    % are multiple subfiles (e.g. extra tumbnails)
                    if (info(k).NewSubFileType == 0)
                        plane = imread(sourcePath, 'Index', k, 'Info', info);
                        % If there are multiple samples per pixel loop over
                        % the samples
                        if ( ndims(plane) > 2 )
                            for kc = 1:size(plane,3)
                                m = m + 1;
                                image(:,:,m) = plane(:,:,kc);
                            end
                        else
                            m = m + 1;
                            image(:,:,m) = plane;
                        end
                    end
                end
            else
                image = imread(sourcePath, inputFormat);
            end
        % Reading the image using bioformats    
        case 'Bioformats',
            data = bfopen(sourcePath);
            nSeries = size(data,1);
            j = 0;
            for k = 1:nSeries
                nSlices = size( data{k,1}, 1 );
                for l = 1:nSlices
                    j = j + 1;
                    image(:,:,j) = data{k,1}{l,1};
                end
            end
        otherwise
    end
end
