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

%%  Create and then hide the UI as it is being constructed.
    winx = 40;    winy = 40;    winw = 800;    winh = 480;
    pWindow = [winx,winy,winw,winh];
    f = figure('Visible','off','Position', pWindow);

%% Construct the components.

    nPlots = length(options.output.plots);
    nImages = length(options.output.images);
    marginx = 0.01 * winw;
    marginy = 0.01 * winh;

    h = 0.05 * winh;
    buttonw = 0.1 * winw;

    groups = { 'output', 'input', 'calculate' };
    groupsOutput = { 'tables', 'plots', 'images' };
    splitOutputy = round( [ winh, 0.8 * winh, 0.5 * winh , 0.45 * winh ] );
    splitInputy = round( [ 0.4 * winh, 0.1 * winh ] );
    splitCalculatey = round( [ 0.1 * winh, 0 * winh ] );

%% Output
    starty = splitOutputy(1);
    endy = splitOutputy(2);
    y = round( linspace(starty, endy, nImages) );

    starty = splitOutputy(2);
    endy = splitOutputy(3);% + marginy + h;
    y = round( linspace(starty, endy, nImages) );

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

    starty = splitOutputy(3) - marginy - h;
    endy = splitOutputy(4) - marginy - h;
    y = round( linspace(starty, endy, nPlots) );

    hPlot = cell( length(y), 5 );
    style = {'checkbox', 'text', 'edit', 'edit','popupmenu'};
    w = [ 0.05 * winw, 0.2 * winw, 0.2 * winw, 0.2 * winw, 0.1 * winw ];

    for k = 1:(length(y))
       
        string = {'', options.output.plots{1,k}.name, options.output.plots{1,k}.dir, options.output.plots{1,k}.pattern,...
            {'tif','png'}, {'rgb','gray'}, {'8','16'} };

        x = marginx;
        for m = 1:length(style)
            hImage{k,1} = uicontrol('Style',style{m},...
                     'String',string{m},'Position', [ x, y(k) , w(m), h ] );
            x = x + w(m);
        end
    end
    
%% Show the gui
    set(f, 'Visible', 'on');

%% Callbacks
%  determine which item is currently displayed and make it the
%  current data. This callback automatically has access to 
%  current_data because this function is nested at a lower level.
   function popup_menu_Callback(source,eventdata) 
      % Determine the selected data set.
      str = get(source, 'String');
      val = get(source,'Value');
      % Set current data to the selected data set.
      switch str{val};
      case 'Peaks' % User selects Peaks.
         current_data = peaks_data;
      case 'Membrane' % User selects Membrane.
         current_data = membrane_data;
      case 'Sinc' % User selects Sinc.
         current_data = sinc_data;
      end
   end

  % Push button callbacks. Each callback plots current_data in the
  % specified plot type.

  function surfbutton_Callback(source,eventdata) 
  % Display surf plot of the currently selected data.
       surf(current_data);
  end

  function meshbutton_Callback(source,eventdata) 
  % Display mesh plot of the currently selected data.
       mesh(current_data);
  end

  function contourbutton_Callback(source,eventdata) 
  % Display contour plot of the currently selected data.
       contour(current_data);
  end
end    