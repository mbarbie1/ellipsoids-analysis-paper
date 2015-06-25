function [A, B, FittedCurve, sse] = exponential_fit_fromLinearFit(x, y, xfit)

    lny = log(y);
    lny = max(lny, 0.00001);
    x2 = x.^2;
    n = length(x);
    
    denom = (n * sum(x2) - sum(x)^2);
    a = ( sum(lny) * sum(x2) - sum(x) * sum(x .* lny) ) / denom;
    b = ( n * sum( lny .*x ) - sum(x) * sum(lny) ) / denom;
    A = exp(a);
    B = b;
        
    FittedCurve = A .* exp(B * xfit);
    ErrorVector = FittedCurve - y;
    sse = sum(ErrorVector .^ 2);
end

