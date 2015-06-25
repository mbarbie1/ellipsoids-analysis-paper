% CONSTRUCT METADATA
function MetaData = getMetadataStruct( stackFileList, imagePath, indexFile, indexZ, indexT, indexC, metaStack, oriMetaURL )

    % METADATA
    %
%     Stack.SavedAsStack = false;
%     Stack.URL = '';
%     Stack.ImageFiles = stackFileList;
%     Stack.Channels(1).wavelength = '';
%     Stack.Channels(1).label = '';
%     Stack.Channels(1).wavelength = '';
%     Stack.Channels = {};
%     Stack.Channels = {};
%     Stack.Channels = {};
%     Stack.Pixels.SizeX = 100;
%     Stack.Pixels.SizeY = 100;
%     Stack.Pixels.SizeZ = 12;
%     Stack.Pixels.SizeC = 4;
%     Stack.Pixels.SizeT = 1;
%     Stack.Pixels.SizeT = 1;
%     Stack.Pixels.Unit = 'um';
%     Stack.Pixels.PhysicalPixelSizeX = 0.5;
%     Stack.Pixels.PhysicalPixelSizeY = 0.5;
%     Stack.Pixels.PhysicalPixelSizeZ = 2;
%     Stack.Pixels.TimeIncrement = 0;
    %
    Stack = metaStack;
    Stack.ImageFiles = stackFileList;
    %
    Image.File.Index = indexFile;
    Image.File.Path = imagePath;
    [Image.File.Dir, Image.File.Name, Image.File.Extension] = fileparts(imagePath);
    %
    Image.Pixels.indexC = indexC;
    Image.Pixels.indexT = indexT;
    Image.Pixels.indexZ = indexZ;
%
    Original.URL = oriMetaURL;

    MetaData.Original = Original;
    MetaData.Stack = Stack;
    MetaData.Image = Image;

end