function [] = gui_analyseImageBatchProcess()

        % libs
        addpath(genpath('../lib'));
        % External libs
        addpath(genpath('../libExternal'));
    % LOAD DEFAULT OPTIONS
        options = loadjson('appdata/options_default_minimal.json');

    % INITIALIZE DEFAULT GUI
    try
        fh = generateGUI(options);
    catch e
        switch e.identifier 
            case 'gui:exit'
                disp('EXIT');
                return;
            otherwise
                %disp('Unknown error: %s', e.message);
        end
    end
        S = guidata(fh);

        %initDefaultSamples(fh);
        updateGUI(fh)


end

% function CloseRequest(fh, eventdata, handles)
% 
%     close(fh);
% end
% 
function loadDIPimage(fh)

    S = guidata(fh);
    try
        if ( exist('dip_initialise_libs')==2 )
        else
            try
                addpath(S.option.dipimagePath);
            catch
            end
            if exist('dip_initialise')
                dip_initialise();
            else
                res = questdlg('DIPimage could not be initialised, if you installed it then it is possible the path to the DIPimage library is not added to the MATLAB path. In that case press OK to select the folder of the DIPimage installation (e.g. C:/Program Files/DIPimage 2.7) in the next dialog. Alternatively, press Cancel not to add the path and continue,or Exit to exit the progam',...
                    'DIPimage could not be initialised' , ...
                    'OK','Cancel','Exit',...
                    'OK');
                switch res
                    case 'OK'
                        pathDir = uigetdir('.',...
                            'Select the DIPimage folder (e.g. C:/Program Files/DIPimage 2.6)');
                        dipimagePath = fullfile(pathDir,'common','dipimage');
                        S.options.dipimagePath = dipimagePath;
                        addpath( dipimagePath );
                        dip_initialise();
                    case 'Cancel'
                        error('gui:dipimage:cancel', 'Cancel DIPimage loading');
                    case 'Exit'
                        close(fh);
                        error('gui:exit', 'Exit the program');
                end
            end
		end
		%run('C:\Program Files\DIPimage 2.6\dipstart.m');
        S.dipimageLoaded = true;
    catch e
        switch e.identifier 
            case 'gui:exit'
                rethrow(e);
            case 'gui:dipimage:cancel'
                %warndlg('Canceled: DIPimage could not be loaded.');
            otherwise
                %warndlg('Unknown error: DIPimage could not be loaded.');
        end
    end
    guidata(fh,S);

end

function fh = generateGUI(options)

    S.options = options;
    S.samplesLoaded = false;
    S.dipimageLoaded = false;
    S.hlog = log4m.getLogger('logfile.txt');

%%%  Create an empty gui
    [ winx, winy, winw, winh, groups, h, marginx ] = getWindowSpecifications(S.options);
    pWindow = [winx,winy,winw,winh];
    fh = figure(...
        'Visible','off',...
        'menubar','none',...
        'name','Ellipsoid Segmentation Analysis',...
        'numbertitle','off',...
        'unit','normalized',...
        'Position', pWindow...
    );

    % create structure of handles
    guidata(fh,S)

%%% Show the gui
    set(fh, 'Visible', 'on');

    initDefaultSamples(fh);
    loadDIPimage(fh);
    
end

function updateGUI(fh)

    updateControlsGUI(fh);
    updateSettingsGUI(fh);
    initSettings(fh);
    updateImagesGUI(fh);
    updateTablesGUI(fh);
    updatePlotsGUI(fh);
    updateInputGUI(fh);
	initInput(fh);
    updateWaitGUI(fh);
    updateStatusGUI(fh);

end

function initDefaultSamples(fh)


    S = guidata(fh);

    %[ PathName, FileName, ext] = fileparts( S.options.input.sampleList );
    S.samplesTable = readtable( S.options.input.sampleList );
    S.samplesLoaded = true;
   
    guidata(fh,S);

end

function handler = tableInput(fh, panel, style, string, y, w, x, h, tableCallback,call)
    for m = 1:length(style)
        handler{m} = uicontrol(...
            'parent', panel,...
            'backgroundcolor',get(fh,'color'),...
            'Style',style{m},...
            'unit','normalized',...
            'String',string{m},...
            'Position', [ x, y, w(m), h ],...
            call{m},{@optionsUpdate_callback,1,m,tableCallback});
        x = x + w(m);
    end
end

