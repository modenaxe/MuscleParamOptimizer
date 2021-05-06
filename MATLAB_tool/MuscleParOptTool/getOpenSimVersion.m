%-------------------------------------------------------------------------%
%    Copyright (c) 2021 Modenese L.                                       %
%    Author:   Luca Modenese,  2021                                       %
%    email:    l.modenese@imperial.ac.uk                                  %
% ----------------------------------------------------------------------- %
% This script returns the OpenSim version for which the environmental
% variable OPENSIM_HOME has been set.
% ----------------------------------------------------------------------- %
function [osim_version_float, osim_version_string] = getOpenSimVersion()

% read env variable
osimpath = getenv('OPENSIM_HOME');

% let's assume it's the latest version in case there is no path variable
if isempty(osimpath)
    osim_version_float = 4.1;
    osim_version_string = '4.1';
    return
end

% get the file separators, e.g. '\' in 'C:\Program files\OpenSim 4.1'
sep_set = strfind(osimpath, filesep);

% use the last file separator to get the OpenSim installation folder name
version = osimpath(sep_set(end)+1:end);

% get the string for the opensim version
osim_version_string = strtrim(strrep(lower(version),'opensim', ''));

% transform in float
osim_version_float = str2num(osim_version_string);

end