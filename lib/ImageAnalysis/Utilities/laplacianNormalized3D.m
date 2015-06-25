function L = laplacianNormalized3D(img, s1, s2, s3)
% laplacianNormalized3D gives the normalized Laplacian of an image using
% DIPimage
    L = s1^2 .* dxx(img,s1) + s2^2 .* dyy(img,s2) + s3^2 .* dzz(img,s3);
    
end

