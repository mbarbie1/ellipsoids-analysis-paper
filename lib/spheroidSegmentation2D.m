function [imgMIPZ, imgMIPZH, lab, imgContour] = spheroidSegmentation2D( img, fctOps )
% -----------------------------------------------------------------------
% 
% FUNCTION: Segmentation algorithm for 3D image stacks using the 2D MIP or/ 
%           and the height view of the stack. Options for the algorithms
%           are "simple thresholding", "heightmap homogeneity based",
%           "heightmap homogeneity with gray-values", "hessian eigenvalues
%           based.
% 
% AUTHOR: 
% 
% 	Micha�l Barbier
%   mbarbie1@its.jnj.com
% 
% -----------------------------------------------------------------------
%


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
            minSpheroidArea = ceil( pi );
            lab = label( mask, inf, minSpheroidArea, 0 );
        case 'heightmap'
            t = 0;
            % AUTOMATIC COMPUTATION OF PARAMETERS
            if (fctOps.neighbourhoodRadiusAutomatic)
                % TODO: add a more useful derived value
                fctOps.neighbourhoodRadius = 3.1 * fctOps.pixelSize(1);
            end
            if (fctOps.maxRangeZAutomatic)
                kernelSize = 2 * max( 1, round( fctOps.neighbourhoodRadius / fctOps.pixelSize(1) ) )  +  1;
                minH = min(imgMIPZH);
                maxH = max(imgMIPZH);
                img_range = dip_image( rangefilt( dip_array(imgMIPZH), true(kernelSize) ) );
                %diphist(img_range,'all');
                [histH,binsH] = diphist(img_range,'all');
				%disp(firstPeakWidth(histH));
                fctOps.maxRangeZ = firstPeakWidth(histH) * fctOps.pixelSize(3);
				%disp(fctOps.maxRangeZ);
            end
            lab = segmentHeightMap2D_noFilter( ...
                imgMIPZ, imgMIPZH, fctOps.pixelSize, ...
                fctOps.neighbourhoodRadius, fctOps.maxRangeZ, ...
                fctOps.removeBorderObjectsInZ, ...
                fctOps.borderZRemoveMethod);
%             lab = segmentHeightMap2D( ...
%                 imgMIPZ, imgMIPZH, fctOps.pixelSize, fctOps.minRadius, ...
%                 fctOps.neighbourhoodRadius, fctOps.maxRangeZ, ...
%                 fctOps.removeBorderObjectsInPlane, fctOps.removeBorderObjectsInZ, ...
%                 fctOps.borderZRemoveMethod, fctOps.thresholdIntensity);
        case 'greyHeightmap'
            t = 0;
            lab = segmentGreyHeightMap2D_noFilter(...
                imgMIPZ, imgMIPZH, fctOps.pixelSize, ...
                fctOps.neighbourhoodRadius, fctOps.maxRangeZ, ...
                fctOps.removeBorderObjectsInZ, ...
                fctOps.borderZRemoveMethod, fctOps.thresholdIntensity, fctOps.minProbability);
        case 'hessianEigenvalues'
            t = 0;
            lab = SegmentThresholdHessianEigenvalues2D(imgMIPZ, fctOps.minRadius, fctOps.maxRadius, 3, fctOps.noiseThresh, fctOps.thresholdRatio);
        otherwise
            warning('no method chosen, assumed simple method')
	end
	if (fctOps.thresholdIntensityAutomatic)
		fctOps.thresholdIntensity = mean( imgMIPZ(lab == 0) );
		%disp('Automatic threshold:')
		%disp(fctOps.thresholdIntensity)
	else
		%disp('Manual threshold:')
		%disp(fctOps.thresholdIntensity)
	end
	lab = filterSegmentation2D( lab, imgMIPZ, fctOps.pixelSize, fctOps.minRadius, fctOps.maxRadius, fctOps.removeBorderObjectsInPlane, fctOps.thresholdIntensity);

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

function w = firstPeakWidth(x)
	
	[xPeaks, yPeaks, atBorderPeak] = slowLocalMaxima(x);
    [xDips, yDips, atBorderDip] = slowLocalMaxima(-x); yDips = -yDips;

	w = xDips(1); %- xPeaks(1);


end
	
function [xPeaks, yPeaks, atBorder] = slowLocalMaxima(x, varargin)

    % Defaults
    startSlope = 1;
    stopSlope = -1;
    if nargin > 1, startSlope = varargin{1};end
    if nargin > 2, stopSlope = varargin{2};end


    dLeft = -[startSlope,x(2:end)-x(1:(end-1))];
    dRight = -[-x(2:end)+x(1:(end-1)),-stopSlope];
    xPeaksTemp = find( double( dLeft < 0 & dRight < 0 ) );
    yPeaksTemp = x( dLeft < 0 & dRight < 0 );
    xQ = double( dLeft == 0 & dRight == 0 );
    xQL = double( dLeft < 0 & dRight == 0 );
    xQR = double( dLeft == 0 & dRight < 0 );
    ll = 0*xQ;


    d = 0;
    flatR = 0;
    maxLocation = [];
    maxLocationInteger = [];
    maxValue = [];

    for i = 2:length(x)

        if ( ( xQR(i) && xQL(i-1) ) )
            ll((i-1):i) = 1;
            maxLocation(end+1) = mean( (i-1):i );
            maxLocationInteger(end+1) = i;
            maxValue(end+1) = x(i);
        end
        if ( ( xQR(i) && xQ(i-1) ) && d > 0 && flatR )
            ll((i-d-1):i) = 1;
            maxLocation(end+1) = mean( (i-d-1):i );
            maxLocationInteger(end+1) = ceil( mean( (i-d-1):i ) );
            maxValue(end+1) = x(i);
        end
        if ( ( xQ(i) && xQL(i-1) ) )
            flatR = 1;
        end
        if ( flatR && xQ(i) )
            d = d + 1;
        else
            d = 0;
            flatR = 0;
        end

    end
   
    xPeaks = [xPeaksTemp, maxLocation];
    yPeaks = [yPeaksTemp, maxValue];
    atBorder = xPeaks == 1 | xPeaks == length(x);

end