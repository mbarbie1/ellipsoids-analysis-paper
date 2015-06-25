function [lab, lab3D] = fitSpheroid(img, imgH, lab, size3D, pixelSize)

    fprintf('PostProcess: fitSpheroid\n');
    tic

    % The axis and center in 2D we obtain from measuring the labeled
    % image
    msr = measure(lab, img, {'MajorAxes', 'DimensionsEllipsoid', 'center'});
    n = length(msr.MajorAxes(1,:));
    center = round(msr.center)';
%    disp(n)
%    disp(length(msr));
    principalAxesList = cell(n,1);
    axesDimensionsList = cell(n,1);
    for k = 1:n
        principalAxesList{k} = {...
                                    msr.MajorAxes( 1:2, k ), ...
                                    msr.MajorAxes( 3:4, k ), ...
                                };
        % The DimensionsEllipsoid of DIPimage contains the full
        % principal axis length while we just have the semi-axes so we
        % have to divide by 2
        axesDimensionsList{k} = double(msr.DimensionsEllipsoid( : , k ) / 2);
    end

    % The center z-coordinate we find from the outer rim height on the
    % heightmap
    center3D = zeros(n,3);
    center3D(:,1:2) = center;
    labContours = lab;
    labContours(berosion(lab>0)) = 0;
    %labContours = dip_image(labContours,'uint16');
    %dipshow(labContours);
    msr = measure(labContours, imgH, {'mean'});
    for k = 1:n
        center3D( k, 3 ) = round(msr.mean(k));
        %imgH(center(k,1),center(k,2)); %+ round(( fctOps.fitSpheroid.pixelSize(1)/fctOps.fitSpheroid.pixelSize(3) ) * mean(axesDimensionsList{k}));
    end

    % The radius in the z-direction we take as the average of the other
    % radii of the other axes (this can be improved?)
    principalAxesList3D = principalAxesList;
    axesDimensionsList3D = axesDimensionsList;
    for k = 1:n
        principalAxesList3D{k}{1}(end+1) = 0;
        principalAxesList3D{k}{2}(end+1) = 0;
        principalAxesList3D{k}{3} = [0, 0, 1]';
        axesDimensionsList3D{k}(end+1) = ( pixelSize(1)/pixelSize(3) ) * mean(axesDimensionsList{k});
    end
%    disp(whos('axesDimensionsList'));
%    disp(whos('axesDimensionsList3D'));
%    disp(axesDimensionsList3D{2});
%    disp(principalAxesList3D{2});
    % An overlay of the side view of the spheroids along the center
    % slides

    value = 1:n;
    filled = 0;
    lab = drawEllipses( newim(size(img) ), center, value, principalAxesList, axesDimensionsList, filled );
    lab3D = drawEllipsoids( newim(size3D), [1 1 1],  center3D, value, principalAxesList3D, axesDimensionsList3D, filled );
    lab = dip_image(lab,'uint16');
    lab3D = dip_image(lab3D,'uint16');

    endTime = toc();
    fprintf('fitSpheroid: time duration: %s\n', num2str(endTime));
end
