% input: BminpVec, BmaxpVec should be nx2 matrices, and Aminp, Amaxp should
% be 1x2 vectors, the function returns from a rectangle defined by the
% minimum (upper left) and maximum (lower right) corner values, whether
% there is any overlapping rectangle defined by the minimum, maximum
% vectors in BminpVec, BmaxpVec
function overlap = getNN( Aminp, Amaxp, BminpVec, BmaxpVec)

    n = size(BminpVec,1);
    %disp(BminpVec)
    %disp(n)
    overlap = find( sum( ( repmat( Aminp, n, 1) < BmaxpVec & repmat( Amaxp, n, 1) > BminpVec ), 2 ) > 1 );

end
