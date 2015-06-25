% Dumps the Bioformats ome-xml data generated for 'imgPath' to the xml-file
% 'xmlFile'.
function writeOmeMeta(imgPath, xmlFile)

    reader = bfGetReader(imgPath);
    omeMeta = reader.getMetadataStore();
    
    omeXML = char(omeMeta.dumpXML());
    fid = fopen(xmlFile,'w+');
    fprintf(fid,'%s',omeXML);
    fclose(fid);

end
