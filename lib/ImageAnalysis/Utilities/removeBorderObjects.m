function lab = removeBorderObjects(lab, imgH, minH, maxH)

%    minH = min(imgH)-1;
%    maxH = max(imgH)-1;

    for k = 1:max(lab)
        avgH = round(mean(imgH(lab == k)));
        if (avgH >= maxH-1 || avgH <= minH+1)
            lab(lab == k) = 0;
        end
    end
    if (max(lab) > 0)
        lab = relabel(lab);
    end
    
end