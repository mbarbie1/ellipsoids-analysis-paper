% The pixelSize has to be [1,1,1] because changing the pixelSize could
% make the principal axis non-orthogonal.
% Therefore the pixelSize has to be considered before the calculation of
% the principal axes, such that the ellipsoids axes are defined as if the
% pixelsize would be isotropic. This would be automatically the case when
% using the ellipsoids from a DIP-measurement: BUT: if you subsample the
% image before segmentation and measure in that labeled image the principal
% axes you need to take care that you cannot just scale the axes 
%
% TODO: finding a way to deal with the stretching of an ellipsoid and the
% effect on the principalAxes and axesDimensions
%
% TODO: Problem with adressing large images 2^24 = ( 10^9 / 64 ) pixels is
% already a problem --> e.g. 1000 x 1000 x 50 is too large. We obtain
% stripes in our image. This is because DIPimage seems to use 32-bit.
% Matlab 64-bit can use more (48-bit?). 
% See:          [~, maxSize] = computer
%   -----------------------------------------------------------------------
%   Solution for this moment is to change from DIPimage to matlab array to
%   use the Matlab sub2ind function instead of the DIPimage one. This works
%   because we have a 64-bit Matlab (This gives rise to some (big?) speed
%   reduction probably).
%   -----------------------------------------------------------------------
%
function img = drawEllipsoids( img, pixelSampleSize, center, value, principalAxesList, axesDimensionsList, contour )

    img = squeeze(img);
    %img = dip_image(img, 'uint32');
    sizeImg = size(img);

    n = length(center(:,1));
    for k = 1:n
        principalAxes = principalAxesList{k};
        axesDimensions = axesDimensionsList{k};
        
        halfBoxSide = ellipsoidBoundingBox(axesDimensions, principalAxes);
        sz = 2*ceil(halfBoxSide)+1;

        b1 = principalAxes{1};
        b2 = principalAxes{2};
        b3 = principalAxes{3};
        N = (axesDimensions).^2;

        X = xx( sz );
        Y = yy( sz );
        Z = zz( sz );

        borderCoords = (  ( (X.*b1(1) + Y.*b1(2) + Z.*b1(3)).^2 ./ N(1) )...
            +  ( (X.*b2(1) + Y.*b2(2) + Z.*b2(3)).^2 ./ N(2) )...
            +   ( (X.*b3(1) + Y.*b3(2) + Z.*b3(3)).^2 ./ N(3) )  ) < 1;

        if (contour)
            borderCoords = borderCoords - berosion(borderCoords,contour,1,1);
        end

        borderCoordsX = dip_array(squeeze(X(borderCoords)));
        borderCoordsY = dip_array(squeeze(Y(borderCoords)));
        borderCoordsZ = dip_array(squeeze(Z(borderCoords)));

        coordsX = center(k,1) + borderCoordsX;
        coordsY = center(k,2) + borderCoordsY;
        coordsZ = center(k,3) + borderCoordsZ;

        % This is the check on the size of the image whether we need to
        % use a hack to be able to address the pixels of the whole 
        % image.
        %
        if (log2(64*prod(sizeImg)) < 30)

            % Remove too high/low coordinates
            coords = removeCoordinatesOutOfBounds( [coordsX; coordsY; coordsZ], [0 0 0], sizeImg - [1,1,1] );
            img(sub2ind(img, coords')) = value(k);
            clear coords

        else

            % Remove too high/low coordinates
            b = ~(coordsX > sizeImg(1)-1 | coordsY > sizeImg(2)-1 | ...
                coordsZ > sizeImg(3)-1 | coordsX < 0 | coordsY < 0 | coordsZ < 0);
            coordsX = coordsX(b);
            coordsY = coordsY(b);
            coordsZ = coordsZ(b);

            % Hack to take care of the addressing limit to 30 bits on a 32
            % bit system (used by DIPimage it seems)
            imga = dip_array(img);
            imga(sub2ind(size(imga),coordsY+1,coordsX+1,coordsZ+1)) = value(k);
            img = dip_image(imga);

        end

    end

end
