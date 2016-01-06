% FUNCTION: 3D LoG method to detect bright spots in the MIP of a 3D image.
%
% INPUT:
%
%            img                        : 3D image
%            lab                        : 2D labeled image
%            pixelSizeR                 : pixel size in the plane: x or y (
%                                           should be the same)
%            avgSpotRadius              : average radius of the spots
%            maxSpotRadius              : maximal radius for a spot
%
% OUTPUT:
%
%            outputMaxima               : struct array with: the position 
%                                           in (x,y,z), max. intensity, and
%                                           spheroid-index in which the
%                                           point originates.
%            outputLab                  : 3D image with labeled points at 
%                                           the positions of the found 
%                                           spots.
%            spotTable                  : output maxima transosed to be
%                                           suitable as MATLAB table.
%
% AUTHOR: 
%
% 	Michaël Barbier
%   mbarbie1@its.jnj.com
% 
% ----------------------------------------------------------------------- 
%
function [spotTable, outputMaxima, spotLab] = spotDetectionTiled3D(img, lab, pixelSize, mode, avgSpotRadius, maxSpotRadius, maxSpotDetectorRatio)

    fprintf('Process: spotDetection3D\n');
    tic;

    radiusToGaussianScale = 1/2;
    s = avgSpotRadius * radiusToGaussianScale ./ pixelSize;

    [imgMIPZ, imgMIPZH] = max(img,[],3);
    imgMIPZ = squeeze(imgMIPZ);
    imgMIPZH = squeeze(imgMIPZH);


        imgLoG = laplacianNormalized3D(img, s(1), s(2), s(3));
        imgt = -imgLoG > maxSpotDetectorRatio * max(-imgLoG);
            max_size = ceil( getVolumeSphere(maxSpotRadius) / prod(pixelSize) );
            spotLab = dip_localminima(imgLoG, imgt, 2, 0, max_size, 1);
            spotList = ind2sub( spotLab, find(spotLab) );
            spotLab = newim(size(spotLab));
            nSpots = length(spotList(:,1));
            outputMaxima = struct('x',num2cell(spotList(:,1)),...
                'y',num2cell(spotList(:,2)),...
                'z',num2cell(spotList(:,3)), ...
                'intensity', num2cell(spotList(:,3)), ...
                'inputLabIndex', num2cell(spotList(:,3)) ...
            );
            zz = num2cell( int32( img( sub2ind(img, double([spotList(:,1),spotList(:,2),spotList(:,3)])) ) ) );
            [outputMaxima(:).intensity] = zz{:};
            zz = num2cell( int32( lab( sub2ind(lab, double([spotList(:,1),spotList(:,2)])) ) ) );
            [outputMaxima(:).inputLabIndex] = zz{:};
            spotLab(  sub2ind(spotLab, double([spotList(:,1),spotList(:,2),spotList(:,3)])) ) = 1:nSpots;
            spotTable = outputMaxima;

        otherwise
            error('spotDetection3D: no valid spot detection method (mode) chosen')
    end

    endTime = toc();
    fprintf('spotDetection3D: time duration: %s\n', num2str(endTime));

end
