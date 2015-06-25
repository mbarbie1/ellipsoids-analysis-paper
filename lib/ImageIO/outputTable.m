% This function wraps the processes necessary to write an table 
% to a file together/separate with metadata which refers to the image/
% calculation where it originates from.
%
%   INPUT:
%       table               : array struct representing the table
%       metadata            : struct representing the table metadata, that
%                               is the reference to the original image /
%                               algorithm which led to the results?
%       destinationPath     : path of the file to write to
%       outputFormat        : [ 'json' | 'prtools'? | 'hdf5'? | 'mat'? | 
%                                   'csv'? ]
%       ioMethod            : [ 'Bioformats'  | 'Matlab' ]
%       metaAttached        : [ true  | false ]
%       metaOutputType      : [ 'json'  | ... ]
%
function outputTable(table, metadata, tableDestinationPath, outputType)


end
