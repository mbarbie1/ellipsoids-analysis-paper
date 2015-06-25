% WRITE THE METADATA WITH EXIFTOOL.EXE
%
% tagID = 'ImageDescription';
function exifWrite(MetaData, imagePath, exiftool)

    % CONSTRUCT METADATA WITH JSON
    jsonData = savejson(MetaData);

    exiftoolPath = which(exiftool);
    if isempty(exiftoolPath)
        warning('MetadataWrite:ExifToolNotFound', ...
            'ExifTool "%s", not found.', exiftool);
    end
    tagValue = jsonData;
    tagValue = regexprep(tagValue,'\n','\\n');
    % Remove spaces since they get read as dots afterwards, less readable but
    % less overhead on the files.
    tagValue = regexprep(tagValue,'[\t\s]','');
    % The escaping code for Unix vs Windows cmd differs: see e.g.
    % http://docs.aws.amazon.com/cli/latest/userguide/cli-using-param.html#quoting-strings
    % http://blogs.msdn.com/b/twistylittlepassagesallalike/archive/2011/04/23/everyone-quotes-arguments-the-wrong-way.aspx
    tagValue = regexprep(tagValue,'"','\\"');
    % Use exiv2 instead of exiftool (speed issues)
	if (strcmp( exiftool, 'exiftool.exe' ) )
		tagID = 'ImageDescription';
		line = [ exiftoolPath ' -q -overwrite_original_in_place -' tagID '="' tagValue '" ' imagePath];
	elseif (strcmp( exiftool, 'exiv2.exe' ) )
        tagID = 'Xmp.tiff.ImageDescription';
	    line = [ exiftoolPath ' -M"set ' tagID ' ' tagValue '" ' imagePath];
	end    
    system( line );

end
