function [l1, l2, l3] = sortAbsoluteEigenValue(l1, l2, l3)
    %
    al1 = abs(l1);    al2 = abs(l2);    al3 = abs(l3);
    %
    lt1 = l1;
    lt2 = l2;
    lt3 = l3;
    % 321 --> OK
    % 312 --> swap l1 and l2
    o = ( (al3 > al1) .* (al3 > al2) ) .* (al1 > al2);
    lt1( o ) = l2( o );   lt2( o ) = l1( o );
    % 132 --> lt3 = l1, lt2 = l3, lt1 = l2
    o = ( (al1 > al3) .* (al1 > al2) ) .* (al3 > al2);
    lt3( o ) = l1( o );   lt2( o ) = l3( o );   lt1( o ) = l2( o );
    % 123 --> lt3 = l1, lt1 = l3
    o = ( (al1 > al3) .* (al1 > al2) ) .* (al2 > al3);
    lt3( o ) = l1( o );   lt1( o ) = l3( o );
    % 213 --> lt3 = l2, lt2 = l1, lt1 = l3
    o = ( (al2 > al3) .* (al2 > al1) ) .* (al1 > al3);
    lt3( o ) = l2( o );   lt2( o ) = l1( o );   lt1( o ) = l3( o );
    % 231 --> lt3 = l2, lt2 = l3, lt1 = l1
    o = ( (al2 > al3) .* (al2 > al1) ) .* (al3 > al1);
    lt3( o ) = l2( o );   lt2( o ) = l3( o );
    %
    l1 = lt1;
    l2 = lt2;
    l3 = lt3;
end
