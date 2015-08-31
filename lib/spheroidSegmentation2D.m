function [imgMIPZ, imgMIPZH, lab, imgContour] = spheroidSegmentation2D( img, fctOps )

%%% MIP and heightmap projections

    [imgMIPZ, imgMIPZH] = max(img,[],3);
    clear img;
    imgMIPZ = squeeze(imgMIPZ);
    imgMIPZH = squeeze(imgMIPZH);

%%% 2D SEGMENTATION

    minSpheroidArea = round( pi * ( fctOps.minRadius/fctOps.pixelSize(1) )^2 );
    switch fctOps.segmentationMethod
        case 'threshold'
            if (fctOps.thresholdSigma > 0)
                mip = gaussf( imgMIPZ, fctOps.thresholdSigma );
            else
                mip = imgMIPZ;
            end
            [lab, t] = segmentThresholdSimple(mip, minSpheroidArea*fctOps.pixelSize(1)^2, 10*  pi*fctOps.maxRadius^2, [fctOps.pixelSize(1),fctOps.pixelSize(2)], fctOps.thresholdRatio );
            mask = fillholes(lab>0);
            minSpheroidArea = round( pi * ( fctOps.minRadius/fctOps.pixelSize(1) )^2 );
            lab = label( mask, inf, minSpheroidArea, 0 );
        case 'heightmap'
            t = 0;
            lab = segmentHeightMap2D( ...
                imgMIPZ, imgMIPZH, fctOps.pixelSize, fctOps.minRadius, ...
                fctOps.neighbourhoodRadius, fctOps.maxRangeZ, ...
                fctOps.removeBorderObjectsInPlane, fctOps.removeBorderObjectsInZ, ...
                fctOps.borderZRemoveMethod, fctOps.thresholdIntensity);
        case 'greyHeightmap'
            t = 0;
            lab = segmentGreyHeightMap2D(...
                imgMIPZ, imgMIPZH, fctOps.pixelSize, fctOps.minRadius, ...
                fctOps.neighbourhoodRadius, fctOps.maxRangeZ, ...
                fctOps.removeBorderObjectsInPlane, fctOps.removeBorderObjectsInZ, ...
                fctOps.borderZRemoveMethod, fctOps.thresholdIntensity, fctOps.minProbability);
        case 'hessianEigenvalues'
            t = 0;
            lab = SegmentThresholdHessianEigenvalues2D(imgMIPZ, fctOps.minRadius, fctOps.maxRadius, 3, fctOps.noiseThresh, fctOps.thresholdRatio);
        otherwise
            warning('no method chosen, assumed simple method')
    end
    

%%% SPLIT (AND MERGE)

    if ( fctOps.splitSpheroids )
        if ( strcmp( fctOps.splitSpheroidsMethod, 'gray') )
            fctOps.watershed_max_depth = 13000;
            fctOps.watershed_max_size = round(pi*(20*fctOps.minRadius)^2);
            lab = splitGreyWaterShed2D( lab, imgMIPZ, fctOps.pixelSize, fctOps.minRadius, fctOps.minRadius, fctOps.watershed_max_depth, fctOps.watershed_max_size );
        else
            lab = splitWaterShed2D( lab, fctOps.pixelSize, fctOps.minRadius,  fctOps.minRadius );
        end
    end
    
%%% OUTPUT CONTOUR

%    imgContour = createContourOverlay( stretch(imgMIPZ,1,99), lab );
    imgContour = createContourOverlay( stretch(imgMIPZ), lab );

end
