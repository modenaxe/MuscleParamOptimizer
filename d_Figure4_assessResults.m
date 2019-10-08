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
% This script reads the results of the sensitivity study of both examples
% and generates Figure 4 -mapping results -. 
% The figure is store in folder "Figure 4".

clear; clc; close all

% importing muscle optimizer's functions
addpath(genpath('./Functions_MusOptTool'))

%========= USERS SETTINGS =======
% evaluations per dof
N_eval = 10;
% folder where the figure will be saved
% NB: a log file is saved with the figure
Fig_folder = './Figure 4';
% angles of rotation for muscle names
rot_angle = -90;
%================================


% check if figure folder exists
checkFolder(Fig_folder);

% subplot index
plot_incr =0;

% creating figure of nice proportions
figure('Position',[1 41 1366  652])

% clean log file
fid = fopen([Fig_folder,'./Results_summary.txt'],'w');
fclose all;
% set diary
diary([Fig_folder,'./Results_summary.txt'])

for n_example = 1:2
%====== EXAMPLES DETAILS ======== 
% choosing folders and models for the desired example.
switch n_example
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
        osimModel_ref_file = 'Reference_Arnold_Rv2.osim';
        % target model and its folder
        osimModel_targ_file = 'Target_GenericFemale_WCB_Schuttev2.osim';
    otherwise
        error('Please choose an example between 1 and 2.');
end

%=========== INITIALIZING FOLDERS AND FILES =============
% folders used by the script
refModel_folder         = ['./',case_id,'/MSK_Models'];
targModel_folder        = refModel_folder;
OptimizedModel_folder   = ['./',case_id,'/OptimModels'];% folder for storing optimized model
Results_folder          = ['./',case_id,'/Results'];

% results file identified
res_file_id_exp = ['_N',num2str(N_eval)];

% load the results for the selected number of sampling points
try
    load(fullfile(Results_folder,['Results_MusVarMetrics',res_file_id_exp]));
    load(fullfile(Results_folder,['Results_MusMapMetrics',res_file_id_exp,'_NError10']));
catch err
    display(err.message);
end

% % %===== PLOT OF RMSE AND MEAN TRACKING ERROR FOR EACH CASE SEPARATLY =======
% % % plotting the RMSE and mean tracking errors (for descriptions in the
% % % paper)
% % figure('Position',[437 339 1140 600]);
% % plotMusMappingMetrics(Results_MusMapMetrics);
% % gcf, subplot(2,1,1); 
% % title(['Example ',num2str(n_example)],'FontWeight','bold','FontName','Arial','FontSize',12);
% % %==========================================================================

% preparing muscle names
n_mus = size(Results_MusMapMetrics.colheaders,2);
musNames = strrep(Results_MusMapMetrics.colheaders,'_',' ');
for r = 1:n_mus;
    musNames{r} = [' ',musNames{r}(1:end-2)];
end

%=============== PLOTTING FIGURE ==================
% first row subplots: RMSE error for the two examples
h1 = subplot(2,2,1+plot_incr);
bar(Results_MusMapMetrics.RMSE,'DisplayName','RMSE','FaceColor',[1,1,1],'EdgeColor',[0 0 0]);
% adapt x ticks for better visibility
xlim([0 n_mus+1])
% include muscle names...
set(gca,'xTick', (1:n_mus)+0.15,'xTickLabel', musNames,'TickLength',[0 0])%,'FontName','arial','FontSize',12)
%..and rotate them
rotateXLabels( h1, rot_angle)
% finalize with y label and title
ylabel('RMSE','FontWeight','bold','FontName','Arial','FontSize',12); 
title({['Example',num2str(n_example)];' '},'FontWeight','bold','FontName','Arial','FontSize',14); 

% second row presents mean tracking error and SD as error bar
h2 = subplot(2,2,3+plot_incr);
% bar plus error
bar(Results_MusMapMetrics.MeanPercError,'DisplayName','Mean error [%]','FaceColor',[1,1,1],'EdgeColor',[0 0 0]);hold on
errorbar(1:n_mus,  Results_MusMapMetrics.MeanPercError,...
    Results_MusMapMetrics.StandDevPercError,'k.', 'MarkerSize',0.1);

