%%% Side projection with slices of spheroids a the correct depth (middle
%%% of the spheroid
%
% 
% AUTHOR: 
% 
% 	Michaël Barbier
%   mbarbie1@its.jnj.com
% 
% ----------------------------------------------------------------------- 
%
function [ imgSide, labSide, overlaySide ] = drawProjectionEllipsoidsSideSlice( imgOri, imgMIPZH, lab, pixelSize)

    fprintf('PostProcess: sideSliceProjection2D\n');

    nGrowIterations = 10;
    nDilation = 20;

    % Find the heights of the center of the spheroids using the border
    % of the labeled image
    labContours = lab;
    labContours(berosion(lab>0)) = 0;
    msrL = measure(lab, [], {'center','minimum', 'maximum'});
    centerX = round(msrL.center(1,:));
    centerY = round(msrL.center(2,:));

    sideSize = size(squeeze(imgOri(:,0,:)));
    minX = msrL.minimum(1,:);
    minY = msrL.minimum(2,:);
    maxX = msrL.maximum(1,:);
    maxY = msrL.maximum(2,:);
    rZ = (pixelSize(1)/pixelSize(3)) * (maxX - minX + maxY - minY) / 4;
    minX(minX < 0) = 0;
    maxX( maxX > (sideSize(1)-1) ) = sideSize(1)-1;

    msr = measure(labContours, imgMIPZH, {'mean'});
    n = length(msr.mean);
    centerZ = round(msr.mean);
    minZ = round( centerZ - rZ - 10);
    maxZ = round( centerZ + rZ + 10);
    minZ(minZ < 0) = 0;
    maxZ( maxZ > (sideSize(2)-1) ) = sideSize(2)-1;

    imgSide = newim(sideSize);
    for k = 1:n
        plane =  squeeze(imgOri( :, centerY( k ), : ));
        imgSide(minX(k):maxX(k), minZ(k):maxZ(k)) = imgSide(minX(k):maxX(k), minZ(k):maxZ(k)) + plane(minX(k):maxX(k), minZ(k):maxZ(k));
    end

    filled = 0;
    for k = 1:n
        axesDimensionsList{k} = [(maxX(k) - minX(k))/2, rZ(k)];
        principalAxesList{k} = { [1; 0], [0; 1] };
    end
    center = [ centerX', centerZ' ];
    value = 1:n;

    imgSide = resample(imgSide, [1, round(pixelSize(3)/pixelSize(1))], [0, 0], 'nn');
    
    for k = 1:n
        axesDimensionsList{k}(2) = axesDimensionsList{k}(2) * round(pixelSize(3)/pixelSize(1));
    end
    center(:,2) = round(pixelSize(3)/pixelSize(1)) * center(:,2) - 4;
    
    labSide = drawEllipses( newim( imgSide ), center, value, principalAxesList, axesDimensionsList, 0 );
    
    %overlaySide = overlay( stretch(imgSide, 0 ,100, 0, 1000), drawEllipses( newim( imgSide ), center, value, principalAxesList, axesDimensionsList, 2 ) );
    overlaySide = overlay( stretch(imgSide), drawEllipses( newim( imgSide ), center, value, principalAxesList, axesDimensionsList, 2 ) );
    
    endTime = toc();
    fprintf('sideSliceProjection2D: time duration: %s\n', num2str(endTime));
end
