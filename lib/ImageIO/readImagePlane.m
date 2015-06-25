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
            
            
            reader = bfGetReader('path/to/data/file');
            %You can then access the OME metadata using the getMetadataStore() method:

            omeMeta = reader.getMetadataStore();
Individual planes can be queried using the bfGetPlane.m function:

series1_plane1 = bfGetPlane(reader, 1);
To switch between series in a multi-image file, use the setSeries() method. To retrieve a plane given a set of (z, c, t) coordinates, these coordinates must be linearized first using getIndex()

% Read plane from series iSeries at Z, C, T coordinates (iZ, iC, iT)
% All indices are expected to be 1-based
reader.setSeries(iSeries - 1);
iPlane = reader.getIndex(iZ - 1, iC -1, iT - 1) + 1;
I = bfGetPlane(reader, iPlane);
            
            
            data = bfopen(sourcePath);
            nSeries = size(data,1);
            j = 0;
            if ( exist('seriesId', 'var') )
                nSlices = size( data{seriesId,1}, 1 );
                for l = 1:nSlices
                    j = j + 1;
                    image(:,:,j) = data{seriesId,1}{l,1};
                end
            else
                for k = 1:nSeries
                    nSlices = size( data{k,1}, 1 );
                    for l = 1:nSlices
                        j = j + 1;
                        image(:,:,j) = data{k,1}{l,1};
                    end
                end
            end
        otherwise
    end
end
