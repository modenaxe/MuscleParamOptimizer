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
%    Author:   Luca Modenese, August 2014                                 %
%    email:    l.modenese@sheffield.ac.uk                                 % 
% ----------------------------------------------------------------------- %
%
% Script to evaluate the results of the optimized muscle scaling.
% The script calculates metrics on the variation of the muscle parameters
% with respect to the reference model.


function Results_MusVarMetrics = assessMuscleParamVar(  Template_osimModel,...
                                                        Optimized_osimModel,...
                                                        N_eval)
% importing OpenSim libraries
import org.opensim.modeling.*

% results file identifier
res_file_id_exp = ['_N',num2str(N_eval)];

% results file name
res_mat_file_name = ['Results_MusVarMetrics',res_file_id_exp];

% Extracting muscle sets from the two models
Muscles_ref         = Template_osimModel.getMuscles();
Muscles_opt         = Optimized_osimModel.getMuscles();

if exist([res_mat_file_name,'.mat'], 'file')==2
    pref = input([res_mat_file_name, ' exists. Do you want to re-evaluate muscle param % variations? [y/n].'], 's');
    switch pref
        case 'n'
            display('Loading existing file.')
            load([res_mat_file_name,'.mat']);
            return
        case 'y'
            display('Re-evaluating muscle percentage variations.');
    end
end
    
    for n_mus = 0:Muscles_ref.getSize()-1
        
        % current muscle name
        curr_mus_name = Muscles_ref.get(n_mus).getName;
        display(['Processing ',char(curr_mus_name)])
        
        % Extracting the current muscle from the two models
        currentMuscle_templ = Muscles_ref.get(curr_mus_name);
        currentMuscle_optim = Muscles_opt.get(curr_mus_name);
        
        % Normalized fiber lengths for the template
        Lopt_var = 100*(currentMuscle_optim.getOptimalFiberLength - currentMuscle_templ.getOptimalFiberLength)/currentMuscle_templ.getOptimalFiberLength;
        Lts_var  = 100*(currentMuscle_optim.getTendonSlackLength  - currentMuscle_templ.getTendonSlackLength) /currentMuscle_templ.getTendonSlackLength;
        
        % structure of results
        Results_MusVarMetrics.colheaders{n_mus+1}     = char(currentMuscle_templ.getName);
        Results_MusVarMetrics.Lopt_templ(n_mus+1)     = currentMuscle_templ.getOptimalFiberLength;
        Results_MusVarMetrics.Lopt_opt(n_mus+1)       = currentMuscle_optim.getOptimalFiberLength;
        Results_MusVarMetrics.Lts_templ(n_mus+1)      = currentMuscle_templ.getTendonSlackLength;
        Results_MusVarMetrics.Lts_opt(n_mus+1)        = currentMuscle_optim.getTendonSlackLength;
        Results_MusVarMetrics.Lopt_var(n_mus+1)       = Lopt_var;
        Results_MusVarMetrics.Lts_var(n_mus+1)        = Lts_var;
    end
   
    % Extracting max and min variations for Lopt     
    [Lopt_var_max, Ind_max]                     = max(Results_MusVarMetrics.Lopt_var);
    [Lopt_var_min, Ind_min]                     = min(Results_MusVarMetrics.Lopt_var);
    Results_MusVarMetrics.Lopt_var_range(1)     = Lopt_var_min;
    Results_MusVarMetrics.Lopt_var_range(2)     = Lopt_var_max;
    Results_MusVarMetrics.Lopt_var_range_mus    = {Results_MusVarMetrics.colheaders{Ind_min}, Results_MusVarMetrics.colheaders{Ind_max}};   
    
    % Extracting max and min variations for Lts     
    [Lts_var_max, Ind_max]                     = max(Results_MusVarMetrics.Lts_var);
    [Lts_var_min, Ind_min]                     = min(Results_MusVarMetrics.Lts_var);
    Results_MusVarMetrics.Lts_var_range(1)     = Lts_var_min;
    Results_MusVarMetrics.Lts_var_range(2)     = Lts_var_max;
    Results_MusVarMetrics.Lts_var_range_mus    = {Results_MusVarMetrics.colheaders{Ind_min}, Results_MusVarMetrics.colheaders{Ind_max}};   
    
    % save structures with results
    save(res_mat_file_name,'Results_MusVarMetrics');

end
