function msr = ellipsoidValidationMeasurementsRoi( imgMIPZ, imgMIPZH, roi, centerZ, labEllipse, pixelSize )


    labEllipse = dip_image(labEllipse, 'sint16');
    [ msr, msrEllipse ] = spheroidValidationRoi(imgMIPZ, imgMIPZH, roi, centerZ, labEllipse, pixelSize );
    for k = 1:size(msr)
        msr(k).id = k;
    end
    
    msr = dip_measurement(msr);

    fn = fieldnames(msrEllipse);
    nfn = length(fn);
%     try
%         for k = 1:nfn
%             msr.([fn{k} 'Ellipse'] ) = msrEllipse.(fn{k});
%         end
%     catch
%     end
end

function [msr, msrEllipse] = spheroidValidationRoi( imgMIPZ, imgMIPZH, roi, centerZ, labEllipse, pixelSize )


    n = length(roi);
    for k = 1:n
        msr1{k} = roi{1,k}.msr;
        msr1{k}.CenterZ = centerZ(k);
        % Add unit measures in addition to the pixel measures
        msr1{k}.CenterZUnit = pixelSize(3) * msr1{k}.CenterZ;
        msr1{k}.CenterUnit = pixelSize(1) * msr1{k}.Center;
        msr1{k}.RadiusUnit = pixelSize(1) * msr1{k}.Radius;
        dA = pixelSize(1) * pixelSize(2);
        msr1{k}.ConvexAreaUnit = dA * msr1{k}.ConvexArea;
        msr1{k}.SizeUnit = dA * msr1{k}.Size;
        msr = vertcat( msr1{:} );
        
        msrFields = {'size','center', 'mean','StdDev','MinVal','MaxVal','Skewness','ExcessKurtosis'};
        msrEllipse = measure(labEllipse, imgMIPZ, msrFields, [], inf, 0, 0);
    end
end
