% roi: roi struct made by imagej's RoiManager and read by ReadImageJROI
% img = cellarray of dipimage 2D images (e.g. the mip and heightmap)
% colorType is a struct array with fields .color (an RGB triple [ 0:255, 0:255, 0:255 ] )
function lab = roiToLab_RoiManager(roi, sz)

    n = length(roi);
    lab = newim(sz);
    for k = 1:n
        minp = roi{1,k}.minp;
        maxp = roi{1,k}.maxp;
        lab(minp(1):maxp(1),minp(2):maxp(2)) = lab(minp(1):maxp(1),minp(2):maxp(2)) + k * roi{1,k}.mask;
    end
    
end
