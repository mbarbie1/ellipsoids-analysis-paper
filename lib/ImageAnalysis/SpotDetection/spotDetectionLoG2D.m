% FUNCTION: 2D LoG method to detect bright spots in the MIP of a 3D image and use 
%           the height map to find the z-coordinate of the spots.
%
% INPUT:
%
%            imgMIPZ                    :
%            imgMIPZH                   :
%            lab                        :
%            pixelSizeR                 :
%            avgSpotRadius              :
%            maxSpotRadius              : 
%            maxSpotDetectorRatio       :
%
% OUTPUT:
%
%            outputMaxima               : struct array with: the position 
%                                           in (x,y,z), max. intensity, and
%                                           spheroid-index in which the
%                                           point originates.
%            outputLab                  : image with labeled points at the
%                                           positions of the found spots.
%
% AUTHOR: 
%
% 	Michaël Barbier
%   mbarbie1@its.jnj.com
% 
% ----------------------------------------------------------------------- 
%
function [outputMaxima, outputLab] = spotDetectionLoG2D(imgMIPZ, imgMIPZH, lab, pixelSizeR, avgSpotRadius, maxSpotRadius, maxSpotDetectorRatio)

    radiusToGaussianScale = 1/2;
    scale = avgSpotRadius * radiusToGaussianScale / pixelSizeR;
    imgLoG = laplace(imgMIPZ, scale ) .* scale^2;
    %%% SMOOTH THE SPOTIMAGE TO REMOVE THE NOISE WHEN FINDING THE MAXIMA
    imgMIPZ = gaussf(imgMIPZ, scale);
    imgt = threshold(-imgLoG,'otsu');
    imgt(-imgLoG < maxSpotDetectorRatio * max(-imgLoG)) = 0;

    maxIntensity = max(imgMIPZ);
    minIntensity = min(imgMIPZ);
    max_depth = round( ( maxIntensity - minIntensity ) * 0.5 );
    max_size = ceil( ( maxSpotRadius / pixelSizeR )^2 * pi );
    imgw = dip_localminima(imgLoG, imgt, 2, max_depth, max_size, 1);
    
    spotListXY = ind2sub(imgw,find(imgw));
    outputLab = imgw;
    for k = 1:length(spotListXY(:,1))
        outputMaxima(k).x = spotListXY(k,1);
        outputMaxima(k).y = spotListXY(k,2);
        outputMaxima(k).z = dip_array(imgMIPZH(spotListXY(k,1), spotListXY(k,2))); % + 1 to change to 1-based indices instead of zero-based
        outputMaxima(k).intensity = dip_array( imgMIPZ(spotListXY(k,1), spotListXY(k,2)) );
        outputMaxima(k).inputLabIndex = dip_array( lab(spotListXY(k,1), spotListXY(k,2)) );
        outputLab(spotListXY(k,1), spotListXY(k,2)) = k;
    end

end
