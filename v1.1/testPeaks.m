function testPeaks()

    x = [25,25,25,24,25,24,23,18,15,14,20,23,10,11,10,10,12,11,9,6,7,6,5,5,5,5,4,3,2,1,1,1,1,1,1,3,4,5,6,7,8,8,8,8,8,6,5,4,2,3,6,7,12,13,11,10,11,15,17];
    %x = [3,3,3,2,1,2,3,4,4,4,5,6,6,6,6,6,6,4,4,4,5,6,7,7,7,4,4,4,2,1];

    [xPeaks, yPeaks, atBorderPeak] = slowLocalMaxima(x);
    [xDips, yDips, atBorderDip] = slowLocalMaxima(-x); yDips = -yDips;
    
    pPeak = 0*xPeaks;
    wPeak = 0*xPeaks;

    [pks,locs] = findpeaks(x);
    figure();
    scatter(1:length(x), x);hold on;
    plot(x);hold on;
    scatter(locs, pks);hold on;
    scatter(xPeaks, yPeaks, 10);hold on;
    scatter(xDips, yDips, 20);hold off;
end

function [xPeaks, yPeaks, atBorder] = slowLocalMaxima(x, varargin)

    % Defaults
    startSlope = 1;
    stopSlope = -1;
    if nargin > 1, startSlope = varargin{1};end
    if nargin > 2, stopSlope = varargin{2};end


    dLeft = -[startSlope,x(2:end)-x(1:(end-1))];
    dRight = -[-x(2:end)+x(1:(end-1)),-stopSlope];
    xPeaksTemp = find( double( dLeft < 0 & dRight < 0 ) );
    yPeaksTemp = x( dLeft < 0 & dRight < 0 );
    xQ = double( dLeft == 0 & dRight == 0 );
    xQL = double( dLeft < 0 & dRight == 0 );
    xQR = double( dLeft == 0 & dRight < 0 );
    ll = 0*xQ;


    d = 0;
    flatR = 0;
    maxLocation = [];
    maxLocationInteger = [];
    maxValue = [];

    for i = 2:length(x)

        if ( ( xQR(i) && xQL(i-1) ) )
            ll((i-1):i) = 1;
            maxLocation(end+1) = mean( (i-1):i );
            maxLocationInteger(end+1) = i;
            maxValue(end+1) = x(i);
        end
        if ( ( xQR(i) && xQ(i-1) ) && d > 0 && flatR )
            ll((i-d-1):i) = 1;
            maxLocation(end+1) = mean( (i-d-1):i );
            maxLocationInteger(end+1) = ceil( mean( (i-d-1):i ) );
            maxValue(end+1) = x(i);
        end
        if ( ( xQ(i) && xQL(i-1) ) )
            flatR = 1;
        end
        if ( flatR && xQ(i) )
            d = d + 1;
        else
            d = 0;
            flatR = 0;
        end

    end

%     figure();
%     plot(x);hold on;
%     plot(dLeft,'go');hold on;
%     plot(dRight,'ro');hold on;
%     plot(xQL,'g+');hold on;
%     plot(xQR,'r+');hold on;
    
%    figure();
%    plot(x);hold on;
%    scatter(1:length(x), x, 100*(ll+1.0), 1*(ll+1.0));hold on;

%    figure();
    %scatter(1:length(x), x, 20*(xPeaks+xDips+1), 1*(xPeaks-xDips+3));hold on;
%    plot(x);hold on;
%    scatter(1:length(x), x, 100*(xQ+1), 1*(xQ+1));hold on;
    
    xPeaks = [xPeaksTemp, maxLocation];
    yPeaks = [yPeaksTemp, maxValue];
    atBorder = xPeaks == 1 | xPeaks == length(x);

end

%xPeaks

