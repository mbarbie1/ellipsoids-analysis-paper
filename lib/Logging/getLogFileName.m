% -----------------------------------------------------------------------
% 
% FUNCTION: getLogFileName.m
% 
% DESCRIPTION: Returns a fileName (string) for your logFile which contains
%               the date and the function or script name calling this
%               function. If an explicit "prefix" is provided, this is used
%               instead of the function name.
% 
% INPUT: 
%           Can take also 0 arguments
%           prefix                      : prefix of the filename for the
%                                           logfile (string)
%
% OUTPUT:
%           logFile                     : the filename (string)
%
% AUTHOR: 
% 
% 	Michaël Barbier
%   mbarbie1@its.jnj.com
% 
% ----------------------------------------------------------------------- 
%
function logFile = getLogFileName(prefix)

    dateFormat = '_yyyy_mm_dd_HH_MM_SS';
    if (nargin < 1)
        st = dbstack;
        prefix = st(2).name;
    end
    logFile = [prefix datestr(now, dateFormat) '.log'];

end
