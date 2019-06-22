%-------------------------------------------------------------------------%
% Copyright (c) 2015 Modenese L., Ceseracciu, E., Reggiani M., Lloyd, D.G.%
%                                                                         %
% Licensed under the Apache License, Version 2.0 (the "License");         %
% you may not use this file except in compliance with the License.        %
% You may obtain a copy of the License at                                 %
% http://www.apache.org/licenses/LICENSE-2.0.                             %
%                                                                         % 
% Unless required by applicable law or agreed to in writing, software     %
% distributed under the License is distributed on an "AS IS" BASIS,       %
% WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or         %
% implied. See the License for the specific language governing            %
% permissions and limitations under the License.                          %
%                                                                         %
%    Author:  Luca Modenese, August 2014                                  %
%                           revised for paper May 2015                    %
%    email:    l.modenese@sheffield.ac.uk                                 % 
% ----------------------------------------------------------------------- %
%
% This function returns the details and the relative path of the models to
% be used in the two examples considered in the manuscript.
function [case_id, osimModel_ref_file, osimModel_targ_file] = getExampleInfo(example_nr) 

% choosing folders and models for the desired example.
switch example_nr
    case 1  
        %========= EXAMPLE 1 =============
        % string case identifier
        case_id = 'Example1';
        % reference model and its folder
        osimModel_ref_file = 'Reference_Hamner_L.osim';
        % target model and its folder
        osimModel_targ_file = 'Target_Hamner_scaled_L.osim';
    case 2
        %=========== SUBJECT SPECIFIC MODEL =============
        % string case identifier
        case_id = 'Example2';
        % reference model and its folder
        osimModel_ref_file = 'Reference_Arnold_R.osim';
        % target model and its folder
        osimModel_targ_file = 'Target_LHDL_Schutte_R.osim';
    otherwise
        error('Please choose an example between 1 and 2.');
end

end