% setting up x axis and labels as above
xlim([0 n_mus+1])
set(gca,'xTick', (1:n_mus)+0.15,'xTickLabel', musNames,'TickLength',[0 0]);%,'FontName','arial','FontSize',6)
rotateXLabels( h2, rot_angle)
% finalize with y label
ylabel('Mean error [%]','FontWeight','bold','FontName','Arial','FontSize',12); 
% adjusting size
if n_example == 1
    ylim([0 4]);
else
    ylim([0 40]);
end

% update plot increm
plot_incr = plot_incr+1;

%==================== OTHER RESULTS (PRINTED AT SCREEN) ==================
% save log
diary('on')
% display results
display('=====================================')
display(['MUSCLE PARAM VARIATIONS (EXAMPLE ',num2str(n_example),')'])
display('=====================================')
display(['Lopt variation [%] :  MIN:',num2str(Results_MusVarMetrics.Lopt_var_range(1)), '  (',Results_MusVarMetrics.Lopt_var_range_mus{1},')']);
display(['                      MAX:',num2str(Results_MusVarMetrics.Lopt_var_range(2)), '  (',Results_MusVarMetrics.Lopt_var_range_mus{2},')']);
display(['Lts variation [%]  :  MIN:',num2str(Results_MusVarMetrics.Lts_var_range(1)), '  (',Results_MusVarMetrics.Lts_var_range_mus{1},')']);
display(['                      MAX:',num2str(Results_MusVarMetrics.Lts_var_range(2)), '  (',Results_MusVarMetrics.Lts_var_range_mus{2},')']);

% results in terms of muscle parameters variations
display('=====================================')
display(['MUSCLE MAPPING METRICS (EXAMPLE ',num2str(n_example),')'])
display('=====================================')
display(['Range of RMSE       :  MIN:',num2str(Results_MusMapMetrics.RMSE_range(1)), '  (',Results_MusMapMetrics.RMSE_range_mus{1},')']);
display(['                       MAX:',num2str(Results_MusMapMetrics.RMSE_range(2)), '  (',Results_MusMapMetrics.RMSE_range_mus{2},')']);
display(['Range of MeanErr [%]:  MIN:',num2str(Results_MusMapMetrics.MeanPercError_range(1)), '  (',Results_MusMapMetrics.MeanPercError_range_mus{1},')']);
display(['                       MAX:',num2str(Results_MusMapMetrics.MeanPercError_range(2)), '  (',Results_MusMapMetrics.MeanPercError_range_mus{2},')']);
display(['Range of MaxErr [%] :  MIN:',num2str(Results_MusMapMetrics.MaxPercError_range(1)), '  (',Results_MusMapMetrics.MaxPercError_range_mus{1},')']);
display(['                       MAX:',num2str(Results_MusMapMetrics.MaxPercError_range(2)), '  (',Results_MusMapMetrics.MaxPercError_range_mus{2},')']);
display(['Range of corr coeff :  MIN:',num2str(Results_MusMapMetrics.rho_pval_range(1,1))])
display(['                       MAX:',num2str(Results_MusMapMetrics.rho_pval_range(1,3))]);
display(['Range of p val      :  MIN:',num2str(Results_MusMapMetrics.rho_pval_range(1,2))]);
display(['                       MAX:',num2str(Results_MusMapMetrics.rho_pval_range(1,4))]);
diary('off')
end

%============ PRINT FIGURES ============
set(gcf, 'PaperPositionMode','auto')     
saveas(gcf,fullfile(Fig_folder,'Fig4_TrackingResults.fig'))
saveas(gcf,fullfile(Fig_folder,'Fig4_TrackingResults.eps'))
saveas(gcf,fullfile(Fig_folder,'Fig4_TrackingResults.png'))
display( '===============================')
display(['Figure 4 printed in ', Fig_folder]);
display( '===============================')
% close all

% removing functions
rmpath(genpath('./Functions_MusOptTool'));