function updateTablesGUI(fh)

    S = guidata(fh);

    options = S.options;
    S.nTables = getNTables(options);

    [ winx, winy, winw, winh, groups, h, marginx ] = getWindowSpecifications(options);
    y = linspace(marginx, 1-marginx, getNTables(options)+1);
    y = y(1:(end-1));
    p = groups(find(strcmp({groups.name},'output tables')));
    S.panelTables = uipanel('Parent',fh,'Title',p.label,...
        'backgroundcolor',get(fh,'color'),...
        'Units','normalized',...
             'Position', p.position);

    style = {'checkbox', 'text', 'text', 'edit', 'popupmenu'};
    w = [ 0.05, 0.3, 0.3, 0.2, 0.1];
    h = 1/(getNTables(options)+1);
    x = marginx;
    call = {'Callback','Callback','ButtonDownFcn','Callback','Callback'};

    
    string = {'', 'Summary', options.output.summary.dir, options.output.summary.fileName,...
            {'csv','xlsx','mat'} };
    S.hSummaryTable = tableInput(fh, S.panelTables, style, string, y(1), w, x, h,'summaryTable',call);
    set(S.hSummaryTable{1},'Value', options.output.summary.write)

    string = {'', 'Spots', options.output.spotsAll.dir, options.output.spotsAll.fileName,...
            {'csv','xlsx','mat'} };
    S.hSpotsTable = tableInput(fh, S.panelTables, style, string, y(2), w, x, h,'spotsTable',call);
    set(S.hSpotsTable{1},'Value', options.output.spotsAll.write)

    string = {'', 'Spheroids', options.output.msrAll.dir, options.output.msrAll.fileName,...
            {'csv','xlsx','mat'} };
    S.hSpheroidsTable = tableInput(fh, S.panelTables, style, string, y(3), w, x, h,'spheroidsTable',call);
    set(S.hSpheroidsTable{1},'Value', options.output.msrAll.write)

    
    guidata(fh,S);

end

function initInput(fh)
    
    S = guidata(fh);

	set(S.hNumericSpheroids,'Value', S.options.input.defaultChannelIdSpheroids);
	set(S.hNumericNuclei,'Value', S.options.input.defaultChannelIdNuclei);
	set(S.hNumericSpots,'Value', S.options.input.defaultChannelIdSpots);

    guidata(fh,S);

end

function updateInputGUI(fh)

    S = guidata(fh);

    options = S.options;

    [ winx, winy, winw, winh, groups, h, marginx ] = getWindowSpecifications(options);
    y = 0.25;
    w = 0.4;
    h = 0.2;
    x = marginx;

    p = groups(find(strcmp({groups.name},'input')));
    S.panelInput = uipanel(...
        'Units','normalized',...
        'Parent',fh,...
        'Title',p.label,...
        'backgroundcolor',get(fh,'color'),...
        'Position', p.position);
    
    S.hTextSpheroids = uicontrol(...
        'parent',S.panelInput,...
        'Units','normalized',...
        'backgroundcolor',get(fh,'color'),...
        'Style','text',...
        'String','Spheroids channel name',...
        'Position',[x, y, w, h]);
    nChannels = 9;
    a = 1:nChannels;
    S.hNumericSpheroids = uicontrol(...
        'parent',S.panelInput,...
        'Units','normalized',...
        'backgroundcolor',get(fh,'color'),...
        'Style','popup',...
        'String',mat2cell(a,1,ones(1,size(a,2))),...
        'Position',[x+w, y, w, h],...
        'Callback',{@inputUpdate_callback,'spheroids'});
    
    S.hTextSpots = uicontrol(...
        'parent',S.panelInput,...
        'Units','normalized',...
        'backgroundcolor',get(fh,'color'),...
        'Style','text',...
        'String','Spots channel name',...
        'Position',[x, 2*y, w, h]);
    S.hNumericSpots = uicontrol(...
        'parent',S.panelInput,...
        'Units','normalized',...
        'backgroundcolor',get(fh,'color'),...
        'Style','popup',...
        'String',mat2cell(a,1,ones(1,size(a,2))),...
        'Position',[x+w, 2*y, w, h],...
        'Callback',{@inputUpdate_callback,'spots'});

    S.hTextNuclei = uicontrol(...
        'parent',S.panelInput,...
        'Units','normalized',...
        'backgroundcolor',get(fh,'color'),...
        'Style','text',...
        'String','Nuclear channel name',...
        'Position',[x, 3*y, w, h]);
    S.hNumericNuclei = uicontrol(...
        'parent',S.panelInput,...
        'Units','normalized',...
        'backgroundcolor',get(fh,'color'),...
        'Style','popup',...
        'String',mat2cell(a,1,ones(1,size(a,2))),...
        'Position',[x+w, 3*y, w, h],...
        'Callback',{@inputUpdate_callback,'nuclei'});

    guidata(fh,S);

end

