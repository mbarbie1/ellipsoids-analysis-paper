function lab = fitSpheroid2D(img, imgH, lab)

    % The axis and center in 2D we obtain from measuring the labeled
    % image
    msr = measure(lab, img, {'MajorAxes', 'DimensionsEllipsoid', 'center'});
    if ( length(msr) > 0 )
        n = length(msr.MajorAxes(1,:));
        center = round(msr.center)';
        disp(n)
        disp(length(msr));
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

        % The center z-coordinate we find from the average height on the
        % heightmap
        center3D = zeros(n,3);
        center3D(:,1:2) = center;
        msr = measure(lab, imgH, {'mean'});
        for k = 1:n
            center3D( k, 3 ) = round(msr.mean(k));
        end

        value = 1:n;
        filled = 0;
        lab = drawEllipses( newim(size(img) ), center, value, principalAxesList, axesDimensionsList, filled );
    end

    lab = dip_image(lab,'sint16');
end
