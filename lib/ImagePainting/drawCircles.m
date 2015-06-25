function img = drawCircles( img, centerX, centerY, value, radius, filled )

    img = squeeze(img);
    if (length(radius) == 1)
        sz = [2*ceil(radius)+1, 2*ceil(radius)+1];
        tmpx = xx( sz );
        tmpy = yy( sz );
        borderCoords = sqrt(tmpx.^2 + tmpy.^2) <= radius;
        if (~filled)
            borderCoords = borderCoords - berosion(borderCoords);
        end
        borderCoordsX = dip_array(squeeze(tmpx(borderCoords)));
        borderCoordsY = dip_array(squeeze(tmpy(borderCoords)));

        for k = 1:length(centerX)
            coordsX = centerX(k) + borderCoordsX;
            coordsY = centerY(k) + borderCoordsY;
            coords = removeCoordinatesOutOfBounds( [coordsX; coordsY], [0 0], size(img)-[1,1] );
            img(sub2ind(img, coords')) = value(k);
        end
    end
end
