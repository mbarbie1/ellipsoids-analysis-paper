function [L1, L2, L3] = imageEigenValues3D(L)

p = L{1,2}.^2 + L{1,3}.^2 + L{2,3}.^2;
% If the trace of the squared diagonal p is zero then  the matrix is
% diagonal, we check both cases with p --> p( p~=0 ) and p( p==0 )
%
%  (1) p == 0:
L1 = newim(size(L{1,1}));
L2 = newim(size(L{1,1}));
L3 = newim(size(L{1,1}));
L1(p==0) = L{1,1}(p==0);
L2(p==0) = L{2,2}(p==0);
L3(p==0) = L{3,3}(p==0);
%
%
%  (2) p ~= 0:
q = (L{1,1} + L{2,2} + L{3,3}) / 3;       % trace(L)/3;
p = (L{1,1} - q).^2 + (L{2,2} - q).^2 + (L{3,3} - q).^2 + 2 * p;
p = sqrt(p / 6);
ndim = 3;
I = num2cell(eye(ndim));
B = cell([ndim,ndim]);
% We loop over the elements in the cell-array
for k = 1:ndim
    for l = 1:ndim
        B{k,l} = (1 ./ p ) .* (L{k,l} - q * I{k,l});       % I is the 3x3 identity cell-matrix
    end
end
% We calculate the 3x3 determinant analytically
r = (...
        B{1,1}.*B{2,2}.*B{3,3} + B{1,2}.*B{2,3}.*B{3,1} + B{1,3}.*B{2,1}.*B{3,2}...
    -   B{1,3}.*B{2,2}.*B{3,1} - B{1,2}.*B{2,1}.*B{3,3} - B{1,1}.*B{2,3}.*B{3,2}...
    ) / 2;   % r = det(B) / 2;
%
% In exact arithmetic for a symmetric matrix  -1 <= r <= 1
% but computation error can leave it slightly outside this range.
% The determinant of B can give NaN values in r so we also check for those
phi = newim(size(r));
bc = ~isnan(r) .* (r > -1) .* (r < 1);
phi( bc ) = acos( r(bc) ) / 3;
phi(r <= -1) = pi / 3;
phi(r >= 1) = 0;
%
% the eigenvalues satisfy L3 <= L2 <= L1
L1(p~=0) = q(p~=0) + 2 * p(p~=0) .* cos(phi(p~=0));
L3(p~=0) = q(p~=0) + 2 * p(p~=0) .* cos(phi(p~=0) + pi * (2/3));
L2(p~=0) = 3 * q(p~=0) - L1(p~=0) - L3(p~=0);     % since trace(A) = L1 + L2 + L3

end
