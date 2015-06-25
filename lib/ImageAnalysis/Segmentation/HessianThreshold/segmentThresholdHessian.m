% -----------------------------------------------------------------------
% 
% FUNCTION: segmentThresholdHessian
% 
% DESCRIPTION: Segmentation of objects in 3D image-stacks (grey-valued 
%               images). 
%               The (bright) objects have to be more or less
%               compact in space for the algorithm and preferably 
%               spheroidal.
%
%              Algorithm description:
%               A labeled image is obtained by thresholding the hessian 
%               diagonal elements of the image in scalespace. The diagonal
%               elements of the Hessian approximate the curvature of the
%               region of the pixel. When they're all negative it means 
%               there is a region of maximum intensity --> a compact 
%               bright object.
% 
% INPUT: 
%           img                     : 3D image (DIPimage image)
%           minRUnit                : minimal radius of objects in um (scalar)
%           maxRUnit                : maximal radius of objects in um (scalar)
%           minSizeUnit             : minimal size of the objects in um^3 (scalar)
%           maxSizeUnit             : maximal size of the objects in um^3 (scalar)
%           nScale                  : number of scales taken (exponantial
%                                       spaced scales. (integer)
%           pixelSize               : pixel size (x,y,z) (vector)
%           noisThresh              : a small number which serves to remove
%                                       pixels which have very low Hessian
%                                       eigenvalues and could be resulting
%                                       from the noise in the image. 
%                                       (scalar)
%
% OUTPUT:
%           lab                     : labeled image of the segmentation 
%                                       (DIPimage image)
%
% AUTHOR: 
% 
% 	Michaël Barbier
%   mbarbie1@its.jnj.com
% 
% ----------------------------------------------------------------------- 
%
function lab = segmentThresholdHessian(img, minRUnit, maxRUnit, minSizeUnit, maxSizeUnit, nScale, pixelSize, noiseThresh)

    scaleOverRadiusRatio = 1/2;
    minScale = minRUnit * scaleOverRadiusRatio;
    maxScale = maxRUnit * scaleOverRadiusRatio;
    [~, ss1, ss2, ss3] = getScaleSpace(nScale,minScale,maxScale, pixelSize);
    [~,t] = threshold(img, 'otsu');
    imgt = threshold(bilateralf(img), 'fixed',0.1*t);
    imgt = bmajority(imgt);
    
    bimgall = newim(size(img));
    for k = 1:nScale
        L = hessianNormalized3D( img, ss1(k), ss2(k), ss3(k) );
        bLxx = L{1,1} < -noiseThresh;
        bLyy = L{2,2} < -noiseThresh;
        bLzz = L{3,3} < -noiseThresh;
        b = bLxx .* bLyy .* bLzz .* imgt;
        bimgall = bimgall + b;
    end

    bimgb = bimgall > 0;
    dV = prod(pixelSize);
    minSize = round(minSizeUnit/dV);
    maxSize = round(maxSizeUnit/dV);
    lab = label(bimgb,1, minSize, maxSize );

end
