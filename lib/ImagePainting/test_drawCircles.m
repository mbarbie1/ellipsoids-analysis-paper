clear;
try
    run('C:\Program Files\DIPimage 2.6\dipstart.m');
catch e
    disp(e.identifier);
    return
end

img = newim(100, 50);
sz = size(img);

n = 100;
centerX = randi(sz(1),1,n)
centerY = randi(sz(2),1,n)
value = 1:n;
radius = 2.45
filled = false

img = drawCircles( img, centerX, centerY, value, radius, filled );
H = dipshow(img); dipmapping(H,'lin');
