function lab = splitGreyWaterShed2D( lab, img, pixelSize, minRadius, minSpheroidRadius, max_depth, max_size )

    %%% SPLIT (AND MERGE)

    imgDist = gdt( lab>0, img, 3);
    if ( ~exist('max_depth','var') )
        max_depth = minRadius / pixelSize(1); % TODO: find a 
    end
    if ( ~exist('max_size','var') )
        max_size = 0;
    end
    % sensible parameter for the max_depth: I guess that the 
    % distance/depth which should be merged is the minimal radius of 
    % a spheroid (but in the hoechst this might be the size of a 
    % single nucleus)
    imgDist = max(imgDist)-imgDist;
    imgSeed = minima( imgDist, 2, false );
    imgW = waterseed( imgSeed, imgDist, 2, max_depth, max_size );
    % TODO: find an alternative for the dilation of the separation
    % lines, which serves to have lines thick enough too split two
    % binary objects with connectivity = 2. (or label with connectivity
    % = 1, but this can be tricky.
    % --------------- OK ------------  changed the connectivity of the
    % waterseed algorithm
    minSpheroidArea = round( pi * ( minSpheroidRadius/pixelSize(1) )^2 );
    lab = label( (lab>0) .* ~imgW, inf, minSpheroidArea, 0 );

    %contourImg = overlay(stretch(imgDist),imgW);
    %dipshow(contourImg);

end

