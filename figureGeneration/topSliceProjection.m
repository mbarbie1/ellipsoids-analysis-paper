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
function [imgSH, labTop, overlayTop] = topSliceProjection( imgOri, imgH, lab, fctOps)

    fprintf('PostProcess: topSliceProjection2D\n');

    nGrowIterations = 10;
    nDilation = 20;

    % Find the heights of the center of the spheroids using the border
    % of the labeled image
    labContours = lab;
    labContours(berosion(lab>0)) = 0;
    msr = measure(labContours, imgH, {'mean'});
    n = length(msr.mean);
    centerZ = zeros(n,1);
    for k = 1:n
        centerZ( k ) = round(msr.mean(k));
    end

    labMask = lab > 0;
    labDilated = bdilation(labMask, nDilation);
    labGrow = dip_growregions(lab, [], labDilated, 1, nGrowIterations, 'high_first');

    imgSH = newim(size(lab));
    for k = 1:n
        plane =  imgOri( :, :, centerZ( k ));
        imgSH(labGrow==k) = plane(labGrow==k);
    end
    
    msrL = measure(lab, [], {'MajorAxes', 'DimensionsEllipsoid', 'center'});
    n = length(msrL.MajorAxes(1,:));
    center = round(msrL.center)';
    disp(n)
    disp(length(msr));
    principalAxesList = cell(n,1);
    axesDimensionsList = cell(n,1);
    for k = 1:n
        principalAxesList{k} = {...
                                    msrL.MajorAxes( 1:2, k ), ...
                                    msrL.MajorAxes( 3:4, k ), ...
                                };
        % The DimensionsEllipsoid of DIPimage contains the full
        % principal axis length while we just have the semi-axes so we
        % have to divide by 2
        axesDimensionsList{k} = double(msrL.DimensionsEllipsoid( : , k ) / 2);
    end

    filled = 0;
    value = 1:n;
    labTop = drawEllipses( newim( imgSH ), center, value, principalAxesList, axesDimensionsList, filled );
    overlayTop = overlay( stretch(imgSH, 0 ,100, 0, 1000), drawEllipses( newim( size(imgSH) ), center, value, principalAxesList, axesDimensionsList, 2 ) );
    
%     theK = 27;
%     theSlice = newim(size(lab));
%     thePlane =  imgOri( :, :, centerZ( theK ));
%     theSlice(labGrow==theK) = plane(labGrow==theK);
%     dipshow(theSlice);
%     
%     overlaySlice = overlay( theSlice, drawEllipses( newim( size(theSlice) ), center(theK,:), [value(theK)], principalAxesList(theK), axesDimensionsList(theK), false ) );
%     dipshow(theSlice);
%     dipshow(overlaySlice);



    
    endTime = toc();
    fprintf('topSliceProjection2D: time duration: %s\n', num2str(endTime));
end
