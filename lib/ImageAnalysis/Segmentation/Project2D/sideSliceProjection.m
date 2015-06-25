%%% Side projection with slices of spheroids at the correct depth (middle
%%% of the spheroid
%
% 
% AUTHOR: 
% 
% 	Michaël Barbier         Date: 02/10/2014  (Last changed: 02/10/2014)
%   mbarbie1@its.jnj.com
% 
% ----------------------------------------------------------------------- 
%
function [ imgSide, labSide, overlaySide ] = sideSliceProjection( imgOri, imgMIPZH, lab, pixelSize, center3D, principalAxesList3D, axesDimensionsList3D )

    fprintf('PostProcess: sideSliceProjection2D\n');
    tic;

    sideSize = size(squeeze(imgOri(:,0,:)));

    % separate center variable
    centerY = center3D(:,2);
    centerZ = center3D(:,3);
    n = length(centerZ);

    % Generate the mosaic image
    %
    % Find the bounding box of the labeled spheroids in 2D
    msrL = measure(lab, [], {'minimum', 'maximum'});
    minX = msrL.minimum(1,:);
    minY = msrL.minimum(2,:);
    maxX = msrL.maximum(1,:);
    maxY = msrL.maximum(2,:);
    % use average radii to guess mosaic piece size along z
    rZ = (pixelSize(1)/pixelSize(3)) * (maxX - minX + maxY - minY) / 4;
    minX(minX < 0) = 0;
    maxX( maxX > (sideSize(1)-1) ) = sideSize(1)-1;
    minZ = round( centerZ - rZ(:) - 10);
    maxZ = round( centerZ + rZ(:) + 10);
    minZ(minZ < 0) = 0;
    maxZ( maxZ > (sideSize(2)-1) ) = sideSize(2)-1;
    % put the mosaic pieces together
    imgSide = newim(sideSize);
    for k = 1:n
        plane =  squeeze(imgOri( :, centerY( k ), : ));
        imgSide(minX(k):maxX(k), minZ(k):maxZ(k)) = imgSide(minX(k):maxX(k), minZ(k):maxZ(k)) + plane(minX(k):maxX(k), minZ(k):maxZ(k));
    end

    % Generate the ellipses which are the slices of the ellipsoid in the
    % xz-plane (not projected onto the xz-plane)
    for k = 1:n
        sinw = principalAxesList3D{k}{1}(2);
        cosw = principalAxesList3D{k}{1}(1);
        a = axesDimensionsList3D{k}(1);
        b = axesDimensionsList3D{k}(2);
        %w1 = atan2(principalAxesList3D{k}{1}(2),principalAxesList3D{k}{1}(1));
        %t = atan(- a/b * sinw/cosw );
        %ellipseAxisX{k} = a*cos(t) * cosw - b * sin(t) * sinw;
        ellipseAxisX{k} = a*b/sqrt(a^2*sinw^2 + b^2*cosw^2);
        axesDimensionsList{k} = [ellipseAxisX{k}, axesDimensionsList3D{k}(3)];
        principalAxesList{k} = { [1; 0], [0; 1] };
    end
    center = center3D(:,[1,3]);
    % value vector for the labeling of the ellipses
    value = 1:n;

    % resample the side view to have axis which have similar dimensions
    imgSide = resample(imgSide, [1, round(pixelSize(3)/pixelSize(1))], [0, 0], 'nn');

    % take care of the resampling factor to generate the ellipses on the
    % image
    for k = 1:n
        axesDimensionsList{k}(2) = axesDimensionsList{k}(2) * round(pixelSize(3)/pixelSize(1));
        center(k,2) = center(k,2) * round(pixelSize(3)/pixelSize(1));
    end
    % Draw the ellipses in an empty image
    labSide = drawEllipses( newim( imgSide ), center, value, principalAxesList, axesDimensionsList, 0 );
    % Overlay the mosaic image with the generated images 
    overlaySide = overlay( stretch(imgSide, 0 ,100, 0, 1000), drawEllipses( newim( imgSide ), center, value, principalAxesList, axesDimensionsList, 2 ) );

    endTime = toc();
    fprintf('sideSliceProjection2D: time duration: %s\n', num2str(endTime));
end
