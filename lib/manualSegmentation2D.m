function [mip, mipH, lab, imgContour, roi] = manualSegmentation2D( img, roi, fctOps )

%%% MIP and heightmap projections

    [mip, mipH] = max(img,[],3);
    clear img;
    mip = squeeze(mip);
    mipH = squeeze(mipH);

%%% 2D SEGMENTATION FROM ROI

    minSpheroidArea = round( pi * ( fctOps.minRadius/fctOps.pixelSize(1) )^2 );

    n = length(roi);
    % segmentation measurements
    msrFields = {'size','center','Maximum','Minimum','Radius','ConvexArea','P2A','Feret','PodczeckShapes',...
        'mean','StdDev','MinVal','MaxVal','Skewness','ExcessKurtosis', 'MajorAxes', 'DimensionsEllipsoid'};
    imgCell = {mip};

    %colorType = struct(...
    %    'color', {[255,0,0],[0,255,0],[0,0,255],[0,255,255],[255,0,255]}, ...
    %    'type', {1,2,3,4,5}, ...
    %    'name', {'separated','obscured','border','touching','not-obscured'} ...
    %    );

    % ROI gets updated and now contains new field such as:
    %   roi{j}.argb: color of the contour in [a,r,g,b] with each in the
    %                   range of 0..255
    %   roi{j}.type: index of the type of the class: 1, 2, ...
    %   roi{j}.name: name of the class: touching, obscured, ... 
    %   roi{j}.mask: dipimage submask of the contour
    %   roi{j}.minp: upper left corner coordinates of the bounding box
    %   roi{j}.maxp: lower right corner coordinates of the bounding box
    %   roi{j}.pRel: relative coordinates of the contour to the bounding
    %                   box
    %   roi{j}.pAbs: absolute coordinates of the contour
    %   roi{j}.img: cell array of sub-images (mip, heightmap, ...) 
    %   roi{j}.msr: measurements
    roi = roiToMasks_RoiManager_nameBased(roi, imgCell, mipH, msrFields);
    lab = roiToLab_RoiManager(roi, imsize(mip));

%%% OUTPUT CONTOUR
%    imgContour = createContourOverlay( stretch(imgMIPZ,1,99), lab );
%    imgContour = createContourOverlay( stretch(mip), lab );
    imgContour = stretch(mip);
    contourLab = newim(size(imgContour));
    for k = 1:n
        contourLab( sub2ind( contourLab, roi{k}.pAbs-1 ) ) = k;
    end
    imgContour = overlay(imgContour, contourLab);
end
