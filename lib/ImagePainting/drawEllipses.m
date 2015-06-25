%   img        : The image as a dipimage object
%   center     : centers of the spheroids, an array with nSpheroid rows and
%                2 columns ( col 1: x and col 2: y coordinates )
%   value      : value of the labelIndex used for the ellipse pixels
%   principalAxesList    : The principal axes of the spheroids, Cell array
%                           with a cell array for every spheroid containing
%                           the 2 basis vectors as ?column? vectors.
%                           (normalized vectors)
%   axesDimensionsList   : Dimensions of the principal axes. Cell array
%                           with for every spheroid a vector containing the
%                           lengths of the basis vectors.
%   contour    : represents the thickness of the contour of the ellipse, if
%                it is 0 then the ellipse is filled.
function img = drawEllipses( img, center, value, principalAxesList, axesDimensionsList, contour )

    img = squeeze(img);

    n = length(center(:,1));
    for k = 1:n
        principalAxes = principalAxesList{k};
        axesDimensions = axesDimensionsList{k};
        
        halfBoxSide = ellipsoidBoundingBox(axesDimensions, principalAxes);
        sz = 2*ceil(halfBoxSide)+1;

        b1 = principalAxes{1};
        b2 = principalAxes{2};
        N = (axesDimensions).^2;

        X = xx( sz );
        Y = yy( sz );

        borderCoords = ( ( (X.*b1(1) + Y.*b1(2) ).^2 ./ N(1) )...
                +  ( (X.*b2(1) + Y.*b2(2) ).^2 ./ N(2) ) ) < 1;

        if (contour == 0)
        else
            if (contour > 1)
                borderCoords = borderCoords - berosion(borderCoords,contour,1,1);
            else
                if (contour == 1)
                    borderCoords = borderCoords - berosion(borderCoords,1,1,1);
                end
            end
        end

        borderCoordsX = dip_array(squeeze(X(borderCoords)));
        borderCoordsY = dip_array(squeeze(Y(borderCoords)));

        coordsX = center(k,1) + borderCoordsX;
        coordsY = center(k,2) + borderCoordsY;
        coords = removeCoordinatesOutOfBounds( [coordsX; coordsY], [0 0], size(img) - [1,1] );
        img(sub2ind(img, coords')) = value(k);

    end

end
