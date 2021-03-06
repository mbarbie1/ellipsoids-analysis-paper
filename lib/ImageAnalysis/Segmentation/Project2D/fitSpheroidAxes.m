function [labEllipse, center3D, principalAxesList3D, axesDimensionsList3D, cprof2D, spheroidIndexStart, spheroidIndexStop] = fitSpheroidAxes(imgOri, img, imgH, lab, pixelSize, centerMethod, zRadiusMethod, thresholdRadiusSimpleProfile)
% -----------------------------------------------------------------------
% 
% FUNCTION: fitSpheroidAxes
% 
% DESCRIPTION: 
% 
% INPUT: 
%           imgOri                    : original 3D image stack channel 
%                                       (DIPimage 3D image)
%           img                       : MIP (DIPimage 2D image)
%           imgH                      : z-buffer of the MIP (DIPimage 2D
%           lab                       : labeled image of the segmentation
%                                           image)
%           pixelSize                 : pixel size in x,y,z (vector)
%           centerMethod              : minimal radius (in micron) of the
%           zRadiusMethod             : minimal radius (in micron) of the
%
% OUTPUT:
%           labEllipse                : a labeled image of the ellipse (2D)
%           center3D                  : center coordinates of the
%                                       ellipsoids nx3 matrix
%           principalAxesList3D       : double list {n}x{3}x3 containing
%                                       the principal axes coordinates in
%                                       3D for the 3 axes.
%           axesDimensionsList3D      : List {n}x3 with the dimensions of
%                                       the 3 axes for each ellipsoid
%           cprof2D                   : list {n}x(sizeZ) with the profile
%                                       curves through the center of the
%                                       ellipsoids
%           spheroidIndexStart        : lowest index of z-coordinates of
%                                       the ellipsoid (n array)
%           spheroidIndexStop         : highest index of z-coordinates
%                                       of the ellipsoid (n array)
%
% AUTHOR: 
% 
% 	Micha�l Barbier
%   mbarbie1@its.jnj.com
% 
% ----------------------------------------------------------------------- 
%
    fprintf('Process: fitSpheroidAxes\n');
    tic;

    
    % The axis and center in 2D we obtain from measuring the labeled
    % image
    cprof = [];
    %cprof2D = [];
    
    msr = measure(lab, img, {'MajorAxes', 'DimensionsEllipsoid', 'center'});
    if ( length(msr) > 0 )
        n = length(msr.MajorAxes(1,:));
        center = round(msr.center)';
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
        
        switch centerMethod
            case 'rimHeight'
                % The center z-coordinate we find from the outer rim height on the
                % heightmap
                center3D = zeros(n,3);
                center3D(:,1:2) = center;
                labContours = lab;
                labContours(berosion(lab>0)) = 0;
                msr = measure(labContours, imgH, {'mean'});
                for k = 1:n
                    center3D( k, 3 ) = round(msr.mean(k));
                    %imgH(center(k,1),center(k,2)); %+ round(( fctOps.fitSpheroid.pixelSize(1)/fctOps.fitSpheroid.pixelSize(3) ) * mean(axesDimensionsList{k}));
                end
            case 'rimHeightRemoveZero'
                % The center z-coordinate we find from the outer rim height on the
                % heightmap
                center3D = zeros(n,3);
                center3D(:,1:2) = center;
                labContours = lab;
                labContours(berosion(lab>0)) = 0;
                labContoursAboveZero = labContours;
                labContoursAboveZero(imgH == 0) = 0;
                msr = measure(labContoursAboveZero, imgH, {'mean'});
                for k = 1:n
                    center3D( k, 3 ) = round(msr.mean(k));
                    %imgH(center(k,1),center(k,2)); %+ round(( fctOps.fitSpheroid.pixelSize(1)/fctOps.fitSpheroid.pixelSize(3) ) * mean(axesDimensionsList{k}));
                end
            otherwise
                % The center z-coordinate we find from the average height on the
                % heightmap
                center3D = zeros(n,3);
                center3D(:,1:2) = center;
                msr = measure(lab, imgH, {'mean'});
                for k = 1:n
                    center3D( k, 3 ) = round(msr.mean(k));
                end
        end

        value = 1:n;
        filled = 0;
        labEllipse = drawEllipses( newim(size(img) ), center, value, principalAxesList, axesDimensionsList, filled );

        for k = 1:n
            extendRadiusPerc = 0.2;
            extendRadius = max(1, round( extendRadiusPerc * min(axesDimensionsList{k}) ) );
            lowerXBound = center3D( k, 1 ) - extendRadius;
            upperXBound = center3D( k, 1 ) + extendRadius;
            lowerYBound = center3D( k, 2 ) - extendRadius;
            upperYBound = center3D( k, 2 ) + extendRadius;
            cprof2D{k} = squeeze(squeeze(mean( mean( double( ( imgOri( lowerXBound:upperXBound, lowerYBound:upperYBound, : ) ) ) ) ) ));
        end
        switch zRadiusMethod %            case 'radialProfile' %                prof = spheroidRadialIntensityCurves2D( img, mask2D, pixelSize)
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
    fprintf('fitSpheroidAxes: time duration = %s\n', num2str(endTime));

end
