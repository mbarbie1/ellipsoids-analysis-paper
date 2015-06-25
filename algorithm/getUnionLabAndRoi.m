% img is cell array of dipimage images
function [ union, overlap ] = getUnionLabAndRoi(roi, lab, msr, img)

    nRoi = length(roi);
    nLab = length(msr);

    overlap.pixels = zeros( nRoi, nLab );
    overlap.isDaughter = zeros( nRoi, nLab );
    overlap.M = zeros( nRoi, nLab );
    overlap.m = zeros( nRoi, nLab );
    overlap.numDaughters = zeros( nRoi, 1 );
    overlap.sizeM = zeros( nRoi, 1 );
    overlap.sizem = zeros( nRoi, 1 );
    overlap.missedPixelsM = zeros( nRoi, 1 );
    overlap.missedPixelsm = zeros( nRoi, 1 );
    union = struct('Amask',cell(nRoi,1),'Bmask',cell(nRoi,1),'img',cell(nRoi,1));
    
    for k = 1:nRoi
        % for all roi find overlapping min max rectangles with lab
        % check then whether they are truly overlapping --> calculate overlap
        overlapRect{k} = getNN( roi{1,k}.minp, roi{1,k}.maxp, msr(1:end).Minimum', msr(1:end).Maximum');

        for q = 1:length(overlapRect{k})

            j = overlapRect{k}(q);

            Bminp = msr(j).Minimum';
            Bmaxp = msr(j).Maximum';
            Bmask = lab( Bminp(1):Bmaxp(1), Bminp(2):Bmaxp(2) ) == j;

            Aminp = roi{1,k}.minp-1;
            Amaxp = roi{1,k}.maxp-1;
            Amask = roi{1,k}.mask;

            [union(k).Amask, union(k).Bmask, union(k).img] = getUnion(Aminp, Amaxp, Bminp, Bmaxp, img, Amask, Bmask);

            % check overlap of mask pixels
            M = union(k).Amask;
            m = union(k).Bmask;
            so = sum( m .* M );
            sum_M = sum(M);
            sum_m = sum(m);
            overlap.pixels(k,j) = so;
            overlap.M(k,j) = so / sum_M;
            overlap.m(k,j) = so / sum_m;
            overlap.isDaughter(k,j) = overlap.m(k,j) > 0.5;
            overlap.sizeM(k) = sum_M;
            overlap.sizem(k) = sum_m;
            overlap.missedPixelsM(k) = sum_M - so;
            overlap.missedPixelsm(k) = sum_m - so;
        end

        overlap.daughters{k} = find( overlap.isDaughter(k,:) );
        overlap.numDaughters(k) = sum( overlap.isDaughter(k,:) );
        overlap.numDaughters = overlap.numDaughters';

    end

end
