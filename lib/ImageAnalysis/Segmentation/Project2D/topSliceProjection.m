%%% Top projection with slices of spheroids a the correct depth (middle
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
function [imgSH, labTop, overlayTop] = topSliceProjection( img, lab, center3D, principalAxesList3D, axesDimensionsList3D )

    fprintf('PostProcess: topSliceProjection2D\n');
    tic;
    
    nGrowIterations = 10;
    nDilation = 20;

    % separate center variable
    center = center3D(:,1:2);
    centerZ = center3D(:,3);
    n = length(centerZ);
    
    % extend the middle slice of each region
    labMask = lab > 0;
    labDilated = bdilation(labMask, nDilation);
    labGrow = dip_growregions(lab, [], labDilated, 1, nGrowIterations, 'high_first');
    %
    imgSH = newim(size(lab));
    for k = 1:n
        plane =  img( :, :, centerZ( k ));
        imgSH(labGrow==k) = plane(labGrow==k);
    end

    
    % drawing ellipses on the top projection mosaic image
    filled = 0;
    value = 1:n;
    principalAxesList = cell(n,1);
    axesDimensionsList = cell(n,1);
    for k = 1:n
        principalAxesList{k} = principalAxesList3D{k}(1:2);
        axesDimensionsList{k} = double(axesDimensionsList3D{k}(1:2));
    end
    %
    % Drawing ellipses happens twice
    labTop = drawEllipses( newim( imgSH ), center, value, principalAxesList, axesDimensionsList, filled );
    overlayTop = overlay( stretch(imgSH, 0 ,100, 0, 1000), drawEllipses( newim( size(imgSH) ), center, value, principalAxesList, axesDimensionsList, 2 ) );

    endTime = toc();
    fprintf('topSliceProjection2D: time duration: %s\n', num2str(endTime));
end