function checkReady(fh)

    S = guidata(fh);

    S.ready = S.dipimageLoaded & S.samplesLoaded;
    if (S.ready)
        set(S.hStatus,'ForegroundColor','green')
        set(S.hStatus,'String','Ready')
    else
        set(S.hStatus,'ForegroundColor','red')
        set(S.hStatus,'String','Not ready')
    end
    if (S.dipimageLoaded)
        set(S.hStatusDIPimage,'ForegroundColor','green')
        set(S.hStatusDIPimage,'String','DIPimage library loaded')
    else
        set(S.hStatus,'ForegroundColor','red')
        set(S.hStatus,'String','DIPimage library not loaded')
    end
    if (S.samplesLoaded)
        set(S.hStatusSamples,'ForegroundColor','green')
        set(S.hStatusSamples,'String','Samples table loaded')
    else
        set(S.hStatusSamples,'ForegroundColor','red')
        set(S.hStatusSamples,'String','Samples table not loaded')
    end

    guidata(fh,S);

end

function updateStatusGUI(fh)

    S = guidata(fh);

    options = S.options;

    [ winx, winy, winw, winh, groups, h, marginx ] = getWindowSpecifications(options);
    y = 0.3;
    w = 0.9;
    h = 0.3;
    x = marginx;

    p = groups(find(strcmp({groups.name},'status')));
    S.panelStatus = uipanel(...
        'Units','normalized',...
        'Parent',fh,...
        'Title',p.label,...
        'backgroundcolor',get(fh,'color'),...
        'Position', p.position);

    S.hStatus = uicontrol(...
        'parent',S.panelStatus,...
        'Units','normalized',...
        'backgroundcolor',get(fh,'color'),...
        'Style','text',...
        'ForegroundColor','red',...
        'String','Not ready',...
        'Position',[x, 1-y-marginx, w, h]);
    
    S.hStatusDIPimage = uicontrol(...
        'parent',S.panelStatus,...
        'Units','normalized',...
        'backgroundcolor',get(fh,'color'),...
        'Style','text',...
        'ForegroundColor','red',...
        'String','DIPimage library not loaded',...
        'Position',[x, 1-2*y-marginx, w, h]);

    S.hStatusSamples = uicontrol(...
        'parent',S.panelStatus,...
        'Units','normalized',...
        'backgroundcolor',get(fh,'color'),...
        'Style','text',...
        'ForegroundColor','red',...
        'String','No samples table loaded',...
        'Position',[x, 1-3*y-marginx, w, h]);

    guidata(fh,S);
    
    checkReady(fh)

end

function updateImagesGUI(fh)

    S = guidata(fh);

    options = S.options;
    S.nImages = getNImages(options);

    [ winx, winy, winw, winh, groups, h, marginx ] = getWindowSpecifications(options);
    y = linspace(marginx, 1-marginx, getNImages(options)+1);
    y = y(1:(end-1));
    S.hImage = cell( length(y), 7 );
    p = groups(find(strcmp({groups.name},'output images')));
    S.panelImages = uipanel('Parent',fh,'Title',p.label,...
        'backgroundcolor',get(fh,'color'),...
        'Units','normalized',...
             'Position', p.position);

    style = {'checkbox', 'text', 'text', 'edit','popupmenu'};
    w = [ 0.05, 0.3, 0.3, 0.2, 0.1 ];
    h = 1/(getNImages(options)+1);

    for k = 1:(length(y))

        string = {'', options.output.images{1,k}.label, options.output.images{1,k}.dir, options.output.images{1,k}.pattern,...
            {'tif','png'} };
        call = {'Callback','Callback','ButtonDownFcn','Callback','Callback'};

        x = marginx;
        for m = 1:length(style)
            S.hImage{k,m} = uicontrol(...
                'parent', S.panelImages,...
                'backgroundcolor',get(fh,'color'),...
                'Style',style{m},...
                'unit','normalized',...
                'String',string{m},...
                'Position', [ x, y(k), w(m), h ],...
                call{m},{@optionsUpdate_callback,k,m,'outputImage'});
            x = x + w(m);
        end
        set(S.hImage{k,1},'Value', options.output.images{1,k}.write)
    end

    guidata(fh,S);

end

