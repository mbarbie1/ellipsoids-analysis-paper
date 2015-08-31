% SCRIPT: Single function for the segmentation and spot
% detection algorithm for the paper
% 
% AUTHOR: 
%
% 	Michaël Barbier
%   mbarbie1@its.jnj.com
% 
% ----------------------------------------------------------------------- 
%
    fprintf('Starting script\n');
    tstartTotal = tic;

%% LOADING LIBRARIES

    % libs
    addpath(genpath('../lib'));
    % External libs
    addpath(genpath('../libExternal'));
    % DIPimage
    try
        run('C:\Program Files\DIPimage 2.6\dipstart.m');
    catch e
        return
    end

%% PARAMETERS

    fprintf('Start script\n');
    tstart = tic;

    options = loadjson('options.json');
    sampleId = options.input.sampleId;
    imageId = options.input.imageId;
    [ msra, lab, labEllipse, imgSpheroids, imgSpots ] = analyseImage(options);

    tstop = toc(tstart);
    fprintf('Total processing time script = %i\n', tstop);
