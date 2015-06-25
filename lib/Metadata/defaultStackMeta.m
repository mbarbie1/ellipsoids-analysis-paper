function meta = defaultStackMeta()

	meta.MBASE = defaultMBASE();

	meta.id = num2str( randi(99999,1) );

	meta.Data.Type = 'Stack';
	meta.Data.Original = true; % 
	meta.Data.linkToOriginal = '';
	meta.Data.linkToThisFile = '';
    
	meta.Pixels = defaultMeta();
	meta.Channels = struct;

	meta.Files = {};

end