function updatePlotsGUI(fh)

    S = guidata(fh);

    options = S.options;
    S.nPlots = getNPlots(options);

    [ winx, winy, winw, winh, groups, h, marginx ] = getWindowSpecifications(options);
    y = linspace(marginx + 0.2, 1-marginx, getNPlots(options)+1);
    y = y(1:(end-1));

    p = groups(find(strcmp({groups.name},'output plots')));
    S.panelPlots = uipanel('Parent',fh,'Title',p.label,...
            'backgroundcolor',get(fh,'color'),...
            'Units','normalized',...
             'Position', p.position);

    S.hPlot = cell( length(y), 5 );
    style = {'checkbox', 'text', 'text', 'edit','popupmenu'};
    w = [ 0.05, 0.3, 0.3, 0.2, 0.1 ];
    h = 1/(getNPlots(options)+1);

    if (S.nPlots > 0)
        for k = 1:(length(y))

            string = {'', options.output.plots{1,k}.name, options.output.plots{1,k}.dir, options.output.plots{1,k}.pattern,...
                {'tif','png'} };

            x = marginx;
            for m = 1:length(style)
                S.hPlot{k,m} = uicontrol(...
                    'backgroundcolor',get(fh,'color'),...
                    'parent',S.panelPlots,...
                    'Style',style{m},...
                    'Units','normalized',...
                    'String',string{m},'Position', [ x, y(k) , w(m), h ],...
                    'Callback',{@optionsUpdate_callback,k,m,'outputPlot'});
                x = x + w(m);
            end
            set(S.hPlot{k,1},'Value', options.output.plots{1,k}.write)
    
        end
    end
    
    guidata(fh,S);
    
end

function updateControlsGUI(fh)

    S = guidata(fh);

    options = S.options;

    [ winx, winy, winw, winh, groups, h, marginx ] = getWindowSpecifications(options);
    y = 0.2;
    w = 0.1;
    h = 0.7;
    x = marginx;

    p = groups(find(strcmp({groups.name},'controls')));
    S.panelPlots = uipanel(...
        'Units','normalized',...
        'Parent',fh,...
        'Title',p.label,...
        'backgroundcolor',get(fh,'color'),...
        'Position', p.position);
    
    S.hload = uicontrol(...
        'parent',S.panelPlots,...
        'Units','normalized',...
        'backgroundcolor',get(fh,'color'),...
        'Style','pushbutton',...
        'String','Load',...
        'Position',[x, y, w, h],...
        'Callback',@loadButton_callback);
    S.hsave = uicontrol(...
        'parent',S.panelPlots,...
        'Units','normalized',...
        'backgroundcolor',get(fh,'color'),...
        'Style','pushbutton',...
        'String','Save',...
        'Position',[x + (w+marginx), y , w, h],...
        'Callback',@saveButton_callback);
    S.hrun = uicontrol(...
        'parent',S.panelPlots,...
        'Units','normalized',...
        'backgroundcolor',get(fh,'color'),...
        'Style','pushbutton',...
        'String','Run',...
        'Position',[x + 2*(w+marginx), y , w, h],...
        'Callback',@runButton_callback);
%     if (S.samplesLoaded)
%         set(S.hrun,'Enable','on');
%     else
%         set(S.hrun,'Enable','off'); 
%     end

    w = w*2;
%     S.hloadDIPimage = uicontrol(...
%         'Parent',S.panelPlots,...
%         'Style','pushbutton',...
%         'String','Add DIPimage path',...
%         'backgroundcolor',get(fh,'color'),...
%         'unit','normalized',...
%         'Position',[1-3*marginx-3*w, y, w, h],...
%         'Callback',@loadDIPimageButton_callback);
    S.hloadSamples = uicontrol(...
        'Parent',S.panelPlots,...
        'Style','pushbutton',...
        'String','Load Samples data',...
        'backgroundcolor',get(fh,'color'),...
        'unit','normalized',...
        'Position',[1-2*marginx-2*w, y, w, h],...
        'Callback',@loadSamplesButton_callback);
    S.hshowSamples = uicontrol(...
        'Parent',S.panelPlots,...
        'Style','pushbutton',...
        'backgroundcolor',get(fh,'color'),...
        'String','Show samples table',...
        'unit','normalized',...
        'Position',[1-marginx-w, y , w, h],...
        'Callback',@showSamplesButton_callback);

    guidata(fh,S);

end

function updateWaitGUI(fh)

    S = guidata(fh);

    options = S.options;

    [ winx, winy, winw, winh, groups, h, marginx ] = getWindowSpecifications(options);
    y = 0.2;
    w = 0.1;
    h = 0.7;
    x = marginx;

    p = groups(find(strcmp({groups.name},'wait')));
    S.panelWait = uipanel(...
        'Units','normalized',...
        'Parent',fh,...
        'Title',p.label,...
        'backgroundcolor',get(fh,'color'),...
        'Position', p.position);
        
    S.hwait = waitbar2a(0, S.panelWait);
    waitbar2a(0, S.hwait, 'No process');

    guidata(fh,S);

end

function n = ensureNumeric(source)
    str=get(source,'String');
    if isempty(str2num(str))
        set(source,'string','0');
        warndlg('Input must be numerical');
        n = 0;
    else
        n = str2num(str);
    end
    
end

