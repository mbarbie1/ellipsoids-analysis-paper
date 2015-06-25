% TODO function does not do the correct scaling!
%   Rethink the algorithm.
%
% This function scales the coordinate system and thereby redefines the
% ellipsiod principal axes and their dimensions
function [principalAxes, axesDimensions] = scaleEllipsoidCoords( principalAxes, axesDimensions, scale )

    scaleMatrix = diag(scale);
    Q = [ axesDimensions(1)*principalAxes{1}, axesDimensions(2)*principalAxes{2}, axesDimensions(3)*principalAxes{3} ];
    Q = Q * scaleMatrix;
    for m = 1:3
        axesDimensions(m) = norm(Q(:,m));
        principalAxes{m} = Q(:,m) ./ axesDimensions(m);
    end

end
