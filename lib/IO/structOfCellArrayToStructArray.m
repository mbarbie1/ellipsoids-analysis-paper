function as = structOfCellArrayToStructArray( sa )

    tmp = sa;
    fn = fieldnames(tmp);
    for ifn = 1:length(fn)
        for iEl = 1:nEl
            el = sa.(fn{ifn});
            if iscell(el)
                as(iEl).(fn{ifn}) = el{iEl};
            else if isnumeric(el)
                    as(iEl).(fn{ifn}) = el(iEl);
                end
            end
        end
    end

end