function initSettings(fh)
    
    S = guidata(fh);

    options = S.options;
    [nSettings, nS] = getNSettings(options);

	for k = 1:nSettings

		switch S.options.settings{k}.type
            case 'numeric'
                S.options.(S.options.settings{1,k}.category).(S.options.settings{1,k}.name) = S.options.settings{1,k}.value;
                S.options.(S.options.settings{k}.category).([S.options.settings{k}.name 'Automatic']) = S.options.settings{k}.automatic;
				set(S.hSetting{k,3},'Value',S.options.settings{1,k}.value);
				set(S.hSetting{k,2},'Value',S.options.settings{k}.automatic);
				if (S.options.settings{k}.automatic)
					set(S.hSetting{k,3}, 'Enable', 'off')
				else
					set(S.hSetting{k,3}, 'Enable', 'on')
				end
            case 'boolean'
                S.options.(S.options.settings{1,k}.category).(S.options.settings{1,k}.name) = S.options.settings{1,k}.value;
				set(S.hSetting{k,2},'Value',S.options.settings{1,k}.value);
            case 'choice'
                items = S.options.settings{1,k}.list;
                indexSelected = S.options.settings{1,k}.selected;
                temp = items{indexSelected};
                S.options.(S.options.settings{k}.category).(S.options.settings{k}.name) = temp;
				set(S.hSetting{k,2},'Value',indexSelected);
            otherwise
                error('initSettings::Invalid parameter definition detected')
		end
        
	end

    guidata(fh,S);

end

function updateSettingsGUI(fh)

    S = guidata(fh);

    options = S.options;

    [ winx, winy, winw, winh, groups, h, marginx ] = getWindowSpecifications(options);
    tabMargin = 0.05;
    [nSettings, nS] = getNSettings(options);
    y = linspace(marginx, 1-marginx, max(nS)+1);
    y = y(1:(end-1));
    S.hSetting = cell( nSettings, 3 );

    x = marginx;
    p = groups(find(strcmp({groups.name},'settings')));

    S.panelSettings = uipanel(...
        'Units','normalized',...
        'backgroundcolor',get(fh,'color'),...
        'Parent',fh,...
        'Title',p.label,...
        'Position', p.position);
    tgroup = uitabgroup('Parent', S.panelSettings,'Units','normalized');
    %set(tgroup, 'BackgroundColor', get(fh,'color') );
    tab1 = uitab('Parent', tgroup, 'Title', 'Segmentation','Units','normalized',...
        'backgroundcolor',get(fh,'color'));
    tab2 = uitab('Parent', tgroup, 'Title', 'Ellipsoid fit','Units','normalized',...
        'backgroundcolor',get(fh,'color'));
    tab3 = uitab('Parent', tgroup, 'Title', 'Attenuation','Units','normalized',...
        'backgroundcolor',get(fh,'color'));
    tab4 = uitab('Parent', tgroup, 'Title', 'Spot detection','Units','normalized',...
        'backgroundcolor',get(fh,'color'));

    h = 1/(max(nS)+1);

    indexCategory = zeros(length(nS),1);
    for k = 1:nSettings

        switch options.settings{k}.type
            case 'numeric'
                style = {'text', 'checkbox', 'edit'};
                w = [ 0.45, 0.1, 0.4];
                string = {options.settings{1,k}.label, 'Automatic', options.settings{1,k}.value};
                call = {'Callback','Callback','Callback'};
            case 'boolean'
                style = {'text', 'checkbox'};
                w = [ 0.45, 0.5];
                string = {options.settings{1,k}.label, ''};
                call = {'Callback','Callback'};
            case 'choice'
                style = {'text', 'popupmenu'};
                w = [ 0.45, 0.5];
                string = { options.settings{1,k}.label, options.settings{1,k}.list };
                call = {'Callback','Callback'};
            otherwise
                warning('Invalid parameter definition detected')
        end        
        
        
        x = marginx;
        switch options.settings{k}.category
            case 'segmentation'
                p = tab1;
                indexCategory(1) = indexCategory(1) +1;
                yIndex = indexCategory(1);
            case 'ellipsoidFit'
                p = tab2;
                indexCategory(2) = indexCategory(2) +1;
                yIndex = indexCategory(2);
            case 'attenuationAnalysis'
                p = tab3;
                indexCategory(3) = indexCategory(3) +1;
                yIndex = indexCategory(3);
            case 'spotDetection'
                p = tab4;
                indexCategory(4) = indexCategory(4) +1;
                yIndex = indexCategory(4);
            otherwise
                error('Category of the setting is unknown')
        end
        for m = 1:length(style)
            S.hSetting{k,m} = uicontrol(...
                'parent', p,...
                'backgroundcolor',get(fh,'color'),...
                'Style',style{m},...
                'unit','normalized',...
                'String',string{m},...
                'Position', [ x, 1-y(yIndex)-h, w(m), h ],...
                call{m},{@settingsUpdate_callback,k,m,''});
            x = x + w(m);
        end
    end

    guidata(fh,S);

