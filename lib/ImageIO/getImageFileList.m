function c = getImageFileList(imgMeta)

    % if a Selected.indexC is defined use it to select the files
    try
        indexC = imgMeta.Selection.indexC;
        n = 0;
        for k = 1:length(imgMeta.Files)
            if (indexC == getfield( imgMeta.Files{1,k}, 'indexC') )
                n = n+1;
                c{n} = getfield( imgMeta.Files{1,k}, 'path' );
            end
        end
    catch e1
        % if Selected.Files list is defined use it to select the files
        try
            for k = 1:length(imgMeta.Selection.Files)
                c{k} = getfield( imgMeta.Selection.Files{1,k}, 'path' );
            end
        catch e2
            % if no selection is made use the Files list to select all the 
            % files
            for k = 1:length(imgMeta.Files)
                c{k} = getfield( imgMeta.Files{1,k}, 'path' );
            end
        end
    end

end
