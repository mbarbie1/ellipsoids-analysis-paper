function lab = SegmentThresholdHessianEigenvalues2D(img, minR, maxR, nScale, noiseThresh, thresholdRatio)

    scaleOverRadiusRatio = 1/2;
    minScale = minR * scaleOverRadiusRatio;
    maxScale = maxR * scaleOverRadiusRatio;
    s = getScaleSpace(nScale,minScale,maxScale);
    [~,t] = threshold(img, 'otsu');
    imgt = threshold(bilateralf(img), 'fixed', thresholdRatio*t);
    imgt = bmajority(imgt);

    bimgall = newim(size(img));
    for k = 1:nScale
        L = s(k)^2 .* hessian(img,[s(k), s(k)]);
        [L1, L2] = imageEigenValues2D(L);
        bLxx = L1 < -noiseThresh;
        bLyy = L2 < -noiseThresh;
        b = bLxx .* bLyy .* imgt;
        bimgall = bimgall + b;
    end

    bimgb = bimgall > 0;
    minRCutoff = minR/2;
    maxRCutoff = maxR*2;
    lab = label(bimgb,1, round(getAreaDisk(minRCutoff)), round(getAreaDisk(maxRCutoff)) );

end

function s = getScaleSpace(nScale,minScale,maxScale)
% Scale-space definition
    ns = nScale;
    minScaleLog = log(minScale);
    maxScaleLog = log(maxScale);
    s = exp( linspace(minScaleLog,maxScaleLog,ns) );
end

function vol = getAreaDisk(r)
    vol = pi*r.^2;
end
