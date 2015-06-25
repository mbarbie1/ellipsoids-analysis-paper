% This function reads an image from a multipage image file of certain format, bitdepth,
% using Bioformats (bfmatlab library should be loaded)
function [image, meta] = readImageStack( imagePath, iC, iT, iSeries)

    reader = bfGetReader(imagePath);
    omeMeta = reader.getMetadataStore();
    meta = getMetaFromOmeMeta(omeMeta);

    % From the Bioformats bfmatlab tutorial:
        % To switch between series in a multi-image file, use the setSeries() method. 
        % To retrieve a plane given a set of (z, c, t) coordinates, these coordinates must be linearized first using getIndex()
        % Read plane from series iSeries at Z, C, T coordinates (iZ, iC, iT)
        % All indices are expected to be 1-based
    if (isempty(iSeries))
            iSeries = 1;
    end
    try
        reader.setSeries(iSeries - 1);
    catch
        warning('method reader.setSeries failed');
    end
    image = newim(meta.sizeX,meta.sizeY,meta.sizeZ,meta.bitDepth);
    for iZ = 1:meta.sizeZ
        iPlane = reader.getIndex(iZ - 1, iC -1, iT - 1) + 1;
        image(:,:,iZ-1) = bfGetPlane(reader, iPlane);
    end
end
