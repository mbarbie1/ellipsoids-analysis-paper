function msra = msrRadiusToArray( msrCell )

    n = length(msrCell);
    msra = zeros(n,4);
    for j = 1:n
        ind = 1;
        disp(j);
        msr = msrCell{j}.Radius;
        if (length(msr(1,:)) > 1)
            [~, ind] = max(msr(1,:));
        end
        msr(1,:)
        msra(j,1) = msr(1,ind);
        msra(j,2) = msr(2,ind);
        msra(j,3) = msr(3,ind);
        msra(j,4) = msr(4,ind);
    end

end

