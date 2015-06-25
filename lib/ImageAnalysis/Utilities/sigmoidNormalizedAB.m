function y = sigmoidNormalizedAB(x,x0,w,a,b)
    y = 1 ./ ( 1 + exp(-(x-x0)./w) );
    ymax = 1 ./ ( 1 + exp(-(b-x0)./w));
    ymin = 1 ./ ( 1 + exp(-(a-x0)./w));
    y = (y-ymin) /(ymax-ymin);
end
