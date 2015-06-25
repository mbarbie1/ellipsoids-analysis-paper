% -----------------------------------------------------------------------
% 
% FUNCTION: segmentThresholdHessianEigenvalues
% 
% DESCRIPTION: Segmentation of objects in 3D image-stacks (grey-valued 
%               images). 
%               The (bright) objects have to be more or less
%               compact in space for the algorithm and preferably 
%               spheroidal.
%
%              Algorithm description:
%               A labeled image is obtained by thresholding the hessian 
%               eigenvalues of the image in scalespace. When the
%               eigenvalues of the Hessian are all negative, the curvature
%               is negative which means there is a region of maximum
%               intensity --> a compact bright object.
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
function lab = segmentThresholdHessianEigenvalues(img, minRUnit, maxRUnit, minSizeUnit, maxSizeUnit, nScale, pixelSize, noiseThresh)

    scaleOverRadiusRatio = 1/2;
    minScale = minRUnit * scaleOverRadiusRatio;
    maxScale = maxRUnit * scaleOverRadiusRatio;
    [~, ss1, ss2, ss3] = getScaleSpace(nScale,minScale,maxScale, pixelSize);
    [~,t] = threshold(img, 'otsu');
    imgt = threshold(bilateralf(img), 'fixed',0.1*t);
    imgt = bmajority(imgt);

    bimgall = newim(size(img));
    for k = 1:nScale
        %L = hessianNormalized3D( img, s(k), s(k), s3*s(k) );
        %[L1, L2, L3] = eig( L ); %imageEigenValues3D( L );
        s1 = ss1(k);
        s2 = ss2(k);
        s3 = ss3(k);
        L = hessian(img,[s1 s2 s3]);
        G11 = s1^2 * L{1,1};    G12 = s1*s2 * L{1,2};    G13 = s1*s3 * L{1,3};
        G22 = s2^2 * L{2,2};    G23 = s2*s3 * L{2,3};    G33 = s3^2  * L{3,3};
        clear L    % Free memory
        [L3, L2, L1] = dip_symmetriceigensystem3(G11, G12, G13, G22, G23, G33, {'L1','L2','L3'});    % L3 > L2 > L1
        [L1, L2, L3] = sortAbsoluteEigenValue(L1, L2, L3);    % |L3| > |L2| > |L1|

        bLxx = L1 < -noiseThresh;
        bLyy = L2 < -noiseThresh;
        bLzz = L3 < -noiseThresh;
        b = bLxx .* bLyy .* bLzz .* imgt;
        bimgall = bimgall + b;
    end

    bimgb = bimgall > 0;
    dV = prod(pixelSize);
    minSize = round(minSizeUnit/dV);
    maxSize = round(maxSizeUnit/dV);
    lab = label(bimgb,1, minSize, maxSize );

end
