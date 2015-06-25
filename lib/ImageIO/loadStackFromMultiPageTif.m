function [ img, meta ] = loadStackFromMultiPageTif( imagePath, inputFormat, indexChannel, seriesId )

    startTime = tic;
    [meta, omeMeta] = getOmeMeta(imagePath);
    fprintf('Time duration: read metadata = %i\n', toc(startTime));

    % DETERMINE THE DIMENSIONSORDER
    splitOrder = meta.dimsOrder;
    splitDims = [];
    for j = 1:length(splitOrder)
        str = char(splitOrder(j));
        switch str
            case 'c',
                splitDims = [splitDims, meta.sizeC];
            case 't',
                splitDims = [splitDims, meta.sizeT];
            case 'z',
                splitDims = [splitDims, meta.sizeZ];
            otherwise,
        end
    end

    startTime = tic;
    if ( exist('seriesId', 'var') )
        image = readImage( imagePath, inputFormat, 'Bioformats', seriesId);
    else
        image = readImage( imagePath, inputFormat, 'Bioformats' );
    end
    fprintf('Time duration: read input image = %i\n', toc(startTime));
    nSlices = size(image,3);

    % CHECK THE DIMENSIONSORDER
    if ( isempty( regexp(splitOrder,'[ctz]+','match') ) )
        warning('Split:undefinedSplitOrder',...
            'The splitOrder parameter is not correctly defined in the options\n options.splitOrder is: %s\n The default splitOrder will be used: %s',...
            splitOrder, defaultSplitOrder());
        splitOrder = defaultSplitOrder();
    end
    %
    n = splitDims;
    if (prod(n) == nSlices & ( length(splitOrder) == length(splitDims) ) )
    else
        warning('Split:undefinedSplitDims',...
            'The splitDims parameter is not correctly defined in the options\n options.splitDims. The default splitDims will be used.');
        splitDims = ones(1,length(splitOrder));
        splitDims(end) = nSlices;
        n = splitDims;
    end

    % USE THE DIMENSIONSORDER TO FIND THE CORRECT INDICES OF C, T, AND Z
    c = 1;
    t = 1;
    z = 1;
    ind = repmat([c, t, z], nSlices, 1);
    for d = 1:length(splitDims)
        l = strfind('ctz', splitOrder(d));
        if (~isempty(l))
            for m = 1:nSlices
                ind(m,l) = mod( ceil(double(m) / prod(splitDims(1:(d-1)))), splitDims(d) );
                if (ind(m,l) == 0)
                    ind(m,l) = splitDims(d);
                end
            end
        end
    end

    % DETERMINE THE FILENAMES OUTPUTIMGLIST
    img = newim(meta.sizeX, meta.sizeY, meta.sizeZ);
    k = 0;
    for m = 1:nSlices
        ci = ind(m,1); ti = ind(m,2); zi = ind(m,3);
        if ( ci == indexChannel )
            img( :, :, zi-1 ) = image( :, :, m );
            k = k + 1;
        end
    end

end

