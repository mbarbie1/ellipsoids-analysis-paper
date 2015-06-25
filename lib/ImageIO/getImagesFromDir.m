function plate = getImagesFromDir( imageDir, pattern, nFields, nChannels )
%%% The function coverageOfWells( imageDir, mlfPath, mesPath ) checks the
%%% availability of data at the HD, finds everything through assuming a
%%% pattern for the naming of the image-files

    % LOAD THE PLATE DESCRIPTION FILE (.WPI)
%     wpi = xml2struct(wpiPath);
%     plateName = wpi.bts_colon_WellPlate.Attributes.bts_colon_Name
%     nRow = str2double(wpi.bts_colon_WellPlate.Attributes.bts_colon_Rows)
%     nCol = str2double(wpi.bts_colon_WellPlate.Attributes.bts_colon_Columns)

    rowLabels = {'A', 'B', 'C', 'D', 'E', 'F', 'G', 'H'};
    colLabels = {'1', '2', '3', '4', '5', '6', '7', '8', '9', '10', '11', '12'};
    nRow = length(rowLabels);
    nCol = length(colLabels);
    plate = cell( nRow, nCol);

    % list all files
    files = dir( fullfile(imageDir, 'AssayPlate*.tif') );
    nFiles = length(files);
    fprintf('Checking %i image files\n',nFiles);
    for j = 1:nFiles
        if (mod(j,1000)==0)
                fprintf('Checked %i out of %i\n', j, nFiles);
        end
        [W, w, fieldId, channelId, t, z] = fixedPattern( pattern, files(j).name );
        rowId = strfind( [rowLabels{:}], W );
        colId = w;
        if ( isempty( plate{rowId, colId} ) )
            plate{rowId, colId}.nFileSlices = zeros( nFields, nChannels );
        end
        fileList
    end
    
end
