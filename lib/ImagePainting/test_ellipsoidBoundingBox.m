%% LIBRARY

    clear;
    % BIOFORMATS

    % JSON
    addpath('jsonlab');
    addpath(genpath('c:/Users/mbarbie1/Documents/m_matlab/libImageAnalysis'));

    try
        run('C:\Program Files\DIPimage 2.6\dipstart.m');
    catch e
        return
    end
    
    a = pi/6
    principalAxes{1} = [cos(a),sin(a),0]
    principalAxes{2} = [-sin(a),cos(a),0];
    principalAxes{2} = principalAxes{2} * sqrt(sum(principalAxes{2}.^2))
    principalAxes{3} = [0,0,1]
    axesDimensions(1) = 100
    axesDimensions(2) = 200
    axesDimensions(3) = 10

    radius = [ 200 200 20 ];
    sz = 2*ceil(radius)+1;
    X = xx( sz );
    Y = yy( sz );
    Z = zz( sz );

    b1 = principalAxes{1}
    b2 = principalAxes{2}
    b3 = principalAxes{3}
    Q = [axesDimensions(1)*b1',axesDimensions(2)*b2',axesDimensions(3)*b3']
    Qn(1) = norm(Q(1,:));
    Qn(2) = norm(Q(2,:));
    Qn(3) = norm(Q(3,:));
    Qn
    N = (axesDimensions).^2;
    mask = (  ( (X.*b1(1) + Y.*b1(2) + Z.*b1(3)).^2 ./ N(1) )...
        +  ( (X.*b2(1) + Y.*b2(2) + Z.*b2(3)).^2 ./ N(2) )...
        +   ( (X.*b3(1) + Y.*b3(2) + Z.*b3(3)).^2 ./ N(3) )  )   <   1;

    dipshow(mask);