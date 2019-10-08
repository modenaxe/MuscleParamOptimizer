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
%    Author:   Luca Modenese, July 2014                                   %
%                           revised May 2015 (v2)                         %
%    email:    l.modenese@sheffield.ac.uk                                 % 
% ----------------------------------------------------------------------- %
%
% Script to evaluate the results of the muscle optimization.
% The script calculated the normalized fiber lengths for the model template
% and for the scaled model with optimized muscle parameters at N_error
% points and computes an RMSE (assuming that the optimization is aiming 
% to "track" the normalized FL curve of the muscles) in the reference model
% and the mean and maximum error in the tracking (ranges across muscles).
% N_eval identifies the optimized model, obtained by sampling each
% degree of freedom's range in N_Eval points.
%

function Results_MusMapMetrics = assessMuscleMapping(osimModel_ref,...
                                                        osimModel_opt,...
                                                        N_eval,...
                                                        N_error)


% importing OpenSim libraries
import org.opensim.modeling.*

% Extracting muscle sets from the two models
muscles_ref     = osimModel_ref.getMuscles();
muscles_opt     = osimModel_opt.getMuscles();

% %initializing the models
% initialState        = Template_osimModel.initSystem();
% initialState_Opt    = Opt_osimModel.initSystem();

%=============== FILE WHERE TO STORE THE METRICS ================
% results file identifier
res_file_id_exp = ['_N',num2str(N_eval)];
% name of the result file
res_mat_file_name = ['Results_MusMapMetrics',res_file_id_exp,'_NError',num2str(N_error)];

% if the file exists it will ask if to re-calculate or just load the file
if exist([res_mat_file_name,'.mat'], 'file')==2
    % ask the user
    pref = input([res_mat_file_name, ' exists. Do you want to re-evaluate? [y/n].'], 's');
    switch pref
        case 'n'
            display('Loading existing file.')
            load([res_mat_file_name,'.mat']);
            return
        case 'y'
            display('Re-evaluating mapping results');
    end
end

for n_mus = 0:muscles_ref.getSize()-1
    
    % current muscle name
    curr_mus_name = muscles_ref.get(n_mus).getName;
    display(['Processing ',char(curr_mus_name)])
    
    % Extracting the current muscle from the two models
    curr_muscle_ref = muscles_ref.get(curr_mus_name);
    curr_muscle_opt   = muscles_opt.get(curr_mus_name);
    
    %======= NORMALIZED FIBER LENGTHS CALCULATED AT N_Error POINTS ======== 
    % Normalized fiber lengths from the reference model at N_Error points
    % per dof
    Lm_Norm_ref = sampleMuscleQuantities(osimModel_ref,curr_muscle_ref,'LfibNorm', N_error);
    % Normalized fiber lengths from the optimized model at N_Error points
    % per dof
    Lm_Norm_opt = sampleMuscleQuantities(osimModel_opt,curr_muscle_opt,'LfibNorm', N_error);
    
    %========= CHECK FOR NaN ==============
    % checks on NaN on the results
    if isnan(Lm_Norm_ref)
        warndlg(['NaN detected for muscle ',char(curr_mus_name),' in the template model.']);
    end
    if isnan(Lm_Norm_opt)
        warndlg(['NaN detected for muscle ',char(curr_mus_name),' in optimized model.']);
    end
    
    %========= CHECK FOR UNREALISTIC FIBER LENGTHS ==============
    % Check on the results of the sampling: if the reference model sampling gave some
    % unrealistic fiber lengths, this is where this should be corrected
    % boundaries for normalized fiber lengths
    
    %======= FIBER LENGTHS THAT MAKE PENNATION ANGLE >= 90 deg =========
    % calculating minimum fiber length before having pennation 90 deg
    % acos(0.1) = 1.47 red = 84 degrees, chosen as in OpenSim
    limitPenAngle = acos(0.1);
    % this is the minimum length the fiber can be for geometrical reasons.
    PenAngleOpt = curr_muscle_ref.getPennationAngleAtOptimalFiberLength();
    LfibNorm_min_templ = sin(PenAngleOpt)/sin(limitPenAngle);
    
    %======= NORMALIZED FIBER LENGTHS < 0.5 =========
    % LfibNorm as calculated above can be shorter than the minimum length
    % at which the fiber can generate force (taken to be 0.5 Zajac 1989)
    if (LfibNorm_min_templ<0.5)==1
        LfibNorm_min_templ = 0.5;
    end
    % indices of points that are ok according to previous criteria
    ok_point_ind = find(Lm_Norm_ref>LfibNorm_min_templ);
    % checking the muscle configuration that do not respect the condition.
    Lm_Norm_ref = Lm_Norm_ref(ok_point_ind);
    % checking the muscle configuration that do not respect the condition.
    Lm_Norm_opt = Lm_Norm_opt(ok_point_ind);
    
    %======= NULL NORMALIZED FIBER LENGTHS ===========
    % Muscle normalized length cannot be zero either
    if min(Lm_Norm_ref)==0
        menu(['Zero Lnorm for muscle ',char(curr_mus_name),' in template model. Removing points with zero lengths.'],'OK');
        ok_points = (Lm_Norm_ref~=0);
        Lm_Norm_ref = Lm_Norm_ref(ok_points);
        Lm_Norm_opt = Lm_Norm_opt(ok_points);
    end
    
    %============== CALCULATING THE METRICS ================
    % difference between the two normalized fiber length vectors evaluated
    % at N_error
    Diff_Lfnorm = Lm_Norm_ref-Lm_Norm_opt;
    
    % structure of results
    Results_MusMapMetrics.colheaders{n_mus+1}       = char(curr_muscle_ref.getName);
    Results_MusMapMetrics.RMSE(n_mus+1)             = sqrt(sum(Diff_Lfnorm.^2.0)/length(Lm_Norm_ref));
    Results_MusMapMetrics.MaxPercError(n_mus+1)     = max(abs(Diff_Lfnorm)./Lm_Norm_ref)*100;
    Results_MusMapMetrics.MinPercError(n_mus+1)     = min(abs(Diff_Lfnorm)./Lm_Norm_ref)*100;
    Results_MusMapMetrics.MeanPercError(n_mus+1)    = mean(abs(Diff_Lfnorm)./Lm_Norm_ref,2)*100;
    Results_MusMapMetrics.StandDevPercError(n_mus+1)= std(abs(Diff_Lfnorm)./Lm_Norm_ref,0,2)*100;
    [rho,P_val]                                     = corr(Lm_Norm_ref', Lm_Norm_opt');
    Results_MusMapMetrics.corrCoeff(n_mus+1,1:2)    = [rho,P_val];
    
    % clearing variables to avoid issue for different sampling
    clear  Lm_Norm_opt Lm_Norm_ref