end

function nPlots = getNPlots(options)
    try 
        nPlots = length(options.output.plots);
    catch
        nPlots = 0;
    end
end

function nTables = getNTables(options)
    try 
        nTables = 3;%length(options.output.tables);
    catch
        nTables = 3;
    end
end

function nImages = getNImages(options)
    try
        nImages = length(options.output.images);
    catch
        nImages = 0;
    end
end

function [nSettings, nS] = getNSettings(options)
    try
        nSettings = length(options.settings);
        nS = [0; 0; 0; 0];
        for i = 1:nSettings
            switch options.settings{i}.category
                case 'segmentation'
                    nS(1) = nS(1) + 1;
                case 'ellipsoidFit'
                    nS(2) = nS(2) + 1;
                case 'spotDetection'
                    nS(4) = nS(4) + 1;
                case 'attenuationAnalysis'
                    nS(3) = nS(3) + 1;
                otherwise
                    warning('Category of the setting is unknown')
            end
        end
    catch
        error('Category of the setting is unknown')
        nSettings = 0;
        nS = 0
    end
end

function [ winx, winy, winw, winh, groups, buttonh, marginx ] = getWindowSpecifications(options)
    
    winx = 0.05;    winy = 0.05;    winw = 0.5;    winh = 0.9;
    pWin = [winx, winy, winw, winh];
    marginx = 0.02;
    marginy = 0.02;

    nPlots = getNPlots(options);
    nInput = 3;
    nTables = getNTables(options);
    nImages = getNImages(options);
    nTotalH = nInput + nPlots + nTables + nImages + 8 * marginy + 8;
    outputFilesH = 0.5;
    inputH = outputFilesH * ( nInput + 2 + 3*marginy ) / nTotalH;
    plotsH = outputFilesH * ( nPlots + 2 + 3*marginy ) / nTotalH;
    imagesH = outputFilesH * ( nImages + 2 + 3*marginy ) / nTotalH;
    tablesH = outputFilesH * ( nTables + 2 + 3*marginy ) / nTotalH;
    
    h = 0.1;
    buttonw = 0.1;
    buttonh = 0.1;
    wWait = 0.2;
    wStatus = 0.5;

    groups = struct('position',{},'name',{}, 'label',{}, 'description',{}, 'h',{});

    j = 1; y = marginy;

% Controls
    groups(j).h = 0.1;
    groups(j).position = [marginx,marginy,1-3*marginx-wWait,groups(j).h];
    groups(j).name = 'controls';
    groups(j).label = 'Control';
    groups(j).description = '';
    j = j+1;

% Wait bar
    groups(j).h = 0.1;
    groups(j).position = [1-marginx-wWait,marginy,wWait,groups(j).h];
    groups(j).name = 'wait';
    groups(j).label = 'Process';
    groups(j).description = '';

    y = y + groups(j).h; j = j+1;

% Algorithm settings
    groups(j).h = 0.4 -marginy;
    groups(j).position = [marginx, y, 1-2*marginx,groups(j).h];
    groups(j).name = 'settings';
    groups(j).label = 'Settings';
    groups(j).description = '';
    y = y + groups(j).h; j = j+1;

% Output tables
    y = 0.5;
    groups(j).h = tablesH;
    groups(j).position = [marginx, y, 1-2*marginx, groups(j).h];
    groups(j).name = 'output tables';
    groups(j).label = 'Output tables';
    groups(j).description = '';
    y = y + groups(j).h; j = j+1;

% Output images
    groups(j).h = imagesH;
    groups(j).position = [marginx,y,1-2*marginx,groups(j).h];
    groups(j).name = 'output images';
    groups(j).label = 'Output images';
    groups(j).description = '';
    y = y + groups(j).h; j = j+1;

% Plots
    groups(j).h = plotsH;
    groups(j).position = [marginx,y,1-2*marginx,groups(j).h];
    groups(j).name = 'output plots';
    groups(j).label = 'Output plots';
    groups(j).description = '';
    y = y + groups(j).h; j = j+1;

% Status of the inputs    
    groups(j).h = inputH;
    groups(j).position = [1-marginx-wStatus,y,wStatus,groups(j).h];
    groups(j).name = 'status';
    groups(j).label = 'Status';
    groups(j).description = '';
    j = j+1;

% Input    
    groups(j).h = inputH;
    groups(j).position = [marginx,y,1-3*marginx-wStatus,groups(j).h];
    groups(j).name = 'input';
    groups(j).label = 'Input';
    groups(j).description = '';
    y = y + groups(j).h; j = j+1;



end

function saveButton_callback(hObject, eventdata)
    % Open a save file dialog to save the adapted options file
    S = guidata(hObject);
    [FileName,PathName] = uiputfile;
    savejson( '', S.options, fullfile(PathName,FileName) );
