function [L1, L2] = imageEigenValues2D(L)

    % L_1(2) = Tr[a]/2 -(+) sqrt( Tr[a]^2 - 4 Det[A] ) / 2

    % Tr[L]/2:
    q = (L{1,1} + L{2,2}) / 2;
    % Det[L]:
    r = ( L{1,1} .* L{2,2} )  -  ( L{1,2} .* L{2,1} );

    % L1 < L2
    L1 = q - sqrt(q.^2 - r);
    L2 = q + sqrt(q.^2 - r);
end
