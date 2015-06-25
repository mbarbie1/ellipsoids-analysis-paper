% mask              : mask of a single spheroid --> one ellipsoid
% img               : gray image of the single spheroid
% NOTE THAT 'img' and 'mask' might be extended a bit to include intensities
% in the curves which belong to the spheroid but where mis-segmented (e.g.
% mis-alignment of the center in the z direction

function prof = spheroidRadialIntensityCurves( img, mask, pixelSize)

    fprintf('PostProcess: spheroidRadialIntensityCurves\n');
    tic

    % The axis and center in 2D we re-obtain from measuring the labeled
    % image
    msr = measure( label(mask>0), img, {'MajorAxes', 'DimensionsEllipsoid', 'Center'} );
    center = round(msr.center)';
    principalAxes = { msr.MajorAxes( 1:3 ), msr.MajorAxes( 4:6 ), msr.MajorAxes( 7:9 ) };
    % The DimensionsEllipsoid of DIPimage contains the full
    % principal axis length while we just have the semi-axes so we
    % have to divide by 2
    axesDimensions = double(msr.DimensionsEllipsoid / 2);

    mask2D = squeeze(max(mask,[],3));
    dist = dt( mask2D > 0 , 0,  'true');

    n = ceil(max(dist));
    nz = size(img,3);
    prof = newim(n, nz);

    distMask = newim(size(img,1), size(img,2), n);
    for k = 1:n
        planeTemp = newim(size(img,1), size(img,2));
        planeTemp(  (dist<=k) & (dist>(k-1))  ) = 1;
        distMask(:,:,k-1) = planeTemp > 0;
    end
    for p = 1:nz
        plane = img(:,:,p-1);
        for k = 1:n
            if (max(distMask(:,:,k-1))==0)
                prof(k-1,p-1) = 0;
            else
                prof(k-1,p-1) = median( plane(squeeze(distMask(:,:,k-1)) > 0 ) );
            end
        end
    end
    profa = dip_array(prof);
    save('profa.mat', 'profa');

    endTime = toc();
    fprintf('spheroidRadialIntensityCurves: time duration: %s\n', num2str(endTime));
end
