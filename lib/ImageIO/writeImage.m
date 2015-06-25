% This function writes an image to a file of certain format, bitdepth,
% using either Matlab image toolbox either Bioformats
% metadata attachment is only possible in bioformats
%
%   INPUT:
%       image               : array representing the image
%       destinationPath     : path of the file to write to
%       outputFormat        : [ 'jp2' | 'png' | 'tif' ]
%       bitDepth            : [ 'uint8' | 'uint16' ]
%       color               : [ 'rgb' | 'gray' ]
%       ioMethod            : [ 'Bioformats'  | 'Matlab' ]
function writeImage(image, destinationPath, outputFormat, bitDepth, color, ioMethod)

    switch ioMethod
        % Writing the image using Matlab image toolbox
        case 'Matlab',
            % Writing a Gray image
            if ( strcmp(color,'gray') )
                image = cast(image, bitDepth);
                if (ndims(image) >= 3)
                    nImages = size(image,3);
                    imwrite(image(:,:,1), destinationPath, outputFormat);
                    if (nImages > 1)
                        for k = 2:nImages
                            imwrite(image(:,:,k), destinationPath, outputFormat, 'WriteMode', 'append');
                        end
                    end
                else
                    if (strcmp(outputFormat,'jp2') | strcmp(outputFormat,'jpx'))
                        imwrite(image, destinationPath, outputFormat, 'Mode', 'lossless');
                    else
                        imwrite(image, destinationPath, outputFormat);
                    end
                end
            else
                % Writing a RGB image
                if ( strcmp(color,'rgb') )
                    image = cast(image, bitDepth);
                    if (ndims(image) >= 4)
                        nImages = size(image,3);
                        imwrite(squeeze(image(:,:,1,:)), destinationPath, outputFormat);
                        if (nImages > 1)
                            for k = 2:nImages
                                imwrite(squeeze(image(:,:,k,:)), destinationPath, outputFormat, 'WriteMode', 'append');
                            end
                        end
                    else
                        if (strcmp(outputFormat,'jp2') | strcmp(outputFormat,'jpx'))
                            imwrite(image, destinationPath, outputFormat, 'Mode', 'lossless');
                        else
                            imwrite(image, destinationPath, outputFormat);
                        end
                    end
                end
            end
        % Writing the image using Bioformats
        case 'Bioformats',
            image = cast(image, bitDepth);
            bfsave(image, destinationPath);
        otherwise
    end

end
