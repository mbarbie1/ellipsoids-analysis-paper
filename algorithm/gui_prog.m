function [] = gui_prog()

    clear
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

%% load the default options
    options = loadjson('input/options_default.json');

%% Show the gui
    
    S = struct();
    S.f = initializeGUI(options,S);
   
end

%%

function [nImages, hImage] = updateImagesGUI(options,S)

    try
        nImages = length(options.output.images);
    catch
        nImages = 0;
    end

    [ winx, winy, winw, winh, groups, pImageY, pPlotY, pControlY, h, marginx ] = getWindowSpecifications(options);
    y = pImageY;
    hImage = cell( length(y), 7 );
    style = {'checkbox', 'text', 'edit', 'edit','popupmenu','popupmenu','popupmenu'};
    w = [ 0.05 * winw, 0.2 * winw, 0.2 * winw, 0.2 * winw, 0.1 * winw, 0.1 * winw, 0.1 * winw ];

    for k = 1:(length(y))

        string = {'', options.output.images{1,k}.name, options.output.images{1,k}.dir, options.output.images{1,k}.pattern,...
            {'tif','png'}, {'rgb','gray'}, {'8','16'} };

        x = marginx;
        for m = 1:length(style)
            hImage{k,1} = uicontrol('Style',style{m},...
                'String',string{m},'Position', [ x, y(k) , w(m), h ] );
            x = x + w(m);
        end
    end

end


function [nPlots, hPlot] = updatePlotsGUI(options, S)

    try
        nPlots = length(options.output.plots);
    catch
        nPlots = 0;
    end

    [ winx, winy, winw, winh, groups, pImageY, pPlotY, pControlY, h, marginx ] = getWindowSpecifications(options);
    y = pPlotY;
    hPlot = cell( length(y), 5 );
    style = {'checkbox', 'text', 'edit', 'edit','popupmenu'};
    w = [ 0.05 * winw, 0.2 * winw, 0.2 * winw, 0.2 * winw, 0.1 * winw ];

    if (nPlots > 0)
        for k = 1:(length(y))

            string = {'', options.output.plots{1,k}.name, options.output.plots{1,k}.dir, options.output.plots{1,k}.pattern,...
                {'tif','png'}, {'rgb','gray'}, {'8','16'} };

            x = marginx;
            for m = 1:length(style)
                hPlot{k,1} = uicontrol('Style',style{m},...
                    'String',string{m},'Position', [ x, y(k) , w(m), h ] );
                x = x + w(m);
            end
        end
    end
end

function [hload, hsave, hrun] = updateControlsGUI(options, S)

    [ winx, winy, winw, winh, groups, pImageY, pPlotY, pControlY, h, marginx ] = getWindowSpecifications(options);
    x = winx;
    y = pControlY;
    w = 0.1*winw;

    hload = uicontrol('Style','pushbutton',...
        'String','Load',...
        'Position',[x, y, w, h],...
        'Callback',{@loadButton_Callback,S});
    hsave = uicontrol('Style','pushbutton',...
        'String','Save',...
        'Position',[x + w, y , w, h],...
        'Callback',{@saveButton_Callback,S});
    hrun = uicontrol('Style','pushbutton',...
        'String','Run',...
        'Position',[x + 2*w, y , w, h],...
        'Callback',{@runButton_Callback,S});

end

function nPlots = getNPlots(options)
    try 
        nPlots = length(options.output.plots);
    catch
        nPlots = 0;
    end
end

function nImages = getNImages(options)
    try
        nImages = length(options.output.images);
    catch
        nImages = 0;
    end
end

function [ winx, winy, winw, winh, groups, pImageY, pPlotY, pControlY, h, marginx ] = getWindowSpecifications(options)
    winx = 40;    winy = 40;    winw = 800;    winh = 480;
    marginx = 0.01 * winw;
    marginy = 0.01 * winh;

    h = 0.05 * winh;
    buttonw = 0.1 * winw;

    groups = { 'output', 'input', 'calculate' };
    groupsOutput = { 'tables', 'plots', 'images' };
    splitOutputy = round( [ winh, 0.8 * winh, 0.5 * winh , 0.45 * winh ] );
    splitInputy = round( [ 0.4 * winh, 0.1 * winh ] );
    splitCalculatey = round( [ 0.1 * winh, 0 * winh ] );

    starty = splitOutputy(2);
    endy = splitOutputy(3);
    pImageY = round( linspace(starty, endy, getNImages(options)) );
    
    starty = splitOutputy(3) - marginy - h;
    endy = splitOutputy(4) - marginy - h;
    pPlotY = round( linspace(starty, endy, getNPlots(options)) );

    starty = splitCalculatey(1);
    endy = splitCalculatey(2);
    pControlY = (starty+endy)/2;
end


function Sf = initializeGUI(options)

%%%  Create and then hide the UI as it is being constructed.
    [ winx, winy, winw, winh, groups, pImageY, pPlotY, pControlY, h, marginx ] = getWindowSpecifications(options);
    pWindow = [winx,winy,winw,winh];
    S.f = figure('Visible','off','Position', pWindow);

%%% Construct the components.

    [nImages, hImage] = updateImagesGUI(options,S);
    [nPlots, hPlot] = updatePlotsGUI(options,S);
    [hload, hsave, hrun] = updateControlsGUI(options,S);

%%% Show the gui
    set(S.f, 'Visible', 'on');
    Sf = S.f;

end

function updateGUI(options, f)

%%% Show the gui
    set(f, 'Visible', 'off');

    [nImages, hImage] = updateImagesGUI(options);
    [nPlots, hPlot] = updatePlotsGUI(options);
    [hload, hsave, hrun] = updateControlsGUI(options);

%%% Show the gui
    set(f, 'Visible', 'on');

end

%% Callbacks

function saveButton_Callback(varargin)
    % Open a save file dialog to save the adapted options file
    S = varargin{3};
    [FileName,PathName] = uiputfile;
    savejson( fullfile(PathName,FileName) );
end

function loadButton_Callback(varargin)
    S = varargin{3};
    % Open a save file dialog to save the adapted options file
    [FileName,PathName,FilterIndex] = uigetfile('*.json','Select the options file');
    disp(PathName);
    options = loadjson( fullfile(PathName,FileName) );
    updateGUI(options, S.f)
    disp(options);
end

function runButton_Callback(varargin)
    % Open a save file dialog to save the adapted options file
    S = varargin{3};
    disp('Now it should start running');
end
