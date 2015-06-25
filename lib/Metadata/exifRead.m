% READ THE METADATA WITH EXIFTOOL.EXE EXIV2.EXE
%
% tagID = 'ImageDescription';
% needs the json library to return the data as json
function data = exifRead(imagePath, exiftool)

%    exiftool = 'exiftool.exe';
%	% exiftool = 'exiv2.exe';
    exiftoolPath = which(exiftool);
    if isempty(exiftoolPath)
        warning('MetadataRead:ExifToolNotFound', ...
            'ExifTool "%s", not found.', exiftool);
	end
	if (strcmp( exiftool, 'exiftool.exe' ) )
		tagID = 'ImageDescription';
		line = [ exiftoolPath ' -' tagID ' "' imagePath '"'];
	elseif (strcmp( exiftool, 'exiv2.exe' ) )
		tagID = 'Xmp.tiff.ImageDescription';
		line = [ exiftoolPath ' -g ' tagID ' pr "' imagePath '"']
	end
    % Use exiv2 instead of exiftool? (speed issues) NO (exiv2 has an error)
    [~,tagValue] = system( line );
    tagValue = regexprep(tagValue,'\\n','\n');
    tagValueStartIndex = regexp(tagValue,'{','once');
    tagValue = tagValue(tagValueStartIndex:end);
    data = loadjson(tagValue);

end 
