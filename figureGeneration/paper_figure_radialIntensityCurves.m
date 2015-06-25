function [ profa ] = paper_figure_radialIntensityCurves( lab3D, img, pixelSize )

    %
    % The spheroid index of the spheroid, from which you want to look at the
    % cylinder intensity profiles
    theK = 36;
    % Extending the border to include outside 
    ee = 3;
    msrFields = {'minimum','maximum'};
    mask3D = newim(size(img));
    mask3D(lab3D==theK) = lab3D(lab3D==theK);
    msrS = measure(label(mask3D>0), img, msrFields);
    mask = mask3D((msrS.minimum(1) - ee):(msrS.maximum(1) + ee), ...
                    (msrS.minimum(2) - ee):(msrS.maximum(2) + ee),...
                (msrS.minimum(3) - ee):(msrS.maximum(3) + ee)...
        );
    imgSub = img((msrS.minimum(1) - ee):(msrS.maximum(1) + ee), ...
                    (msrS.minimum(2) - ee):(msrS.maximum(2) + ee),...
                (msrS.minimum(3) - ee):(msrS.maximum(3) + ee)...
        );
    prof = spheroidRadialIntensityCurves( imgSub, mask, pixelSize);
    dipshow(prof);
    profa = dip_array(prof);

    figure;
    set(gca, 'ColorOrder', jet( length(1:10:size(profa,2)) ) );
    hold all

    [x,y] = meshgrid(1:size(profa(:,1:10:end),2), 1:size(profa(:,1:10:end),1));
    start = -3; stop = start + size(profa,1)-1;
    plot( start:1:stop, profa(:,1:10:end) +  max(max(profa))/5*x);

end