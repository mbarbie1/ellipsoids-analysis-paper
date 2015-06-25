clear;
try
    run('C:\Program Files\DIPimage 2.6\dipstart.m');
catch e
    disp(e.identifier);
    return
end

img = newim(100, 50, 60);
sz = size(img);

n = 100;
centerX = randi(sz(1),1,n);
centerY = randi(sz(2),1,n);
centerZ = randi(sz(3),1,n);
center = [centerX', centerY', centerZ']
value = 1:n;
a = 1.5; b = 10.6; radius = a + (b-a).*rand(1,n);
filled = false
pixelSize = [0.3 0.3 2]

img = drawSpheres( img, center, pixelSize, value, radius, filled );
H = dipshow(img); dipmapping(H,'labels'); dipmapping(H,'global'); dipstep(H,'on');
