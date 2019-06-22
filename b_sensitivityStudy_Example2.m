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
% Script optimizing muscle parameters for the Example 2 described in 
% Modenese L, Ceseracciu E, Reggiani M, Lloyd DG (2015). "Estimation of 
% musculotendon parameters for scaled and subject specific musculoskeletal 
% models using an optimization technique" Journal of Biomechanics (submitted)
% The script performes a sensitivity study from which the Figures of the
% papers are then produced. 
% The script: 
% 1) optimizes muscle parameters varying the number of points used in the
%    optimization from 5 to 15 per degree of freedom. Optimized models and
%    optimization log are saved in the folder "Example2>OptimModels"
% 2) evaluates the results of the optimization in terms of muscle
%   parameters variation and muscle mapping metrics (and saves structures
%   summarizing the results in the folder "Example2>Results"

clear;clc;close all
% importing OpenSim libraries
import org.opensim.modeling.*
% importing muscle optimizer's functions
addpath(genpath('./Functions_MusOptTool'))


%========= USERS SETTINGS =======
% select case to simulate: 1 or 2
example_nr = 2;
% evaluations
N_eval_set = 5:15;
%================================


%=========== INITIALIZING FOLDERS AND FILES =============
% getting example details
[case_id, osimModel_ref_file, osimModel_targ_file] = getExampleInfo(example_nr);
% folders used by the script
refModel_folder         = ['./',case_id,'/MSK_Models'];
targModel_folder        = refModel_folder;
OptimizedModel_folder   = ['./',case_id,'/OptimModels'];% folder for storing optimized model
Results_folder          = ['./',case_id,'/Results'];
log_folder              = OptimizedModel_folder;
checkFolder(OptimizedModel_folder);% creates results folder is not existing
checkFolder(Results_folder);
% model files with paths
osimModel_ref_filepath   = fullfile(refModel_folder,osimModel_ref_file);
osimModel_targ_filepath  = fullfile(targModel_folder,osimModel_targ_file);

% reference model for calculating results metrics
osimModel_ref = Model(osimModel_ref_filepath);


for N_eval = N_eval_set;
    
    %====== MUSCLE OPTIMIZER ========
    % optimizing target model based on reference model fro N_eval points per
    % degree of freedom
    [osimModel_opt, SimsInfo{N_eval}] = optimMuscleParams(osimModel_ref_filepath, osimModel_targ_filepath, N_eval, log_folder);
    
    %====== PRINTING OPT MODEL =======
    % setting the output folder
    if strcmp(OptimizedModel_folder,'') || isempty(OptimizedModel_folder)
        OptimizedModel_folder = targModel_folder;
    end
    % printing the optimized model
    osimModel_opt.print(fullfile(OptimizedModel_folder, char(osimModel_opt.getName())));
    
    %====== SAVING RESULTS ===========
    % variation in muscle parameters
    Results_MusVarMetrics = assessMuscleParamVar(osimModel_ref, osimModel_opt, N_eval);
    % assess muscle mapping in terms of RMSE, max error
    % RMSE, errors etc evaluated at n_Metrics points between reference and
    % optimized model
    n_Metrics = 10;
    Results_MusMapMetrics = assessMuscleMapping(osimModel_ref,  osimModel_opt,N_eval, n_Metrics);
    % move results mat file to result folder
    movefile('./*.mat',Results_folder)
end

% save simulations infos
save([Results_folder,'./SimsInfo'],'SimsInfo');

% removing functions from path 
rmpath(genpath('./Functions_MusOptTool'));
    