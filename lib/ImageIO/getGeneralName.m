% Using indices, determine a name corresponding to a
% given pattern. e.g. with
%   regexString = W-[W][ww]_F[ff]_C[cc]_T[tt]_Z[zzz]
%   subStruct.name = {'W', 'w', 'f', 'c', 't', 'z'}
%   subStruct.value = {E, 6, 0, 1, 0, 3}
%   subStruct.type = {'string', 'int', 'int', 'int', 'int', 'int'}
%   name = getGeneralName(subStruct, regexString)
% ==> name :  W-E06_F00_C01_T00_Z003
function name = getGeneralName(subStruct, regexString)

    name = regexString;
    indexValues = subStruct.value;
    indexNames = subStruct.name;
    indexType = subStruct.type;

    for k = 1:length(indexNames)
        regexBracket = [ '\[[' indexNames{k} ']+\]' ];
        out = regexp(name, regexBracket, 'match');
        if (length(out) > 0)
            switch indexType{k}
                case 'string', str = sprintf(['%0' num2str( length( out{1} ) - 2 ) 's'], indexValues{k});
                otherwise, str = sprintf(['%0' num2str( length( out{1} ) - 2 ) 'd'], indexValues{k});
            end
            name = regexprep(name, regexBracket, str );
        end
    end

end