end

function loadButton_callback(hObject, eventdata)
    S = guidata(hObject);
    % Open a load file dialog
    [FileName,PathName,FilterIndex] = uigetfile('*.json','Select the options file');
    try
        S.options = loadjson( fullfile(PathName,FileName) );
        updateGUI( get(hObject,'parent') );
    catch
        warndlg('No valid json file selected')
    end
end

function runButton_callback(hObject, eventdata)
    % Run the algo with the current options
    %fh = get(hObject,'parent');
    %S = guidata(fh);
    S = guidata(hObject);

    warning('off','all')

%% LOADING LIBRARIES

    % DIPimage
    if (S.samplesLoaded)
        try
			dip_initialise();
        catch e
            return
        end
        analyseImageBatchProcess(S.options, S.samplesTable, S.hwait, S.hlog);
    else
        warndlg('Before a batch process can be run, a samples table should be loaded (using the "load samples" button.)');
    end

end

function runTestButton_callback(hObject, eventdata)
    % Run the algo with the current options but only for the first image
    disp('Run the algorithm only for the first image in the samples table');
    S = guidata(hObject);
end

function loadSamplesButton_callback(hObject, eventdata)
    % Load the samples table (excel, csv, json?)
    disp('Load the samples table');
    S = guidata(hObject);
    [FileName,PathName,FilterIndex] = uigetfile({...
        '*.dat;*.txt;*.csv', 'Tab delimited (*.dat;*.txt;*.csv)';...
        '*.xlsx;*.xls;*.xlsm;*.ods', 'Excel files (*.xlsx,*.xls,*.xlsm,*.ods)'},...
        'Select the file containing the sample descriptions');
    S.samplesTable = readtable( fullfile(PathName,FileName) );
    S.samplesLoaded = true;

    guidata(hObject,S);
end

function showSamplesButton_callback(hObject, eventdata)
    % Run the algo with the current options
    disp('Show the samples data table');
    S = guidata(hObject);
    disp('showSamplesButton_callback')
    try
        S.hsamplesTable = uitable(figure('name','Image data table'),'Data',table2cell(S.samplesTable));
    catch
        warning('No samples table exists');
    end
end

function loadDIPimageButton_callback(hObject, eventdata)
    % User input for the DIPimage path
    disp('User picks DIPimage path when DIPimage is not added to the MATLAB path yet');
       
    pathDir = uigetdir('.',...
        'Select the DIPimage folder (e.g. C:/Program Files/DIPimage 2.6)');
    dipimagePath = fullfile(pathDir,'common','dipimage');
	addpath( dipimagePath );
    loadDIPimage(fh);
    disp( dipimagePath );
end

function settingsUpdate_callback(hObject, eventdata, varargin)
    
    disp('settingsUpdate_callback::Updating options struct with changes made in the algorithm settings');

    fh = get(hObject,'parent');
    S = guidata(fh);

    % Update the options
    k = varargin{1}; % index of the row of the form line
    formType = '';

    try
        hSetting = S.hSetting;
    catch
        warning('settingsUpdate_Callback::no setting handlers (S.hSetting) defined')
    end

    switch (formType)
        case ''
            settingType = S.options.settings{k}.type;
            switch (settingType)
                case 'choice'
                    items = get(hSetting{k,2},'String'); indexSelected = get(hSetting{k,2},'Value'); S.options.settings{k}.selected = indexSelected;
                    temp = items{indexSelected,1}; S.options.(S.options.settings{k}.category).(S.options.settings{k}.name) = temp;
                case 'numeric'
                    S.options.settings{k}.automatic = get(hSetting{k,2},'Value'); S.options.settings{k}.value = ensureNumeric( hSetting{k,3} );
                    S.options.(S.options.settings{k}.category).(S.options.settings{k}.name) = S.options.settings{k}.value;
                    S.options.(S.options.settings{k}.category).([S.options.settings{k}.name 'Automatic']) = S.options.settings{k}.automatic;
                    if (S.options.settings{k}.automatic)
                        set(S.hSetting{k,3}, 'Enable', 'off')
                    else
                        set(S.hSetting{k,3}, 'Enable', 'on')
                    end
                case 'boolean'
                    S.options.settings{k}.value = get(hSetting{k,2},'Value');
                    S.options.(S.options.settings{k}.category).(S.options.settings{k}.name) = S.options.settings{k}.value;
            end
    end

    guidata(fh,S);

end

