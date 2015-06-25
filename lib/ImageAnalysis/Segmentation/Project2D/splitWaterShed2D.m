function lab = splitWaterShed2D( lab, pixelSize, minRadius, minSpheroidRadius )

    %%% SPLIT (AND MERGE)

    imgDist = dt( lab>0, 1, 'true' );
    max_depth = minSpheroidRadius / pixelSize(1); % TODO: find a 
    % sensible parameter for the max_depth: I guess that the 
    % distance/depth which should be merged is the minimal radius of 
    % a spheroid (but in the hoechst this might be the size of a 
    % single nucleus)
    max_size = 0;
    imgDist = max(imgDist)-imgDist;
    imgSeed = minima( imgDist, 2, false );
    imgW = waterseed( imgSeed, imgDist, 2, max_depth, max_size );
    % TODO: find an alternative for the dilation of the separation
    % lines, which serves to have lines thick enough too split two
    % binary objects with connectivity = 2. (or label with connectivity
    % = 1, but this can be tricky.
    % --------------- OK ------------  changed the connectivity of the
    % waterseed algorithm
    minSpheroidArea = round( pi * ( minRadius/pixelSize(1) )^2 );
    lab = label( (lab>0) .* ~imgW, inf, minSpheroidArea, 0 );

end
