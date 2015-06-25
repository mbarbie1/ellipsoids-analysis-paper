function [a,r,g,b,rgbString] = argbIntToValues(argbInt)
    % ARGB integer to alpha and rgb values
    argbInt = int32(argbInt);
    a = bitand(bitshift(argbInt,-24), hex2dec('ff'));
    r = bitand(bitshift(argbInt,-16), hex2dec('ff'));
    g = bitand(bitshift(argbInt,-8), hex2dec('ff'));
    b = bitand(argbInt, hex2dec('ff'));
    rgbString = ['rgb(' num2str(r) ', ' num2str(g) ', ' num2str(b) ')'];
end