function optionsUpdate_callback(hObject, eventdata, varargin)

    disp('Updating options struct with changes made in the settings of the output images');

    fh = get(hObject,'parent');
    S = guidata(fh);

    % Update the options
    k = varargin{1}; % index of the row of the form line
    m = varargin{2}; % index of the column of the form line
    formType = varargin{3};

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
    try
        hSpotsTable = S.hSpotsTable;
    catch
        warning('no spots table handler (S.hSpotsTable) defined during optionsUpdate_Callback')
    end
    try
        hSpheroidsTable = S.hSpheroidsTable;
    catch
        warning('no spheroids table handler (S.hSpheroidsTable) defined during optionsUpdate_Callback')
    end
    try
        hSummaryTable = S.hSummaryTable;
    catch
        warning('no summary table handler (S.hSummaryTable) defined during optionsUpdate_Callback')
    end

    switch (formType)
        case 'outputPlot'
            S.options.output.plots{1,k}.write = get(hPlot{k,1},'Value');
            if (m == 3)
                S.options.output.plots{1,k}.dir = uigetdir('.','Choose folder for plot');
                if (S.options.output.plots{1,k}.dir ~= 0)
                    set(hPlot{k,3}, 'String', S.options.output.plots{1,k}.dir);
                end
            end
            S.options.output.plots{1,k}.pattern = get(hPlot{k,4},'String');
            items = get(hPlot{k,5},'String'); indexSelected = get(hPlot{k,5},'Value'); S.options.output.plots{1,k}.format = items{indexSelected};
        case 'outputImage'
            S.options.output.images{1,k}.write = get(hImage{k,1},'Value');
            if (m == 3)
                S.options.output.images{1,k}.dir = uigetdir('.','Choose folder for image');
                if (S.options.output.images{1,k}.dir ~= 0)
                    set(hImage{k,3}, 'String', S.options.output.images{1,k}.dir);
                end
            end
            S.options.output.images{1,k}.pattern = get(hImage{k,4},'String');
            items = get(hImage{k,5},'String'); indexSelected = get(hImage{k,5},'Value'); S.options.output.images{1,k}.format = items{indexSelected};
            %items = get(hImage{k,6},'String'); indexSelected = get(hImage{k,6},'Value'); S.options.output.images{1,k}.color = items{indexSelected};
            %items = get(hImage{k,7},'String'); indexSelected = get(hImage{k,7},'Value'); S.options.output.images{1,k}.bitDepth = items{indexSelected};
        case 'spotsTable'
            S.options.output.spotsAll.write = get(hSpotsTable{1,1},'Value');
            if (m == 3)
                S.options.output.spotsAll.dir = uigetdir('.','Choose folder for the spots table');
                if (S.options.output.spotsAll.dir ~= 0)
                    set(hSpotsTable{1,3}, 'String', S.options.output.spotsAll.dir);
                end
            end
            S.options.output.spotsAll.fileName = get(hSpotsTable{1,4},'String');
            items = get(hSpotsTable{k,5},'String'); indexSelected = get(hSpotsTable{1,5},'Value'); S.options.output.spotsAll.format = items{indexSelected};
        case 'spheroidsTable'
            S.options.output.msrAll.write = get(hSpheroidsTable{1,1},'Value');
            if (m == 3)
                S.options.output.msrAll.dir = uigetdir('.','Choose folder for the spheroids table');
                if (S.options.output.msrAll.dir ~= 0)
                    set(hSpheroidsTable{1,3}, 'String', S.options.output.msrAll.dir);
                end
            end
            S.options.output.msrAll.fileName = get(hSpheroidsTable{1,4},'String');
            items = get(hSpheroidsTable{k,5},'String'); indexSelected = get(hSpheroidsTable{1,5},'Value'); S.options.output.msrAll.format = items{indexSelected};
        case 'summaryTable'
            S.options.output.summary.write = get(hSummaryTable{1,1},'Value');
            if (m == 3)
                S.options.output.summary.dir = uigetdir('.','Choose folder for the summary table');
                if (S.options.output.summary.dir ~= 0)
                    set(hSummaryTable{1,3}, 'String', S.options.output.summary.dir);
                end
            end
            S.options.output.summary.fileName = get(hSummaryTable{1,4},'String');
            items = get(hSummaryTable{k,5},'String'); indexSelected = get(hSummaryTable{1,5},'Value'); S.options.output.summary.format = items{indexSelected};
        otherwise
            warning('no valid formType')
    end
    guidata(fh,S);

end

function inputUpdate_callback(hObject, eventdata, varargin)

    disp('Updating options struct with changes made in the input channels');

    fh = get(hObject,'parent');
    S = guidata(fh);

    % Update the options
	S.options.input.channelIdSpheroids = get(S.hNumericSpheroids,'Value');
	S.options.input.channelIdNuclei = get(S.hNumericNuclei,'Value');
	S.options.input.channelIdSpots = get(S.hNumericSpots,'Value');

	guidata(fh,S);

end
