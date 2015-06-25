function fctOps = optionsJSONToStruct(optionsString, defaultOptions)

	% the parameter optionsString can be either a file name either a string
	% containing json data
	fctOps = loadjson(optionsString);

	% Set the default values of the parameters to the one the user has
	% given.
	tags = fieldnames(defaultOptions);
	for i=1:length(tags)
		if (~isfield(fctOps,tags{i}))
			fctOps.(tags{i})=defaultOptions.(tags{i});
			disp(['Not a field', tags{i}]);
		end
	end
	if (length(tags)~=length(fieldnames(fctOps))), 
		warning('Algorithm:unknownoption','unknown input parameter found');
	end

end
