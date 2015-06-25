function H = hessianNormalized2D(img, s1, s2)
% hessianNormalized2D gives the normalized hessian of an image using
% DIPimage
    H = hessian(img,[s1 s2]);
    % Normalize the hessian
    H{1,1} = s1^2 * H{1,1};
    H{1,2} = s1*s2 * H{1,2};
    H{2,1} = s1*s2 * H{2,1};
    H{2,2} = s2^2 * H{2,2};

end

