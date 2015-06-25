% This function wraps the processes necessary to write an image 
% to a file together/separate with metadata and the options/methods of doing it
%
%   INPUT:
%       image               : array representing the image
%       metadata            : struct representing the image metadata
%       imageDestinationPath: path of the file to write to
%       outputFormat        : [ 'jp2' | 'png' | 'tif' ]
%       bitDepth            : [ 'uint8' | 'uint16' ]
%       color               : [ 'rgb' | 'gray' ]
%       ioMethod            : [ 'Bioformats'  | 'Matlab' ]
%       metaAttached        : [ true  | false ]
%       metaSeperate        : [ true  | false ]
%       metaOutputType      : [ 'json'  | ... ]
%       metaTag             : [ 'json'  | ... ]
function outputImage(image, metadata, imageDestinationPath, outputFormat, bitDepth, color, ioMethod)

    writeImage(image, imageDestinationPath, outputFormat, bitDepth, color, ioMethod)

end
