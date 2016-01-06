%[labEllipse, center3D, principalAxesList3D, axesDimensionsList3D] = fitSpheroidAxes(imgMIPZ, imgMIPZH, lab, pixelSize, fctOps.centerMethod, fctOps.zRadiusMethod);
function [labEllipse, center3D, principalAxesList3D, axesDimensionsList3D, cprof2D, spheroidIndexStart, spheroidIndexStop] = fitSpheroidAxesRoi(imgOri, img, imgH, roi, pixelSize, centerMethod, zRadiusMethod)

    fprintf('Process: fitSpheroidAxes\n');
    tic;

    thresholdRadiusSimpleProfile = 15;

    % The axis and center in 2D we obtain from measuring the labeled
    % image
    cprof = [];
    %cprof2D = [];
    
    n = length(roi);
    if ( n > 0 )

        principalAxesList = cell(n,1);
        axesDimensionsList = cell(n,1);
        for k = 1:n
            msr = roi{1,k}.msr;
            center{k} = round(msr.Center)'; % + [ roi{1,k}];

            principalAxesList{k} = {...
                                        msr.MajorAxes( 1:2 ), ...
                                        msr.MajorAxes( 3:4 ), ...
                                    };
            % The DimensionsEllipsoid of DIPimage contains the full
            % principal axis length while we just have the semi-axes so we
            % have to divide by 2
            axesDimensionsList{k} = double(msr.DimensionsEllipsoid( : ) / 2);
        end

        center3D = zeros(n,3);
        switch centerMethod
            case 'rimHeight'
                % The center z-coordinate we find from the outer rim height on the
                % heightmap
                for k = 1:n
                    center3D(k,1:2) = center{k};
                    msrH = measure( roi{1,k}.contour, roi{1,k}.imgH{1}, {'mean'});
                    center3D( k, 3 ) = round(msrH.Mean);
                end
            otherwise
                % The center z-coordinate we find from the average height on the
                % heightmap
                for k = 1:n
                    center3D(k,1:2) = center{k};
                    msrH = measure( roi{1,k}.mask, roi{1,k}.mask, {'mean'});
                    center3D( k, 3 ) = round(msrH.mean);
                end
        end

        value = 1:n;
        filled = 0;
        labEllipse = drawEllipses( newim(size(img) ), center3D, value, principalAxesList, axesDimensionsList, filled );

        for k = 1:n
            extendRadiusPerc = 0.2;
            extendRadius = max(1, round( extendRadiusPerc * min(axesDimensionsList{k}) ) );
            disp('extendRadius:')
            disp(extendRadius)
            lowerXBound = center3D( k, 1 ) - extendRadius;
            upperXBound = center3D( k, 1 ) + extendRadius;
            lowerYBound = center3D( k, 2 ) - extendRadius;
            upperYBound = center3D( k, 2 ) + extendRadius;
            cprof2D{k} = squeeze(squeeze(mean( mean( double( ( imgOri( lowerXBound:upperXBound, lowerYBound:upperYBound, : ) ) ) ) ) ));
        end
        switch zRadiusMethod
            case 'averageRadius'
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
            case 'centerProfile'
                % The radius in the z-direction we compute as the distance
                % between the center and the first inclination point in the
                % intensity curve which goes through the center of the
                % spheroid. Only use part of the 3rd axis (close to the
                % center of the spheroid.
                principalAxesList3D = principalAxesList;
                axesDimensionsList3D = axesDimensionsList;
                maxPlanarRadius = max(axesDimensionsList{k});
                for k = 1:n
                    upperZBound = round( min(  (center3D( k, 3 ) + 2*maxPlanarRadius),  size(imgOri,3)-1 ) );
                    lowerZBound = round( max(  (center3D( k, 3 ) - 2*maxPlanarRadius),  0 ) );
                    cprof{k} = cprof2D{k}(lowerZBound+1:upperZBound+1);
                    dcprof{k} = diff(cprof{k});
                    [maxZ,coordZ] = max(dcprof{k});
                    principalAxesList3D{k}{1}(end+1) = 0;
                    principalAxesList3D{k}{2}(end+1) = 0;
                    principalAxesList3D{k}{3} = [0, 0, 1]';
                    if (maxPlanarRadius > thresholdRadiusSimpleProfile)
                        axesDimensionsList3D{k}(end+1) = abs( (coordZ-1) - center3D(k,3) );
                    else
                        axesDimensionsList3D{k}(end+1) = ( pixelSize(1)/pixelSize(3) ) * mean(axesDimensionsList{k});
                    end
                end
            case 'center2DProfile'
                % The radius in the z-direction we compute as the distance
                % between the center and the first inclination point in the
                % intensity curve which goes through the center of the
                % spheroid.
                principalAxesList3D = principalAxesList;
                axesDimensionsList3D = axesDimensionsList;
                maxPlanarRadius = max(axesDimensionsList{k});
                for k = 1:n
                    cprof{k} = cprof2D{k};
                    dcprof{k} = diff(cprof{k});
                    [maxZ,coordZ] = max(dcprof{k});
                    principalAxesList3D{k}{1}(end+1) = 0;
                    principalAxesList3D{k}{2}(end+1) = 0;
                    principalAxesList3D{k}{3} = [0, 0, 1]';
                    if (maxPlanarRadius > thresholdRadiusSimpleProfile)
                        axesDimensionsList3D{k}(end+1) = abs( (coordZ-1) - center3D(k,3) );
                    else
                        axesDimensionsList3D{k}(end+1) = ( pixelSize(1)/pixelSize(3) ) * mean(axesDimensionsList{k});
                    end
                end
            case 'top'
                % The radius in the z-direction we compute as the distance
                % between the center and the first inclination point in the
                % intensity curve which goes through the center of the
                % spheroid.
                principalAxesList3D = principalAxesList;
                axesDimensionsList3D = axesDimensionsList;
                for k = 1:n
                    principalAxesList3D{k}{1}(end+1) = 0;
                    principalAxesList3D{k}{2}(end+1) = 0;
                    principalAxesList3D{k}{3} = [0, 0, 1]';
                    axesDimensionsList3D{k}(end+1) = ( pixelSize(1)/pixelSize(3) ) * mean(axesDimensionsList{k});
                end
                for k = 1:n
                    lowerXBound = center3D( k, 1 ) - 1;
                    upperXBound = center3D( k, 1 ) + 1;
                    lowerYBound = center3D( k, 2 ) - 1;
                    upperYBound = center3D( k, 2 ) + 1;
                    cprof{k} = cprof2D{k};
                    dcprof{k} = diff(cprof{k});
                    [maxZ,coordZ] = max(dcprof{k});
                    principalAxesList3D{k}{1}(end+1) = 0;
                    principalAxesList3D{k}{2}(end+1) = 0;
                    principalAxesList3D{k}{3} = [0, 0, 1]';
                    sz = size(imgOri);
                    center3D(k,3) = min( sz(3)-1, max( 1, (coordZ-1) + round(axesDimensionsList3D{k}(3))));
%                    center3D(k,3) = (coordZ-1) + round(axesDimensionsList3D{k}(3));
                    if (center3D(k,3) == sz(3)-1)
                        axesDimensionsList3D{k}(3) = center3D(k,3) - (coordZ-1);
                    end
                end
            otherwise
                %% TODO change this
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
        end

        labEllipse = dip_image(labEllipse,'sint16');
        for k = 1:n
            spheroidIndexStart(k) = max( center3D( k, 3 ) - round(axesDimensionsList3D{k}(3)), 0 ) + 1;
            spheroidIndexStop(k) = min( center3D( k, 3 ) + round(axesDimensionsList3D{k}(3)), size(imgOri,3)-1 ) + 1;
        end
    else
        labEllipse = newim( size(img),'sint16');
        center3D = [];
        principalAxesList3D = {};
        axesDimensionsList3D = {};
        spheroidIndexStart = [];
        spheroidIndexStop = [];
    end
    
    endTime = toc();
    fprintf('fitSpheroidAxes: time duration: %s\n', num2str(endTime));

end
