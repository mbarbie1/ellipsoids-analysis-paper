function [ imgSideOverlay, imgMIPOverlay, imgHeightViewOverlay ] = paper_figure_heightviewExplanation( imgRFP )

%% FIGURE 2: HEIGHT VIEW ILLUSTRATION

    img = subsample(imgRFP, round([8,8,1]));
    [imgMt, imgHt] = max(dip_array(img(0:50,58-25:58+25,:)),[],3);
    imgMt = dip_image(imgMt);
    imgHt = dip_image(imgHt);
    imgt = squeeze(imgMt);
    imgHt = squeeze(imgHt);
   
    imgs = squeeze(img(0:52,58,:));
    [imgM, imgH] = max(imgs,[],2);
    n = 15;
    m = n-1;
    aM = double(squeeze(imgM));
    aH = double(squeeze(imgH));
    masks = newim(size(imgs));
    for k = 1:length(aH)
        masks(k-1,aH(k)) = k;
    end
    sz = size(imgs);
    
    %%% SIDE VIEW %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

    imgSide = resample(imgs, [n, n], [-0.5,-0.5], 'nn');

    imgMask = newim(size(imgSide));
    for k = 1:length(aH)
        lu = [(k-1)*n,aH(k)*n]; 
        coordinates = [
            lu;
            lu+[m,0];
            lu+[m,m];
            lu+[0,m]
            ];
        intensity = 255;
        closed = 'closed';
        imgMask = drawpolygon(imgMask,coordinates,intensity,closed);
        coordinates = [
            lu+[1,1];
            lu+[m-1,1];
            lu+[m-1,m-1];
            lu+[1,m-1]
            ];
        imgMask = drawpolygon(imgMask,coordinates,intensity,closed);
    end
    imgSideOverlay = overlay(stretch(imgSide),imgMask, [255,0,0]);
    dipshow(stretch(imgSideOverlay));

    %%% TOP VIEW of heightmap and MIP %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    imgMIP = resample(imgt, [n, n], [-0.5,-0.5], 'nn');
    imgHeightView = resample(imgHt, [n, n], [-0.5,-0.5], 'nn');

    imgMask = newim(size(imgMIP));
    yHorizontal = 25;

    for k = 1:length(aH)
        lu = [(k-1)*n,yHorizontal*n]; 
        coordinates = [
            lu;
            lu+[m,0];
            lu+[m,m];
            lu+[0,m]
            ];
        intensity = 255;
        closed = 'closed';
        imgMask = drawpolygon(imgMask,coordinates,intensity,closed);
        coordinates = [
            lu+[1,1];
            lu+[m-1,1];
            lu+[m-1,m-1];
            lu+[1,m-1]
            ];
        imgMask = drawpolygon(imgMask,coordinates,intensity,closed);
    end

    imgMIPJet = image(dip_array(stretch(imgMIP)));
    colormap(jet);
%    imgMIPOverlay = overlay(stretch(imgMIPJet),imgMask, [255,0,0]);
%    dipshow(stretch(imgMIPOverlay));
    imgMIPOverlay = overlay(newim(imsize(imgMIP)),imgMask, [255,0,0]);
    dipshow(stretch(imgMIPOverlay));
    imgMIPOverlay = overlay(stretch(imgMIP),imgMask, [255,0,0]);
    dipshow(stretch(imgMIPOverlay));

    imgHeightViewOverlay = overlay( stretch(imgHeightView), imgMask, [255,0,0]);
    dipshow(stretch(imgHeightViewOverlay));

end