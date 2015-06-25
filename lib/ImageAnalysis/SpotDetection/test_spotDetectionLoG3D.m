%% LIBRARY

    % BIOFORMATS

    % JSON
    addpath('jsonlab');
    addpath(genpath('c:/Users/mbarbie1/Documents/m_matlab/libImageAnalysis'));

    try
        run('C:\Program Files\DIPimage 2.6\dipstart.m');
    catch e
        return
    end
    %cleanerDIP = onCleanup(@()  dip_exit());
    cleanerFid = onCleanup(@()  fclose(logFid));
%% Load image

lab = readImage('c:/Users/mbarbie1/Documents/m_matlab/INPUT/lab_C2.tif', 'tif', 'Matlab');
img = readImage('c:/Users/mbarbie1/Documents/m_matlab/INPUT/gray_C2.tif', 'tif', 'Matlab');
H = dipshow(img); dipmapping(H,'lin'); dipmapping(H,'global'); dipstep(H,'on');
H = dipshow(lab); dipmapping(H,'labels'); dipmapping(H,'global'); dipstep(H,'on');

%% Options

pixelSize = [1.3 1.3 10]
avgSpotRadius = 6
maxSpotRadius = 12

%% Run algorithm

[outputMaxima, outputLab] = spotDetectionLoG3D(img, lab, pixelSize, avgSpotRadius, maxSpotRadius);
%( img, center, pixelSize, value, radius, filled )
center = [cell2mat({outputMaxima(:).x}); cell2mat({outputMaxima(:).y}); cell2mat({outputMaxima(:).z})]'
cell2mat({outputMaxima(:).inputLabIndex})'+1
ContourLab = drawSpheres( newim(img), center, pixelSize, cell2mat({outputMaxima(:).inputLabIndex})'+1, 6, false );
outputOverlay = overlay( stretch(img), ContourLab);

H = dipshow(outputOverlay); dipmapping(H,'labels'); dipmapping(H,'global'); dipstep(H,'on');
H = dipshow(outputLab); dipmapping(H,'labels'); dipmapping(H,'global'); dipstep(H,'on');
