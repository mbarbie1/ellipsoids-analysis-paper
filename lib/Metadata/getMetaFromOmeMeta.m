function meta = getMetaFromOmeMeta(omeMeta)

    try 
        meta.sizeX = omeMeta.getPixelsSizeX(0).getValue(); % image width, pixels
    catch error
        meta.sizeX = - 1;
%        warning(error.message);
    end

    try
        meta.sizeY = omeMeta.getPixelsSizeY(0).getValue(); % image height, pixels
    catch error
        meta.sizeY = -1;
%        warning(error.message);
    end

    try
        meta.sizeZ = omeMeta.getPixelsSizeZ(0).getValue(); % image depth, pixels
    catch error
        meta.sizeZ = -1;
%        warning(error.message);
    end

    try
        meta.sizeC = omeMeta.getPixelsSizeC(0).getValue(); % number of channels
    catch error
        meta.sizeC = -1;
%        warning(error.message);
    end

    try
        meta.sizeT = omeMeta.getPixelsSizeT(0).getValue(); % number of timepoints
    catch error
        meta.sizeT = -1;
%        warning(error.message);
    end

    try
        meta.pixelSizeX = omeMeta.getPixelsPhysicalSizeX(0).getValue(); % in µm
    catch error
        meta.pixelSizeX = -1;
%        warning(error.message);
    end

    try
        meta.pixelSizeY = omeMeta.getPixelsPhysicalSizeY(0).getValue(); % in µm
    catch error
        meta.pixelSizeY = -1;
%        warning(error.message);
    end

    try
        meta.pixelSizeZ = omeMeta.getPixelsPhysicalSizeZ(0).getValue(); % in µm
    catch error
        warning(error.message);
        try
            meta.pixelSizeZ = abs( omeMeta.getPlanePositionZ(0, meta.sizeC).doubleValue() - omeMeta.getPlanePositionZ(0, 0).doubleValue() ); % in µm
        catch error
            meta.pixelSizeZ = -1;
            warning(error.message);
        end
    end

    try
        meta.positionUnitX =  omeMeta.getPlanePositionX(0, 0).doubleValue(); % in µm
        meta.positionUnitY = omeMeta.getPlanePositionY(0, 0).doubleValue(); % in µm
        meta.positionUnitZ = omeMeta.getPlanePositionZ(0, 0).doubleValue(); % in µm
    catch error
        meta.positionUnitX =  0; % in µm
        meta.positionUnitY = 0; % in µm
        meta.positionUnitZ = 0; % in µm
        warning(error.message);
    end

    try
        meta.pixelSizeT = omeMeta.getPixelsTimeIncrement(0).doubleValue(); % in µm
    catch error
        meta.pixelSizeT = -1;
%        warning(error.message);
    end

    try
        meta.bitDepth = char(omeMeta.getPixelsType(0).getValue());
    catch error
        meta.bitDepth = 'unknown';
%        warning(error.message);
    end

    try 
        meta.magnification = omeMeta.getObjectiveNominalMagnification(0,0);
    catch error
        meta.magnification = 'unknown';
%        warning(error.message);
    end

    try
        meta.objectiveLensNA = omeMeta.getObjectiveLensNA(0,0); %(int instrumentIndex, int objectiveIndex)
    catch error
        meta.objectiveLensNA = -1;
%        warning(error.message);
    end

    try 
        for j = 1:meta.sizeC
                meta.channelColorNumber(j) = omeMeta.getChannelColor(0, j-1).getValue();
                %meta.channelColorRed{j} = bitand(meta.channelColorNumber(j), 2^8);
                %meta.channelColorGreen{j} = bitand(meta.channelColorNumber(j), 2^16-1);
                %meta.channelColorBlue{j} = bitand(meta.channelColorNumber(j), 2^24-1);
                %meta.channelColorLabel{j} = meta.channelColorNumber(j)
        end
    catch error
        meta.channelColorNumber = 0 * [1:meta.sizeC];
        warning(error.message);
    end

    try
        %clear(meta.channelName);
        for j = 1:meta.sizeC
                tmp = char(omeMeta.getChannelName(0, j-1));
                channelName{j} = tmp;
        end
        meta.channelName = channelName;
    catch error
        for j = 1:meta.sizeC
            channelName{j} = 'unknown';
        end
        meta.channelName = channelName;
        warning(error.message);
    end

    try
        % lowercase and 'xy' are removed.
        meta.dimsOrder = lower( char(omeMeta.getPixelsDimensionOrder(0).getValue()) );
        meta.dimsOrder = regexp(meta.dimsOrder,'[^xy]+','match','ignorecase');
        meta.dimsOrder = meta.dimsOrder{1};
    catch error
        meta.dimsOrder = 'unknown';
%        warning(error.message);
    end
    
end

