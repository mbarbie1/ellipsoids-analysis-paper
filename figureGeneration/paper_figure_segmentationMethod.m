function [ subMIP, subOverlaySegmentation2D, subHeightView, subRangeHeight ] = paper_figure_segmentationMethod( img, options )

    subStartX = 0;
    subStopX = 410;
    subStartY = 365;
    subStopY = 615;

    pixelSize = options.pixelSize;
    % Maximal intensity projection
    [imgMIPZ, imgMIPZH] = zProject( img );
    % the actual segmentation algorithm
    lab = segmentHeightMap2D( ...
        imgMIPZ, imgMIPZH, pixelSize, options.minRadius, ...
        options.neighbourhoodRadius, options.maxRangeZ, ...
        options.removeBorderObjectsInPlane, options.removeBorderObjectsInZ, ...
        options.borderZRemoveMethod, options.thresholdIntensity);
    lab = label(lab>0);

    imgM = imgMIPZ;
    imgH = imgMIPZH;
    kernelSize = 2 * max( 1, round( options.neighbourhoodRadius / options.pixelSize(1) ) )  +  1;
    rangeHeight = dip_image( rangefilt( dip_array(imgH), true(kernelSize) ) );
    
    minHisto = 0;
    maxHistoMIP = 2000;
    maxHistoHeight = max(imgH);
    [histoM,binsM] = diphist(imgM,[minHisto, maxHistoMIP]);
    [histoH,binsH] = diphist(rangeHeight,[minHisto, maxHistoHeight]);
    figure();
    bar((binsM),(histoM));
    figure();
    bar(binsH,histoH,5);

    subMIP = imgM(subStartX:subStopX,subStartY:subStopY);
    subOverlaySegmentation2D = createContourOverlay(stretch(imgM(subStartX:subStopX,subStartY:subStopY),1,99.9),lab(subStartX:subStopX,subStartY:subStopY));
    subHeightView = imgH(subStartX:subStopX,subStartY:subStopY);
    subRangeHeight = rangeHeight(subStartX:subStopX,subStartY:subStopY);
    dipshow(stretch(subMIP,1,99.9));
    dipshow(stretch(subOverlaySegmentation2D));
    dipshow(stretch(subHeightView));
    dipshow(stretch(subRangeHeight));

end
