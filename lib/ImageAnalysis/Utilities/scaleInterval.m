function scale = scaleInterval(minScale, maxScale, nScale)
    scale = exp(linspace(log(minScale), log(maxScale), nScale));
end
