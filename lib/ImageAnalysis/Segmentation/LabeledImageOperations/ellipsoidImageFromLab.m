function [ blobImages, maskImages, range, origin ] = ellipsoidImageFromLab( lab, img, nExtend)
% ellipsoidImageFromLab: Returns a cell array of subimages of the image 'img',
% where for each subimage the bounding box of the object (from 'lab') 
% in the 3D labeled image is used. An ellipsoid is fitted to each of the
% labeled regions.
%
%   INPUT:  
%       lab               : the labeled image
%       img               : the image-stack
%       nExtend           : Extending the bounding box in each direction by
%                               nExtend
%
%   OUTPUT:  
%       blobImages        : The subimages of the image big enough to fit
%                              the largest ellipsoid possible (derived from 
%                              the largest major ellipsoid axis)
%       maskImages        : The ellipsoidal masks of the subimages
%       range             : The range of indices of the subimages
%       origin            : The origin indices of the subimage

    msr = measure(lab, img, {'Center','DimensionsEllipsoid','MajorAxes'}, [], 1, 0, 0);

    sz = imsize(img);
    ellipseRadii = msr.DimensionsEllipsoid/2;
    maxSide = ceil( sqrt(2) * max( abs( ellipseRadii ) ) );
    maxCoord = ceil(msr.Center + [maxSide; maxSide; maxSide]);
    minCoord = floor(msr.Center - [maxSide; maxSide; maxSide]);
    maxCoord = maxCoord + nExtend * ones(size(maxCoord));
    minCoord = minCoord - nExtend * ones(size(maxCoord));
    maxCoord = min( repmat( sz', 1, size(maxCoord,2) ), maxCoord );%-[1;1;1]
    minCoord = max( 0*minCoord, minCoord );

    range = maxCoord - minCoord;
    origin = minCoord;
    for k = 1:length(range(1,:))
        imgCutSize = [ range(1,k), range(2,k), range(3,k)];
        origin3D = [origin(1,k), origin(2,k), origin(3,k)];
        maskImages{k} = getEllipsoidMask( imgCutSize, msr.Center(:,k)-origin(:,k), msr.MajorAxes(:,k), ellipseRadii(:,k));
        blobImages{k} = cut(img,imgCutSize,origin3D);
    end

end
