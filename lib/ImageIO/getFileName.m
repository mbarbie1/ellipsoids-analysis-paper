% Using the indices of the image, determine a filename corresponding to a
% given pattern. e.g. with
%   regexString = W-[W][ww]_F[ff]_C[cc]_T[tt]_Z[zzz]
%   [wAlpha, wNumber, f, c, t, z] = [E, 6, 0, 1, 0, 3]
%   fileName = getFileName(wAlpha, wNumber, f, c, t, z, regexString)
% ==> fileName :  W-E06_F00_C01_T00_Z003
function fileName = getFileName(wAlpha, wNumber, f, c, t, z, regexString)
    fileName = patternToFile( wAlpha, wNumber, f, c, t, z, regexString );
end

% From the WellAlpha, wellIndex, fieldIndex, channelIndex, timeIndex, 
% zIndex values: [W, w, f, c, t, z] and a fixed pattern to the fileName
% fileName = fixedPattern( [W, w, f, c, t, z], regexString )
function fileName = patternToFile( W, w, f, c, t, z, regexString )

    fileName = regexString;
    indices = {W, w, f, c, t, z};

    a = {'W', 'w', 'f', 'c', 't', 'z'};
    for k = 1:length(a)
        regexBracket = [ '\[[' a{k} ']+\]' ];
        out = regexp(fileName, regexBracket, 'match');
        if (length(out) > 0)
            switch a{k}
                case 'W', str = sprintf(['%0' num2str( length( out{1} )-2 ) 's'], indices{k});
                otherwise, str = sprintf(['%0' num2str( length( out{1} )-2 ) 'd'], indices{k});
            end
            fileName = regexprep(fileName, regexBracket, str );
        end
    end
end
