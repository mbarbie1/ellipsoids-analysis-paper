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
    options.maxRangeZ = 24;
    options.maxRadius = 200;
    options.removeBorderObjectsInPlane = 1;
    options.removeBorderObjectsInZ = 1;
    options.borderZRemoveMethod = 'default';
    options.thresholdIntensity = 1000;
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

%    [ imgSideOverlay, imgMIPOverlay, imgHeightViewOverlay ] = paper_figure_heightviewExplanation( imgRFP );

% %% FIGURE 4: Segmentation2D method
% 
%     [ subMIP, subOverlaySegmentation2D, subHeightView, subRangeHeight ] = paper_figure_segmentationMethod( imgRFP, options );
% 
% %% FIGURE 5: Fitting of the ellipsoids
% 
     [ overlaySegmentation2D, overlayTop, overlaySide, lab, lab2D, lab3D ] = paper_figure_ellipsoidFit( imgRFP, options );
%     [ profa ] = paper_figure_radialIntensityCurves( lab3D, imgRFP, pixelSize );
