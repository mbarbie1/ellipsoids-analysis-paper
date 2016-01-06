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
function [spotTable, outputMaxima, spotLab] = spotDetection3D(img, lab, pixelSize, mode, avgSpotRadius, maxSpotRadius, maxSpotDetectorRatio)

    fprintf('Process: spotDetection3D\n');
    tic;

    radiusToGaussianScale = 1/2;
    s = avgSpotRadius * radiusToGaussianScale ./ pixelSize;

    [imgMIPZ, imgMIPZH] = max(img,[],3);
    imgMIPZ = squeeze(imgMIPZ);
    imgMIPZH = squeeze(imgMIPZH);
    
    switch mode

        case '2D'
            sz = imsize(img);
            clear img;
            [outputMaxima, ~] = spotDetectionLoG2D(imgMIPZ, imgMIPZH, lab, pixelSize(1), avgSpotRadius, maxSpotRadius, maxSpotDetectorRatio);
            spotLab = newim(sz);
            nSpots = length(outputMaxima);
            spotLab(  sub2ind( spotLab, double( [ [outputMaxima(:).x]', [outputMaxima(:).y]', [outputMaxima(:).z]' ] ) ) ) = 1:nSpots;
            spotTable = outputMaxima';

        case '3D'
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

        case 'tiled3D'
 
            sz = imsize(img);
            nTileX = 2;
            nTileY = 2;
            nTiles = nTileX * nTileY;
            h1 = round( linspace( 0, sz(1)-1, nTileX+1 ) );
            h2 = round( linspace( 0, sz(2)-1, nTileY+1 ) );
            for i = 1:nTileY
                for j = 1:nTileX
                    t = (i-1) * nTileX + j;
                    c1{t} = h1(j):h1(j+1);
                    c2{t} = h2(i):h2(i+1);
                end
            end
            
            imgOrig = img;
            labOrig = lab;
            clear img lab;
            for t = 1:nTiles
                img = imgOrig(c1{t},c2{t},:);
                lab = labOrig(c1{t},c2{t});

                imgLoG = laplacianNormalized3D(img, s(1), s(2), s(3));
                imgt = -imgLoG > maxSpotDetectorRatio * max(-imgLoG);
                max_size = ceil( getVolumeSphere(maxSpotRadius) / prod(pixelSize) );
                spotLab = dip_localminima(imgLoG, imgt, 2, 0, max_size, 1);
                spotList = ind2sub( spotLab, find(spotLab) );
                nSpots = length(spotList(:,1));
                spotList = spotList + repmat( [c1{t}(1), c2{t}(1), 0 ], nSpots, 1 );
                spotLab = newim(size(spotLab));

                spotListTemp{t} = spotList;
                spotLabTemp{t} = dip_array(spotLab);
            end

            spotList = vertcat(spotListTemp{:});
            nSpots = length(spotList(:,1));

            spotLabTempCell = reshape( spotLabTemp, nTileX, nTileY);
            spotLab = dip_image( cell2mat( spotLabTempCell' ) );

            outputMaxima = struct(...
                    'x',num2cell(spotList(:,1)),...
                    'y',num2cell(spotList(:,2)),...
                    'z',num2cell(spotList(:,3)), ...
                    'intensity', num2cell(spotList(:,3)), ...
                    'inputLabIndex', num2cell(spotList(:,3)) ...
                );
            zz = num2cell( int32( imgOrig( sub2ind(imgOrig, double([spotList(:,1),spotList(:,2),spotList(:,3)])) ) ) );
            [outputMaxima(:).intensity] = zz{:};
            zz = num2cell( int32( labOrig( sub2ind(labOrig, double([spotList(:,1),spotList(:,2)])) ) ) );
            [outputMaxima(:).inputLabIndex] = zz{:};
            spotLab(  sub2ind(spotLab, double([spotList(:,1),spotList(:,2),spotList(:,3)])) ) = 1:nSpots;

            % t = (iy-1) * nTileX + ix; (ix is the inner loop, happens first)
            spotTable = outputMaxima;

        otherwise
            error('spotDetection3D: no valid spot detection method (mode) chosen')
    end

    endTime = toc();
    fprintf('spotDetection3D: time duration: %s\n', num2str(endTime));

end
