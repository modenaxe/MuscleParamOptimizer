%__________________________________________________________________________
% Author: Luca Modenese, June 2013
% email: l.modenese@griffith.edu.au
%
% DO NOT REDISTRIBUTE WITHOUT PERMISSION
%__________________________________________________________________________
%
% Implementation of the method PresMusOper3 described in Winby et al, JB 41
% (2008).
% A template generic model including "good" operative range of the muscle
% actuators is used to adjust the operative range of the same actuators in
% a scaled model by modifying the optimal fiber length and the tendon
% slack length. The aim of the method is to maintain the muscle working
% conditions in the FL curve.
% The original Wimby's method was implemented for the knee joint, this code
% extends the idea to all dofs of all the joints spanned by the muscle 
% actuator.
%
% TO DO: folders for input/output models.

clear;clc

%%%%%%%%%%%%% SET UP %%%%%%%%%%%%%%%%%%%%%%%%%%%%
% General model to use as template for mapping
% (Attempts to validate the function with different models)

% Arnolds model (limited ROM compared to gait2392)
% GeneralModelFile = 'Arnoldetal2009OneLeg_v2Schutte_TobeMapped.osim';

% gait2354 with reduced ROM (+1 deg -1 deg)at the hip and knee joint dofs
% GeneralModelFile = 'LegModel_reduced.osim';

% gait2354 with reduced ROM (+1 deg -1 deg)at the hip and knee joint dofs
% --->ONLY sagittal dofs<-----
GeneralModelFile = 'LegModel_reduced_sagittal.osim';

% Scaled model: it is just a copy of the Generic model
% TEST: map on the same model should give same muscle parameters.
ScaledModelFile = GeneralModelFile;

% Specify a log file
aLogFile = 'WinbyMapping.log';
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% importing OpenSim libraries
import org.opensim.modeling.*

% adds functions to the path
addpath('./Commons')

%cleaning the log file
fid = fopen(aLogFile,'w');
fclose(fid);

% Importing the models
osimModel = Model(GeneralModelFile);
osimModelScaled = Model(ScaledModelFile);

% Extracting muscle sets from the two models
Muscles = osimModel.getMuscles();
MusclesScaled =osimModelScaled.getMuscles();
muscle = Muscles.get(0);

% Updating the muscle parameters on the specified scaled model.
% FOR TESTING: first 8 muscles have mono and bi-articular muscles.
for n_mus = 0:2%Muscles.getSize()-1
    
    % Extracting the current muscle from the two models
    currentMuscle = Muscles.get(n_mus);
    currentMuscleScaled = MusclesScaled.get(n_mus);

    % optimizing muscle parameters using an extended version of Winby's method PresMusOper3
    [Lts_Winby, LmOpt_Winby] = OptimizeMuscleParams(osimModel,currentMuscle,osimModelScaled,currentMuscleScaled,aLogFile,2);
    
    % updating the muscle actuator
    currentMuscleScaled.setTendonSlackLength(Lts_Winby);
    currentMuscleScaled.setOptimalFiberLength(LmOpt_Winby);
end

% adding prefix to scaled model
[path, name, ext] = fileparts(ScaledModelFile);
% printing the optimized model
currentMuscleScaled.print([path, 'Optimized_',name, ext])
