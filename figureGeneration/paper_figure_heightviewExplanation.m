function [ imgSideOverlay, imgMIPOverlay, imgHeightViewOverlay ] = paper_figure_heightviewExplanation( imgRFP, rowId )

%% FIGURE 2: HEIGHT VIEW ILLUSTRATION

    img = subsample(imgRFP, round([8,8,1]));

%    rowId = 84;
    %[imgMt, imgHt] = max(dip_array(img((130-51):130,rowId-25:rowId+25,:)),[],3);
    %imgs = squeeze(img((131-52):131,rowId,:));

%    [imgMt, imgHt] = max(dip_array(img((rowId-25):end,(130-51):130,:)),[],3);
%    imgs = squeeze(img(rowId,(131-52):131,:));
    xp = 130;
    xp = 110;
    xp = 80;
%    [imgMt, imgHt] = max(dip_array(img((rowId-25):end,(xp-51):xp,:)),[],3);
%    imgs = squeeze(img(rowId,(xp+1-52):(xp+1),:));
%    [imgMt, imgHt] = max(dip_array(img( (xp-51):xp, (rowId-25):end, :) ), [], 3);
%    imgs = squeeze(img((xp+1-52):(xp+1),rowId,:));

%    [imgMt, imgHt] = max(dip_array(img( :, (rowId-25):end, :) ), [], 3);
%    imgs = squeeze(img(:,rowId,:));
    [imgMt, imgHt] = max(dip_array(img( (rowId-25):end, :, :) ), [], 3);
    imgs = squeeze( img(rowId, :, :) );

    %rowId = 58;
    %[imgMt, imgHt] = max(dip_array(img(0:50, rowId-25:rowId+25,:)),[],3);
    %imgs = squeeze(img(0:52,rowId,:));

    imgMt = dip_image(imgMt);
    imgHt = dip_image(imgHt);
    imgt = squeeze(imgMt);
    imgHt = squeeze(imgHt);
   
    [imgM, imgH] = max(imgs,[],2);
    n = 7;
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
    %H = dipshow(stretch(imgSideOverlay));

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

    %imgMIPJet = image(dip_array(stretch(imgMIP)));
    %colormap(jet);
    %imgMIPOverlay = overlay(stretch(imgMIPJet),imgMask, [255,0,0]);
    %dipshow(stretch(imgMIPOverlay));
    imgMIPOverlay = overlay(newim(imsize(imgMIP)),imgMask, [255,0,0]);
    %dipshow(stretch(imgMIPOverlay));
    imgMIPOverlay = overlay(stretch(imgMIP),imgMask, [255,0,0]);
    %dipshow(stretch(imgMIPOverlay));

    imgHeightViewOverlay = overlay( stretch(imgHeightView), imgMask, [255,0,0]);
    %dipshow(stretch(imgHeightViewOverlay));

end