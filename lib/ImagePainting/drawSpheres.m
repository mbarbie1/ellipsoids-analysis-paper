function img = drawSpheres( img, center, pixelSize, value, radius, contour )

    img = squeeze(img);
    sizeImg = imsize(img);
    if (length(radius) == 1)
        sz = 2*ceil(radius./pixelSize)+1;
        tmpx = xx( sz );
        tmpy = yy( sz );
        tmpz = zz( sz );
        borderCoords = sqrt( (tmpx*pixelSize(1)).^2 + (tmpy*pixelSize(2)).^2 + (tmpz*pixelSize(3)).^2 ) <= radius;
        if ( contour > 0)
            borderCoords = borderCoords - berosion(borderCoords,contour,1,1);
        end
        borderCoordsX = double(dip_array(squeeze(tmpx(borderCoords))));
        borderCoordsY = double(dip_array(squeeze(tmpy(borderCoords))));
        borderCoordsZ = double(dip_array(squeeze(tmpz(borderCoords))));
        center = double(center);

        nSpheres = size(center,1);
        for k = 1:nSpheres
            coordsX = center(k,1) + borderCoordsX;
            coordsY = center(k,2) + borderCoordsY;
            coordsZ = center(k,3) + borderCoordsZ;
            coords = removeCoordinatesOutOfBounds( [coordsX; coordsY; coordsZ], [0 0 0], size(img) - [1,1,1] );
            img(sub2ind(img, coords')) = value(k);
        end
    else
        for k = 1:length(center(:,1))
            sz = 2*ceil(radius(k)./pixelSize)+1;
            tmpx = xx( sz );
            tmpy = yy( sz );
            tmpz = zz( sz );
            borderCoords = sqrt( (tmpx*pixelSize(1)).^2 + (tmpy*pixelSize(2)).^2 + (tmpz*pixelSize(3)).^2 ) <= radius(k);
            if ( contour > 0 )
                borderCoords = borderCoords - berosion(borderCoords,contour,1,1);
            end
            borderCoordsX = double(dip_array(squeeze(tmpx(borderCoords))));
            borderCoordsY = double(dip_array(squeeze(tmpy(borderCoords))));
            borderCoordsZ = double(dip_array(squeeze(tmpz(borderCoords))));

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
                clear coords;

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
end
