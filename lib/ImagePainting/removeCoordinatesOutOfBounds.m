function coords = removeCoordinatesOutOfBounds( coords, start, stop )

    [nDims, n] = size( coords );
    b = true( 1, n );
    for k = 1:nDims
        b = b & ~( coords(k,:) < start(k) ); 
        b = b & ~( coords(k,:) > stop(k) );
    end
    coords = coords(:,b);
    
end
