%-------------------------------------------------------------------------%
% Copyright (c) 2019 Modenese L., Ceseracciu, E., Reggiani M., Lloyd, D.G.%
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
%    Author: Luca Modenese, August 2014                                   %
%                            revised January 2016                         %
%    email:    l.modenese@imperial.ac.uk                                  % 
% ----------------------------------------------------------------------- %
%
% Script that implements an example of use of optimization of the 
% musculotendon parameters using the MATLAB tool make available in this
% repository.
% ----------------------------------------------------------------------- %
clear;clc;close all

% importing OpenSim libraries
import org.opensim.modeling.*

%========= USERS SETTINGS =======
% REFERENCE MODEL
% Muscle dynamics from Arnold model will be mapped onto the target model.
osimModel_ref_filepath   = '.\Example_case\Input_Models\Reference_Arnold_R.osim';

% TARGET MODEL
% Target model is a model built from scratch using dataveric data.
osimModel_targ_filepath  = '.\Example_case\Input_Models\Target_LHDL_Schutte_R.osim';

% nr of evaluations per coordinate
N_eval = 10;

% Folder where to store the optimized model and a log
optimizedModel_folder = '.\Example_case\Optimized_Models';
%================================

% adding tool function to MATLAB path
addpath('./MuscleParOptTool');

% initializing folders and log file
log_folder              = optimizedModel_folder;

% checking if Results folder exists. If not, create it.
if ~isdir(optimizedModel_folder)
    warning(['Folder ', optimizedModel_folder, ' does not exist. It will be created.'])
    mkdir(optimizedModel_folder);
end

% optimizing target based on reference model for N_eval points per coord.
[osimModel_opt, SimsInfo{N_eval}] = optimMuscleParams(osimModel_ref_filepath, osimModel_targ_filepath, N_eval, log_folder);

% printing the optimized model
osimModel_opt.print(fullfile(optimizedModel_folder, char(osimModel_opt.getName())));

% removing functions from path
rmpath('./MuscleParOptTool');