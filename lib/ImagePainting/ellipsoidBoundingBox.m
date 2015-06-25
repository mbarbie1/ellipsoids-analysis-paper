function halfBoxSide = ellipsoidBoundingBox(axesDimensions, principalAxes)

    % Column vectors are the eigenvectors
    % principalAxes{i} is a column vector of the ith eigenvector
    % axesDimensions(i) is the length of the radius of the ith principal
    % axis
    if ( length(axesDimensions) == 3 )
        Q = [ axesDimensions(1)*principalAxes{1}, axesDimensions(2)*principalAxes{2}, axesDimensions(3)*principalAxes{3} ];
        Qn(1) = norm(Q(1,:));
        Qn(2) = norm(Q(2,:));
        Qn(3) = norm(Q(3,:));
    else if ( length(axesDimensions) == 2 )
            Q = [ axesDimensions(1)*principalAxes{1}, axesDimensions(2)*principalAxes{2} ];
            Qn(1) = norm(Q(1,:));
            Qn(2) = norm(Q(2,:));
        end
    end
    halfBoxSide = Qn;
end
