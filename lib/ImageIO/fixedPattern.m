% From a fixed pattern of a filename to the WellAlpha, wellIndex,
% fieldIndex, channelIndex, timeIndex, zIndex values: [W, w, f, c, t, z] 
% The given pattern could be:
%   regexString = plateName-[W][ww]_F[ff]_C[cc]_T[tt]_Z[zzz]
%   a file with name 'plateName-E06_F00_C01_T00_Z003' would give
%   ==> [w, w, f, c, t, z] = ['E', 6, 0, 1, 0, 3]
function [W, w, f, c, t, z] = fixedPattern( regexString, fileName )

    regexBracket = '\[[Wwfctz]+\]';
    [startIndex, endIndex] = regexp(regexString, regexBracket);
    nMatch = length(startIndex);

    if (nMatch > 0)
        % For each of the [ ] what is inside: W, w, f, c, t, or z
        labelType = cell(nMatch,1);
        for k = 1:nMatch
            labelType{k} = regexString(startIndex(k)+1);
        end

        % shift the indices to remove the space taken by the [ and ]
        %   characters
        sh = (0:1:(nMatch-1)) + (1:nMatch);
        startIndex = startIndex - sh;
        endIndex = endIndex - sh;

        % Default values
        [W, w, f, c, t, z] = defaultLabels();

        for k = 1:nMatch
            N = fileName((startIndex(k)+1):(endIndex(k)-1));
            switch labelType{k}
                case 'W', W = N;
                case 'w', w = str2num(N);
                case 'f', f = str2num(N);
                case 'c', c = str2num(N);
                case 't', t = str2num(N);
                case 'z', z = str2num(N);
                otherwise
            end
        end
    else
        % Default values
        [W, w, f, c, t, z] = defaultLabels();
    end
end
