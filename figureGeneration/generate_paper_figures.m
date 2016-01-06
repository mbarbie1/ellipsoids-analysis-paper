% SCRIPT: Generates the images and plots (does not write to disk) which are made in
%           Matlab necessary for the figures of the paper. 
%           This script is not optimized for speed.
% 
% AUTHOR: 
%
% 	Michaël Barbier
%   mbarbie1@its.jnj.com
% 
% ----------------------------------------------------------------------- 
%

%% LOADING LIBRARIES
    clear;

    addpath(genpath('../lib'));
    % External libs
    addpath(genpath('../libExternal'));
    try
        run('C:\Program Files\DIPimage 2.6\dipstart.m');
    catch e
        return
    end

%% PARAMETERS

    %%% parameters of the image
    channelIdSpheroids = 2;
    channelIdNuclei = 4;
    channelIdProliferation = 1;
    seriesId = [];
    imageDir = '../input';
    filePath = 'S2_File.tif';
    imageMicroscopeFormat = 'Opera';
    % unit is um
    pixelSize = [ 1.3, 1.3, 10 ];

    %%% 2D segmentation parameters
    options.pixelSize = pixelSize;
    options.minRadius = 6;
    options.neighbourhoodRadius = 3;
    options.maxRangeZ = 36;
    options.maxRadius = 200;
    options.removeBorderObjectsInPlane = 1;
    options.removeBorderObjectsInZ = 0;
    options.borderZRemoveMethod = 'default';
    options.thresholdIntensity = 500;
    options.method = 'ProjZ';

    % fitEllipsoids parameters
    options.centerMethod = 'rimHeight';
    options.zRadiusMethod = 'center2DProfile';

%% LOADING THE RFP IMAGE

    channelId = channelIdSpheroids;
    tstart = tic;
    imgRFP = loadMicroscopeImageStack( imageDir, filePath, channelId, seriesId, imageMicroscopeFormat );
    tstop = toc(tstart);
    fprintf('Processing time LoadImage = %i\n', tstop);

%% FIGURE 3: HEIGHT VIEW ILLUSTRATION

%     rowIds = [113,114,115,116,117,118,119];
%     rowIds = [35];%26:101;%[118,119,120]%,127,128,129,130,131,132,133,134,135,136,137,138];
%     %rowIds = [50,60,70,80,90,100,110,120];
%     nIms = length(rowIds);
% %    [ imgSideOverlay, imgMIPOverlay, imgHeightViewOverlay ] = paper_figure_heightviewExplanation( imgRFP, rowIds(1) );
% %    ims = newim([imsize(imgSideOverlay), nIms]);
% %    ims(:,:,0) = squeeze(imgSideOverlay);
%     [ imgSideOverlay, imgMIPOverlay, imgHeightViewOverlay ] = paper_figure_heightviewExplanation( imgRFP, rowIds(1) );
%     ims = newim([imsize(imgSideOverlay{1}),nIms]);
%     for jj = 1:nIms
%         jj
%         [ imgSideOverlay, imgMIPOverlay, imgHeightViewOverlay ] = paper_figure_heightviewExplanation( imgRFP, rowIds(jj) );
%         ims{1}(:,:,jj-1) = imgSideOverlay{1}(:,:);
%     end
%     dipshow(ims);

    %dipshow(imgMIPOverlay); dipshow(imgHeightViewOverlay);
%    [ imgSideOverlay, imgMIPOverlay, imgHeightViewOverlay ] = paper_figure_heightviewExplanation( imgRFP, 83 ); dipshow(imgSideOverlay); %dipshow(imgMIPOverlay); dipshow(imgHeightViewOverlay);
%    [ imgSideOverlay, imgMIPOverlay, imgHeightViewOverlay ] = paper_figure_heightviewExplanation( imgRFP, 84 ); dipshow(imgSideOverlay); %dipshow(imgMIPOverlay); dipshow(imgHeightViewOverlay);
%    [ imgSideOverlay, imgMIPOverlay, imgHeightViewOverlay ] = paper_figure_heightviewExplanation( imgRFP, 85 ); dipshow(imgSideOverlay); %dipshow(imgMIPOverlay); dipshow(imgHeightViewOverlay);
%    [ imgSideOverlay, imgMIPOverlay, imgHeightViewOverlay ] = paper_figure_heightviewExplanation( imgRFP, 86 ); dipshow(imgSideOverlay); %dipshow(imgMIPOverlay); dipshow(imgHeightViewOverlay);
%    [ imgSideOverlay, imgMIPOverlay, imgHeightViewOverlay ] = paper_figure_heightviewExplanation( imgRFP, 87 ); dipshow(imgSideOverlay); %dipshow(imgMIPOverlay); dipshow(imgHeightViewOverlay);

% %% FIGURE 4: Segmentation2D method
% 
     [ subMIP, subOverlaySegmentation2D, subHeightView, subRangeHeight ] = paper_figure_segmentationMethod( imgRFP, options );
% 
% %% FIGURE 5: Fitting of the ellipsoids
% 
%     [ overlaySegmentation2D, overlayTop, overlaySide, lab, lab2D, lab3D ] = paper_figure_ellipsoidFit( imgRFP, options );
%     [ profa ] = paper_figure_radialIntensityCurves( lab3D, imgRFP, pixelSize );
