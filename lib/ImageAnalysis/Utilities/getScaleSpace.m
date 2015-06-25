function [s, s1, s2, s3] = getScaleSpace(nScale,minScale,maxScale, pixelSize)
% Scale-space definition
    ns = nScale;
    minScaleLog = log(minScale);
    maxScaleLog = log(maxScale);
    s = exp( linspace(minScaleLog,maxScaleLog,ns) );
    s1 = s / pixelSize(1);
    s2 = s / pixelSize(2);
    s3 = s / pixelSize(3);
end
