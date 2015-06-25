clear;
try
    run('C:\Program Files\DIPimage 2.6\dipstart.m');
catch e
    disp(e.identifier);
    return
end

img = newim(1000, 1000, 51);
sz = size(img);

n = 20;
centerX = randi(sz(1),1,n);
centerY = randi(sz(2),1,n);
centerZ = randi(sz(3),1,n);
center = [centerX', centerY', centerZ'];

a = 10; b = 40; r = a + (b-a).*rand(3,n);
alpha = 2*pi.*rand(3,n);


for k = 1:n
    E = eye(3);
    e1 = E(:,1);
    e2 = E(:,2);
    e3 = E(:,3);
    R = E;
    for m = 1:3
        r1 = cos(alpha(m,k));
        r2 = sin(alpha(m,k));
        RMatrix2D = [ r1, -r2; r2, r1 ];
        Ri = eye(3);
        Ri([1:m-1 m+1:end],[1:m-1 m+1:end]) = RMatrix2D;
        R = Ri*R;
    end
    principalAxesList{k} = { R*e1, R*e2, R*e3 };
    axesDimensionsList{k} = r(:,k);
end

value = 1:n;
filled = true
pixelSize = [0.5 1 1]
pixelSampleSize = [1 1 1]
img = drawEllipsoids( img, pixelSampleSize, center, value, principalAxesList, axesDimensionsList, filled );
%a = dip_array(img(:,:,20));
%imshow(a);
% 
%H = dipshow(a); dipmapping(H,'labels');
H = dipshow(img); dipmapping(H,'labels'); dipmapping(H,'global'); dipstep(H,'on');

% scale = 1./pixelSize;
% for k = 1:n
%     principalAxesList{k}
%     axesDimensionsList{k}
%     [principalAxesList{k}, pixelSampleSize, axesDimensionsList{k}] = scaleEllipsoidCoords( principalAxesList{k}, axesDimensionsList{k}, scale );
%     principalAxesList{k}
%     axesDimensionsList{k}
% end
% img = drawEllipsoids( img, center, value, principalAxesList, axesDimensionsList, filled );
% 
% H = dipshow(img); dipmapping(H,'labels'); dipmapping(H,'global'); dipstep(H,'on');
