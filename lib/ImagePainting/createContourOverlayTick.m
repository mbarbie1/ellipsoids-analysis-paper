function imgContour = createContourOverlayTick( img, lab, n )
    %%% creates an image of the original image 'img' overlayed with the
    %%% labeled image 'lab' where only the contours of the labeled image
    %%% are shown.

    imgContour = overlay( stretch(img), lab - lab.*berosion( lab > 0, n ) );
end

