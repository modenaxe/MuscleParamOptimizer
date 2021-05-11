%-------------------------------------------------------------------------%
%    Copyright (c) 2021 Modenese L.                                       %
%    Author:   Luca Modenese,  2021                                       %
%    email:    l.modenese@imperial.ac.uk                                  %
% ----------------------------------------------------------------------- %
% This script returns the OpenSim version
% ----------------------------------------------------------------------- %
function [osim_version_float, osim_version_string] = getOpenSimVersion()

import org.opensim.modeling.*

% read env variable
try
    % method available only from 4.x
    os_version = char(opensimCommonJNI.GetVersion());
    
    % get the field separators, e.g. '-
    sep_set = strfind(os_version, '-');
    
    % use the last file separator to get the OpenSim installation folder name
    version = os_version(1:sep_set(1));
    
    % get the string for the opensim version
    osim_version_string = strtrim(strrep(lower(version),'opensim', ''));
    
    % transform in float
    osim_version_float = str2double(osim_version_string);
    
catch
    
    % GetVersion is not available in earlier OpenSim versions
    osim_version_float = 3.3;
    osim_version_string = '3.3';
    return
end
end