%UNTITLED Summary of this function goes here
%   Detailed explanation goes here
function [ p ] = sideSliceProjectionQC( overlaySide, pixelSize, center3D, centerProfiles, spheroidIndexStart, profileStop )

    sz = imsize(overlaySide);
    maxIntensity = max(max(dip_array(overlaySide)));
    overlaySideA = dip_array(overlaySide);
    for m = 1:length(maxIntensity)
        overlaySideA(:,:,m) = overlaySideA(:,:,m) / maxIntensity(m);
    end
    scaleFactor = round(pixelSize(3)/pixelSize(1));

    p = figure('visible','off');
    imagesc([0 sz(1)], [sz(2) 0], flip(overlaySideA,1)); hold on;

    maxIntensityProfiles = 0;
    for j = 1:length(centerProfiles)
        maxIntensityProfiles = max( maxIntensityProfiles, max(centerProfiles{j}) );
    end
    for j = 1:length(profileStop(:,1))
        xx = (1:length( centerProfiles{j}))-1;
        xx2 = linspace( min(xx), max(xx), scaleFactor*length(xx) );
        yy = interp1( xx, double( centerProfiles{j} ), xx2 );
        x1 = center3D(j,1); x2 = center3D(j,1);
        y1 = scaleFactor*(spheroidIndexStart(j)-1); y2 = scaleFactor*(profileStop(j,1)-1);
        [x,y] = bresenham(x1,y1,x2,y2);
        plot(x,y,'b-','linewidth',1.5); hold on;
        plot(center3D(j,1),scaleFactor*center3D(j,3),'r*'); hold on;
        %disp('maxIntensity'); disp(maxIntensityProfiles);
        plot(center3D(j,1) + (yy / maxIntensityProfiles * sz(1)/5), scaleFactor*xx2, 'g-','linewidth',1); hold on;
    end
    axis image
    hold off;
end

