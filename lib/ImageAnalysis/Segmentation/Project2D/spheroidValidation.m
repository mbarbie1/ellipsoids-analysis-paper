function [msr, msrEllipse] = spheroidValidation( imgMIPZ, imgMIPZH, lab, labEllipse, pixelSize )

    msrH = measure(lab, imgMIPZH, {'mean'});
    msrFields = {'size','center','Radius','ConvexArea','P2A','PodczeckShapes',...
        'mean','StdDev','MinVal','MaxVal','Skewness','ExcessKurtosis'};
    msr = measure(lab, imgMIPZ, msrFields);
    msr.CenterZ = msrH.mean;
    % Add unit measures in addition to the pixel measures
    msr.CenterZUnit = pixelSize(3) * msrH.mean;
    msr.CenterUnit = pixelSize(1) * msr.Center;
    msr.RadiusUnit = pixelSize(1) * msr.Radius;
    dA = pixelSize(1) * pixelSize(2);
    msr.ConvexAreaUnit = dA * msr.ConvexArea;
    msr.SizeUnit = dA * msr.Size;

    msrFields = {'size','center', 'mean','StdDev','MinVal','MaxVal','Skewness','ExcessKurtosis'};
    msrEllipse = measure(labEllipse, imgMIPZ, msrFields, [], inf, 0, 0);

end