end


% Computing min and max RMSE
[RMSE_max, Ind_max]                     = max(Results_MusMapMetrics.RMSE);
[RMSE_min, Ind_min]                     = min(Results_MusMapMetrics.RMSE);
Results_MusMapMetrics.RMSE_range(1)     = RMSE_min;
Results_MusMapMetrics.RMSE_range(2)     = RMSE_max;
Results_MusMapMetrics.RMSE_range_mus    = {Results_MusMapMetrics.colheaders{Ind_min}, Results_MusMapMetrics.colheaders{Ind_max}};

% Computing min and max MeanPercError
[MeanPercError_max, Ind_max]                     = max(Results_MusMapMetrics.MeanPercError);
[MeanPercError_min, Ind_min]                     = min(Results_MusMapMetrics.MeanPercError);
Results_MusMapMetrics.MeanPercError_range(1)     = MeanPercError_min;
Results_MusMapMetrics.MeanPercError_range(2)     = MeanPercError_max;
Results_MusMapMetrics.MeanPercError_range_mus    = {Results_MusMapMetrics.colheaders{Ind_min}, Results_MusMapMetrics.colheaders{Ind_max}};

% Computing max and min variations for MaxPercError
[MaxPercError_max, Ind_max]                     = max(Results_MusMapMetrics.MaxPercError);
[MaxPercError_min, Ind_min]                     = min(Results_MusMapMetrics.MaxPercError);
Results_MusMapMetrics.MaxPercError_range(1)     = MaxPercError_min;
Results_MusMapMetrics.MaxPercError_range(2)     = MaxPercError_max;
Results_MusMapMetrics.MaxPercError_range_mus    = {Results_MusMapMetrics.colheaders{Ind_min}, Results_MusMapMetrics.colheaders{Ind_max}};

% Extracting max and min corr coeff and p values
Results_MusMapMetrics.rho_pval_range = [min(Results_MusMapMetrics.corrCoeff),max(Results_MusMapMetrics.corrCoeff)];

% save structures with results
save(res_mat_file_name,'Results_MusMapMetrics');

end


