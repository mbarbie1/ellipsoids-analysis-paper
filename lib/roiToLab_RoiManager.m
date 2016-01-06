% roi: roi struct made by imagej's RoiManager and read by ReadImageJROI
% img = cellarray of dipimage 2D images (e.g. the mip and heightmap)
% colorType is a struct array with fields .color (an RGB triple [ 0:255, 0:255, 0:255 ] )
function lab = roiToLab_RoiManager(roi, sz)

%    disp(roi);
%    disp(roi{1,1});
%    disp(length(roi));
    
    n = length(roi);
    lab = newim(sz);
    for k = 1:n
        minp = roi{1,k}.minp-1;
%        disp(minp)
        maxp = roi{1,k}.maxp-1;
%        disp(maxp)
        tmp = lab(minp(1):maxp(1),minp(2):maxp(2)) .* (roi{1,k}.mask == 0);
        lab(minp(1):maxp(1),minp(2):maxp(2)) = tmp + k * roi{1,k}.mask;
    end
    
end
