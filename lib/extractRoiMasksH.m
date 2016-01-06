% img = cellarray of dipimage images
function [minp, maxp, pRel, pAbs, mask, contour, sub, subH] = extractRoiMasksH(roiCoords, img, imgH)
        p = roiCoords;
        p = max(p,1);
        minp = min(p);
        maxp = max(p);
        pAbs = p;
        pRel = p - repmat( minp, size(p,1), 1);
        for k = 1:length(img)
            sub{k} = img{k}((minp(1)-1):(maxp(1)-1), (minp(2)-1):(maxp(2)-1) );
            subH{k} = imgH{k}((minp(1)-1):(maxp(1)-1), (minp(2)-1):(maxp(2)-1) );
        end
        mask = newim(imsize(sub{1}),'bin');
        mask(sub2ind(mask,pRel)) = 1;
        mask = fillholes(mask);
        contour = mask;
        contour( berosion(mask, 1, -1, 0) ) = 0;
    end
