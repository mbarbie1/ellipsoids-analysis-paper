% -----------------------------------------------------------------------
% 
% FUNCTION: loadYokogawaStack.m
% 
% DESCRIPTION: Loads a z-stack as an image sequence 
%                in a directory written as typically
%                by our CV7000 image reader. User input is all the
%                parameters except for the z-index of the image.
% 
% INPUT: 
%           imageDir                  : source directory of the images
%           plateLabel                : prefix of the images
%           wellLabel                 : wellLabel of the image of interest
%           tInd                      : time index of the image of interest
%           fInd                      : field index of the image of interest
%           lInd                      : l index of the image of interest
%           aInd                      : action index of the image of interest
%           cInd                      : channel index of the image of interest
%
% OUTPUT:
%           img                     : image (dipimage 3D image)
%
% AUTHOR: 
% 
% 	Michaël Barbier
%   mbarbie1@its.jnj.com
% 
% ----------------------------------------------------------------------- 
%
function img = loadYokogawaStack( imageDir, plateLabel, wellLabel, tInd, fInd, lInd, aInd, cInd)

    % [platename]_C03_T0001F001L01A01Z01C05
    tLabel = ['T' sprintf('%04d', tInd)];
    fLabel = ['F' sprintf('%03d', fInd)];
    lLabel = ['L' sprintf('%02d', lInd)];
    aLabel = ['A' sprintf('%02d', aInd)];
    cLabel = ['C' sprintf('%02d', cInd)];
    
    imageLabel = [tLabel, fLabel, lLabel, aLabel, '*', cLabel];
    imageName =  [plateLabel '_' wellLabel '_' imageLabel '.tif'];
    fileList = dir( fullfile( imageDir, imageName ) );
    if ( ~isempty(fileList) )
    else
        msgID = 'loadYokogawaStack:fileListIsEmpty';
        msg = ['The list of files having the pattern ' imageName ' is empty.'];
        baseException = MException(msgID,msg);
        throw(baseException)
    end
    
    sizeZ = length(fileList);
    for zInd = 1:sizeZ
        zLabel = ['Z' sprintf('%02d', zInd)];
        imageLabel = [tLabel, fLabel, lLabel, aLabel, zLabel, cLabel];
        imageName =  [plateLabel '_' wellLabel '_' imageLabel '.tif'];
        imageFiles{zInd} = [imageDir '\' imageName];
    end
    
    if ( exist('imageFiles','var'))
        img = loadStackFromImageSequence(imageFiles);
    else
        msgID = 'loadYokogawaStack:noExistingImageFiles';
        msg = 'The list of image files to load did not exist.';
        baseException = MException(msgID,msg);
        throw(baseException)
    end
    
end
