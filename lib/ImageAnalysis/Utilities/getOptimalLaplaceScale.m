function [ss, scalePlot] = getOptimalLaplaceScale(img, minScale, maxScale, nScales, pixelSize)
% getOptimalLaplaceScale this function determines the optimal scale of the
% 2D image: this scale can be used for the blob detection

	ns = nScales;
    minScaleLog = log(minScale);
    maxScaleLog = log(maxScale);
    s = exp( linspace(minScaleLog,maxScaleLog,ns) );
    s1 = s / pixelSize(1);
    s2 = s / pixelSize(2);
	sz = size(img);

	sumL = 0 * ( 1:length(s) );
	%LL = newim( [imsize(img), ns ]);
	for k = 1:length(s)
		L = s1(k)^2 .* dxx(img,s1(k)) + s2(k)^2 .* dyy(img,s2(k));
		%LL(:,:,k-1) = L(:,:);
		sumL(k) = sum(-L(L<0));
	end
	
	%figure();
	scalePlot = figure('visible','off');
	plot(s, sumL/(sz(1)*sz(2)),'ro');
	hold off;
	%figure();
	%dipshow(LL);

	[sMax, sIndex] = max(sumL);
	ss = s(sIndex);

end
