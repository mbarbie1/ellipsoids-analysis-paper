function [ overlaySegmentation2D, overlayTop, overlaySide, lab, lab2D, lab3D ] = paper_figure_ellipsoidFit( imgRFP, options )

    pixelSize = options.pixelSize;
    % Maximal intensity projection
    [imgMIPZ, imgMIPZH] = zProject( imgRFP );
    % the actual segmentation algorithm
    lab = segmentHeightMap2D( ...
        imgMIPZ, imgMIPZH, pixelSize, options.minRadius, ...
        options.neighbourhoodRadius, options.maxRangeZ, ...
        options.removeBorderObjectsInPlane, options.removeBorderObjectsInZ, ...
        options.borderZRemoveMethod, options.thresholdIntensity);
    lab = label(lab>0);

    % Ellipse and ellipsoid fitting procedure 
    [lab2D, center3D, principalAxesList3D, axesDimensionsList3D, cprof] = fitSpheroidAxes(imgRFP, imgMIPZ, imgMIPZH, lab, pixelSize, options.centerMethod, options.zRadiusMethod);
    value = 1:size(center3D,1);
    lab3D = drawEllipsoids( newim(size(imgRFP)), [1 1 1],  center3D, value, principalAxesList3D, axesDimensionsList3D, 0 );
    lab3D = dip_image(lab3D,'uint16');
    % Plotting the middle slices of the spheroids, add the ellipse contours, and construct a mosaic
    % image
    [imgSH, labTop, overlayTop] = topSliceProjection( imgRFP, imgMIPZH, lab, []);
    % Plotting the middle slices of the spheroids along the side projection, add the ellipse contours and construct a mosaic
    % image
    %[ imgSide, labSide, overlaySide ] = sideSliceProjection( imgRFP, imgMIPZH, lab, pixelSize);
    [ imgSide, labSide, overlaySide ] = sideSliceProjection( imgRFP, imgMIPZH, lab, pixelSize, center3D, principalAxesList3D, axesDimensionsList3D );
    % Overlay the MIP with the segmentation mask in 2D
    % image
    overlaySegmentation2D = createContourOverlay(stretch(imgMIPZ,1,99.9), lab);
    % Show the above images
    dipshow(overlaySegmentation2D);
    dipshow(overlayTop);
    dipshow(overlaySide);

end
