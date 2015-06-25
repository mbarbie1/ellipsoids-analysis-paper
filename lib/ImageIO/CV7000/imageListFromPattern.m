function fileList = imageListFromPattern( imageDir, pattern )

    files = dir( fullfile(imageDir, pattern) );
    fileList = fullfile(imageDir, {files.name});
    fileList = sort(fileList);

end

