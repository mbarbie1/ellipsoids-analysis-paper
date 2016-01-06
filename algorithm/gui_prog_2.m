% function S = generateGUI(options,S)
% 
%     S.fh = figure('units','pixels',...
%                   'position',[500 500 200 260],...
%                   'menubar','none',...
%                   'name','Ellipsoid segmentation',...
%                   'numbertitle','off',...
%                   'resize','off');
% 
%     S.ls = uicontrol('style','list',...
%                      'unit','pix',...
%                      'position',[10 60 180 180],...
%                      'min',0,'max',2,...
%                      'fontsize',14,...
%                      'string',{'one';'two';'three';'four'});         
%     S.pb = uicontrol('style','push',...
%                      'units','pix',...
%                      'position',[10 10 180 40],...
%                      'fontsize',14,...
%                      'string','Delete String',...
%                      'callback',{@pb_call,S});
% 
% end

function [] = gui_prog_2()

    % libs
    addpath(genpath('../lib'));
    % External libs
    addpath(genpath('../libExternal'));

% LOAD DEFAULT OPTIONS
    options = loadjson('input/options_default.json');

% INITIALIZE DEFAULT GUI
    S = initializeGUI(options);
    S = updateGUI(S);

end

function S = initializeGUI(options)

    S = generateGUI(options);

end

function S = updateGUI(S)

    S = updateControlsGUI(S);
    disp(S)
    disp(S)
    S = updateImagesGUI(S);
    disp(S)
    S = updatePlotsGUI(S);
    disp(S)

end

function S = generateGUI(options)

    S = struct();
    S.options = options;

%%%  Create an empty gui
    [ winx, winy, winw, winh, groups, pImageY, pPlotY, pControlY, h, marginx ] = getWindowSpecifications(S.options);
    pWindow = [winx,winy,winw,winh];
    S.fh = figure('Visible','off','Position', pWindow);

%%% Show the gui
    set(S.fh, 'Visible', 'on');

end

function S = updateImagesGUI(S)

    options = S.options;
    try
        S.nImages = length(options.output.images);
    catch
        S.nImages = 0;
    end

    [ winx, winy, winw, winh, groups, pImageY, pPlotY, pControlY, h, marginx ] = getWindowSpecifications(options);
    y = pImageY;
    S.hImage = cell( length(y), 7 );
    style = {'checkbox', 'text', 'edit', 'edit','popupmenu','popupmenu','popupmenu'};
    w = [ 0.05 * winw, 0.2 * winw, 0.2 * winw, 0.2 * winw, 0.1 * winw, 0.1 * winw, 0.1 * winw ];

    for k = 1:(length(y))

        string = {'', options.output.images{1,k}.name, options.output.images{1,k}.dir, options.output.images{1,k}.pattern,...
            {'tif','png'}, {'rgb','gray'}, {'8','16'} };

        x = marginx;
        for m = 1:length(style)
            S.hImage{k,m} = uicontrol('Style',style{m},...
                'String',string{m},'Position', [ x, y(k) , w(m), h ],...
                    'Callback',{@optionsUpdate_Callback,S,k,m,'outputImage'});
            x = x + w(m);
        end
    end
   

end

function S = updatePlotsGUI(S)

    options = S.options;

    try
        S.nPlots = length(options.output.plots);
    catch
        S.nPlots = 0;
    end
    disp(S.nPlots)

    [ winx, winy, winw, winh, groups, pImageY, pPlotY, pControlY, h, marginx ] = getWindowSpecifications(options);
    y = pPlotY;
    S.hPlot = cell( length(y), 5 );
    style = {'checkbox', 'text', 'edit', 'edit','popupmenu'};
    w = [ 0.05 * winw, 0.2 * winw, 0.2 * winw, 0.2 * winw, 0.1 * winw ];

    if (S.nPlots > 0)
        for k = 1:(length(y))

            string = {'', options.output.plots{1,k}.name, options.output.plots{1,k}.dir, options.output.plots{1,k}.pattern,...
                {'tif','png'} };

            x = marginx;
            for m = 1:length(style)
                S.hPlot{k,m} = uicontrol('Style',style{m},...
                    'String',string{m},'Position', [ x, y(k) , w(m), h ],...
                    'Callback',{@optionsUpdate_Callback,S,k,m,'outputPlot'});
                x = x + w(m);
            end
        end
    end
    
