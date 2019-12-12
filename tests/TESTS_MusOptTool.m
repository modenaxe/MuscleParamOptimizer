%% TEST1: map a model on itself
% check that generally the algorithm optimizes models as expected.
% If asked to map a model on the same model, the optimization should
% converge on the initial values of the target model.
clear; 
% add opensim API
import org.opensim.modeling.*
% add tools
addpath('../MATLAB_tool/MuscleParOptTool')

% setup the optimization
reference_model = './models/gait2392_simbody.osim';
target_model    = reference_model;
N_eval = 5;
log_folder = './test1_logs';

% optimize
[osimModel_opt, SimsInfo] = optimMuscleParams(reference_model, target_model, N_eval, log_folder);

% test
assert(min(max(SimsInfo.LmOptLts_opt-SimsInfo.LmOptLts_ref)<1.0e-14));

%% TEST2: reproduce parameter optimization from MATLAB example
clear; 
% add opensim API
import org.opensim.modeling.*
% add tools
addpath('../MATLAB_tool/MuscleParOptTool')

% setup the optimization
reference_model = './models/test2_reference.osim';
target_model    = './models/test2_target.osim';
N_eval = 10;
log_folder = './test2_logs';

% optimize
[osimModel_opt, SimsInfo] = optimMuscleParams(reference_model, target_model, N_eval, log_folder);

% test
expected_model  = './models/test2_expected.osim';
osimExp = Model(expected_model);
% load muscles
exp_mus = osimExp.getMuscles();
opt_mus = osimModel_opt.getMuscles();
% define a loss
loss = 0;
% compare musculotendon properties between optimized and expected 
for n = 0:opt_mus.getSize()-1
    cur_opt_mus = opt_mus.get(n);
    cur_exp_mus = exp_mus.get(n);
    dL = abs(cur_opt_mus.getOptimalFiberLength()- cur_exp_mus.getOptimalFiberLength());
    dT = abs(cur_opt_mus.getTendonSlackLength()- cur_exp_mus.getTendonSlackLength());
    loss = loss+dL+dT;
end

%test
assert(loss<1.0e-14);