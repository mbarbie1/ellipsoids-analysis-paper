function L = detHessianNormalized3D(img, s1, s2, s3)
% laplacianNormalized3D gives the normalized Laplacian of an image using
% DIPimage
    L = s1^2 * s2^2 * s3^2 .* dethessian(img, [s1,s2,s3]);
    
end

