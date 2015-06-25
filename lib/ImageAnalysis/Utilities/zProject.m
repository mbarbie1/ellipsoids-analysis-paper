function [imgMIPZ, imgMIPZH] = zProject( img )

    [imgMIPZ, imgMIPZH] = max(dip_array(img), [], 3);
    clear img;
    imgMIPZ = dip_image(imgMIPZ);
    imgMIPZH = dip_image(imgMIPZH);

end