end

function S = updateControlsGUI(S)

    options = S.options;

    [ winx, winy, winw, winh, groups, pImageY, pPlotY, pControlY, h, marginx ] = getWindowSpecifications(options);
    x = winx;
    y = pControlY;
    w = 0.1*winw;

    S.hload = uicontrol('Style','pushbutton',...
        'String','Load',...
        'Position',[x, y, w, h],...
        'Callback',{@loadButton_Callback,S});
    S.hsave = uicontrol('Style','pushbutton',...
        'String','Save',...
        'Position',[x + w, y , w, h],...
        'Callback',{@saveButton_Callback,S});
    S.hrun = uicontrol('Style','pushbutton',...
        'String','Run',...
        'Position',[x + 2*w, y , w, h],...
        'Callback',{@runButton_Callback,S});
    disp(S);

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

function saveButton_Callback(varargin)
    % Open a save file dialog to save the adapted options file
    S = varargin{3};
    [FileName,PathName] = uiputfile;
    savejson( '', S.options, fullfile(PathName,FileName) );
end

function loadButton_Callback(varargin)
    S = varargin{3};
    % Open a load file dialog
    [FileName,PathName,FilterIndex] = uigetfile('*.json','Select the options file');
    disp(PathName);
    S.options = loadjson( fullfile(PathName,FileName) );
    updateGUI(S)
end

function runButton_Callback(varargin)
    % Run the algo with the current options
    S = varargin{3};
    disp('Now it should start running');
end

function optionsUpdate_Callback(varargin)
    % Update the options
    S = varargin{3}; disp(S)
    k = varargin{4}; % index of the row of the form line
    m = varargin{5}; % index of the column of the form line
    formType = varargin{6};
    disp('Updating options struct with change made in settings output images');

    try
        hPlot = S.hPlot;
    catch
        warning('no plot handlers (S.hPlot) defined during optionsUpdate_Callback')
    end
    try
        hImage = S.hImage;
    catch
        warning('no image handlers (S.hImage) defined during optionsUpdate_Callback')
    end
    switch (formType)
        case 'outputPlot'
            S.options.output.plots{1,k}.write = get(hPlot{k,1},'Value');
            S.options.output.plots{1,k}.name = get(hPlot{k,2},'String');
            S.options.output.plots{1,k}.dir = get(hPlot{k,3},'String');
            S.options.output.plots{1,k}.pattern = get(hPlot{k,4},'String');
            S.options.output.plots{1,k}.format = get(hPlot{k,5},'String');
        case 'outputImage'
            S.options.output.images{1,k}.write = get(hImage{k,1},'Value');
            S.options.output.images{1,k}.name = get(hImage{k,2},'String');
            S.options.output.images{1,k}.dir = get(hImage{k,3},'String');
            S.options.output.images{1,k}.pattern = get(hImage{k,4},'String');
            S.options.output.images{1,k}.format = get(hImage{k,5},'String');
            S.options.output.images{1,k}.color = get(hImage{k,6},'String');
            S.options.output.images{1,k}.ioMethod = get(hImage{k,7},'String');
        otherwise
            warning('no valid formType')
    end
    disp(m);
    disp(k);
end


%     			{
% 				"name":			"imgSpots",
%                 "write":        1,
%                 "dir":			"output/default/images",
% 				"pattern":		"img_EdU_[nnnn].tif",
% 				"format":		"tif",
% 				"bitDepth":		"uint16",
% 				"color":		"gray",
% 				"ioMethod":		"Matlab"
% 			},

    
%        string = {'', options.output.images{1,k}.name, options.output.images{1,k}.dir, options.output.images{1,k}.pattern,...
%            {'tif','png'}, {'rgb','gray'}, {'8','16'} };

%{'', options.output.plots{1,k}.name, options.output.plots{1,k}.dir, options.output.plots{1,k}.pattern,...
%                {'tif','png'}, {'rgb','gray'}, {'8','16'} };
