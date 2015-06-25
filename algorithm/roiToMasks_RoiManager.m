% roi: roi struct made by imagej's RoiManager and read by ReadImageJROI
% img = cellarray of dipimage 2D images (e.g. the mip and heightmap)
% colorType is a struct array with fields .color (an RGB triple [ 0:255, 0:255, 0:255 ] )
function roi = roiToMasks_RoiManager(roi, img, colorType, msrFields)

    n = length(roi);
     
    % roi RGB color
    for k = 1:n
        argbInt = roi{1,k}.nStrokeColor;
        %[a,r,g,b,rgbString] = argbIntToValues(argbInt);
        argbInt = int64(argbInt);
        a = bitand(bitshift(argbInt,-24), hex2dec('ff'));
        r = bitand(bitshift(argbInt,-16), hex2dec('ff'));
        g = bitand(bitshift(argbInt,-8), hex2dec('ff'));
        b = bitand(argbInt, hex2dec('ff'));
        roi{1,k}.argb = [a,r,g,b];
        %color(k,:) = [a,r,g,b];
    end

    % roi RGB color to type
    for k = 1:n
        for m = 1:length(colorType)
            if (colorType(m).color == roi{1,k}.argb(2:4))
                roiType(k) = colorType(m).type;
                roiTypeName{k} = colorType(m).name;
                roi{1,k}.type = colorType(m).type;
                roi{1,k}.name = colorType(m).name;
            end
        end    
    end
    
    % roi close contour path
    for k = 1:n
        p = roi{1,k}.mnCoordinates;
        p = closeContour(p);
        roi{1,k}.mnCoordinates = p;
    end

    % extract masks and corresponding sub-images
    for k = 1:n
        [minp, maxp, pRel, pAbs, mask, sub] = extractRoiMasks( roi{1,k}.mnCoordinates, img );
        roi{1,k}.mask = mask;
        roi{1,k}.minp = minp;
        roi{1,k}.maxp = maxp;
        roi{1,k}.pRel = pRel;
        roi{1,k}.pAbs = pAbs;
        roi{1,k}.img = sub;
    end

    if (length(msrFields) > 0)
        for k = 1:n
            for j = 1:length(roi{1,k}.img)
                msr = measure(roi{1,k}.mask, roi{1,k}.img{j}, msrFields);
                roi{1,k}.msr = struct(msr);
                if (length(roi{1,k}.msr) > 1)
                    warning('ERROR multiple mask msr for mask %i', k);
                    dipshow(roi{1,k}.mask);
                end
            end
        end
    end
    
end
