% -----------------------------------------------------------------------
% 
% FUNCTION: loadStackFromImageSequence.m
% 
% DESCRIPTION: Loads a 3D image stack from a cell array of the image
%               filenames for the 2D image slices.
% 
% INPUT: 
%           imgFiles               : list of image filenames
%                                       (cell array of strings)
%
% OUTPUT:
%           img                    : image array (dipimage 3D image)
%
% AUTHOR: 
% 
% 	Michaël Barbier
%   mbarbie1@its.jnj.com
% 
% ----------------------------------------------------------------------- 
%
function img = loadStackFromImageSequence(imgFiles)

    info = imfinfo(imgFiles{1});
    num_images = length(imgFiles);
    A = zeros(info(1).Height, info(1).Width, num_images);
    
    for k = 1:num_images
        A(:,:,k) = imread(imgFiles{k});
    end

    img = dip_image(A);

end
