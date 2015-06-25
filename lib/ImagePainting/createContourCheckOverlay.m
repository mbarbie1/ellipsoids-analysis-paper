function imgContour = createContourCheckOverlay( img, good, bad, colorGood, colorBad )
    %%% creates an image of the original image 'img' overlayed with the
    %%% labeled images 'good' and 'bad' where the good are shown in
    %%% colorGood and the bad in colorBad (of type [0..255,0..255,0..255])

    imgContour = overlay( stretch(img), good - good .* berosion(good > 0.5) , colorGood);
    imgContour = overlay( imgContour, bad - bad .* berosion(bad > 0.5) , colorBad);
end

