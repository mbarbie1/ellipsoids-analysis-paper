% TODO: 
%   * change the mlf file into mrf --> use it to find the amount of
%     channels and their description (such that multiple channels for one
%     action are possible?).

function [ plateName, wells, stack, sublayout ] = plateInfoYokogawa( wpiPath, mrfPath, mesPath )
%%% The function coverageOfWells( imageDir, mlfPath, mesPath ) checks the
%%% availability of the data described in the .mes and mlf files and
%%% whether it is consistent with eachother

%%    

    % LOAD THE PLATE DESCRIPTION FILE (.WPI)
    wpi = xml2struct(wpiPath);
    plateName = wpi.bts_colon_WellPlate.Attributes.bts_colon_Name;
    nRow = str2double(wpi.bts_colon_WellPlate.Attributes.bts_colon_Rows);
    nCol = str2double(wpi.bts_colon_WellPlate.Attributes.bts_colon_Columns);

    % LOAD THE MEASUREMENT SETTINGS FILE (.MES)
    s = xml2struct(mesPath);

    % NODE WITH THE CHANNEL VERSUS ACTION INFORMATION AND SLICE INFORMATION
    noi = s.bts_colon_MeasurementSetting.bts_colon_Timelapse.bts_colon_Timeline.bts_colon_ActionList.bts_colon_ActionAcquire3D;
    for j = 1:length( noi )
        stack{j}.actionId = j;
        stack{j}.top = str2double( noi{1,j}.Attributes.bts_colon_TopDistance );
        stack{j}.bottom = str2double( noi{1,j}.Attributes.bts_colon_BottomDistance );
        stack{j}.AFShiftBase = str2double( noi{1,j}.Attributes.bts_colon_AFShiftBase );
        stack{j}.zStep = str2double( noi{1,j}.Attributes.bts_colon_SliceLength );
        stack{j}.channelId = str2double( noi{1,j}.bts_colon_Ch.Text );
        stack{j}.zSlices = (stack{j}.bottom+stack{j}.AFShiftBase):(stack{j}.zStep):(stack{j}.top);
        stack{j}.nSlices = length(stack{j}.zSlices);
    end
    
    % NODE WITH THE FIELD INFORMATION
    noi = s.bts_colon_MeasurementSetting.bts_colon_Timelapse.bts_colon_Timeline.bts_colon_PointSequence.bts_colon_FixedPosition.bts_colon_Point;
    for j = 1:length( noi )
        sublayout{j}.x = str2double( noi{1,j}.Attributes.bts_colon_X );
        sublayout{j}.y = str2double( noi{1,j}.Attributes.bts_colon_Y );
    end
    
    nFields = length(sublayout);
    %%% Change this to take care of multiple channels measured in one
    %%% action
    nChannels = 4;%length(stack);
    %disp(nFields);
    %disp(nChannels);
    
    % NODE WITH THE WELL INFORMATION
    noi = s.bts_colon_MeasurementSetting.bts_colon_Timelapse.bts_colon_Timeline.bts_colon_WellSequence.bts_colon_TargetWell;
    colLabels = {'A','B','C','D','E','F','G','H'};
    plate = cell( nRow, nCol);
    wells = cell(length( noi ),1);
    for j = 1:length( noi )
        %
        wells{j}.rowId =        str2double(noi{1,j}.Attributes.bts_colon_Row);
        wells{j}.colId =        str2double(noi{1,j}.Attributes.bts_colon_Column);
        wells{j}.rowLabel =     colLabels{ wells{j}.rowId };
        wells{j}.colLabel =     wells{j}.colId;
        %
        plate{wells{j}.rowId, wells{j}.colId}.msr =                 ones( nFields, nChannels );
        plate{wells{j}.rowId, wells{j}.colId}.nScannedSlices =      zeros( nFields, nChannels );
        plate{wells{j}.rowId, wells{j}.colId}.nAvailableSlices =    zeros( nFields, nChannels );
        plate{wells{j}.rowId, wells{j}.colId}.coverageSlices =      zeros( nFields, nChannels );
        %
    end
   

end


