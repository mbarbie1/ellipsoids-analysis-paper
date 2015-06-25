function mask = getEllipsoidMask( sz, C, A, D)
% getEllipsoidMask: Returns a mask of an ellipsoid with as input the
% centers and the axes (normalized) plus the dimensions of the axes.
% DIPimage!
%
%   INPUT:  
%       sz                : the boxsize of the ellipsoid
%       C                 : the center of the ellipse
%       A                 : the direction vectors of the major axes
%       D                 : dimensions along the major axes
%
%   OUTPUT:  
%       mask              : the ellipsoid mask 

    X = xx(sz) - round(C(1) - sz(1)/2);
    Y = yy(sz) - round(C(2) - sz(2)/2);
    Z = zz(sz) - round(C(3) - sz(3)/2);

    b1 = A(1:3);
    b2 = A(4:6);
    b3 = A(7:9);
    N = (D).^2;
    mask = (  ( (X.*b1(1) + Y.*b1(2) + Z.*b1(3)).^2 ./ N(1) )...
        +  ( (X.*b2(1) + Y.*b2(2) + Z.*b2(3)).^2 ./ N(2) )...
        +   ( (X.*b3(1) + Y.*b3(2) + Z.*b3(3)).^2 ./ N(3) )  )   <   1;
end
