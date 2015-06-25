% input mx2 matrix with contour coordinates
% output nx2 matrix with contour coordinates where n is larger than m
function newCoords = closeContour(coords)

    % roi close contour path
    p = coords;
    pDiff = abs( p(2:end,:) - p(1:(end-1),:) );
    pGap = max(pDiff > 1,[],2);
    pGapInd = find(pGap);
%    plot(p(:,1),p(:,2),'o-b'); hold on;
    nGap = length(pGapInd);
    pp = p;
    if ( nGap > 0 )
        extraInd = 0;
        for k = 1:nGap
            m = pGapInd(k);
            x1 = p(m,1); x2 = p(m+1,1);
            y1 = p(m,2); y2 = p(m+1,2);
            [x,y] = bresenham(x1,y1,x2,y2);
            if (length(x) > 2)
                x = x(2:end-1);
                y = y(2:end-1);
                pExtra = [x(:), y(:)];
                pp = [pp(1:m,:); pExtra; pp((m+1):end,:)];
%                plot(pExtra(:,1),pExtra(:,2),'*-r'); hold on;
                warning('length(x) > 2 and pGapInd = %i', m);
            else
                warning('length(x) <= 2 and pGapInd = %i', m);
            end
        end
    end
    x1 = p(1,1); x2 = p(end,1);
    y1 = p(1,2); y2 = p(end,2);
    [x,y] = bresenham(x1,y1,x2,y2);
    if (length(x) > 2)
        x = x(2:end-1);
        y = y(2:end-1);
        pExtra = [x(:), y(:)];
        pp = [pp; pExtra];
%        plot(pExtra(:,1),pExtra(:,2),'*-g'); hold on;
    end
    newCoords = pp;
end
