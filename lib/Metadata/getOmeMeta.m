% The metaInput argument is optional: if no metadata is given then the
% default metadata from "defaultMeta()" is used.
function [meta, omeMeta] = getOmeMeta(imgPath, metaInput)

    switch nargin
        case 2,
            meta = metaInput;
        otherwise,
            meta = defaultMeta();
    end

    disp(imgPath)
    try 
        reader = bfGetReader(imgPath);
        omeMeta = reader.getMetadataStore();
        
        meta = getMetaFromOmeMeta(omeMeta);
    
        catch error
        omeMeta = [];
        warning(error.message);
    end

    
end

