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
%    Author:   Luca Modenese, May 2015                                    %
%    email:    l.modenese@sheffield.ac.uk                                 % 
% ----------------------------------------------------------------------- %
%
% This script reads the results of the sensitivity study of both examples
% and generates Figure 3 - convergence profiles -. 
% The figure is store in folder "Figure 3".

clear;clc; close all
% adds functions to load the datasets (removed at the end of the scritpt)
addpath(genpath('./Functions_MusOptTool'))

%============================== SETTINGS ==================================
% points considered in the sensitivity
n_eval_point_set = 5:1:15;
% folder where the figure will be saved
Fig_folder = './Figure 3';
%==========================================================================



%======== EXTRACTING RESULTS =========
% nr of sensitivity checks
N_sensit_checks = length(n_eval_point_set);

% creating figure with nice proportion
figure('Position', [ 131 114 1761 684]);

% indeces to update the subplots
n_plot_add = 0;

% looping through the examples
for n_ex = 1:2
    
    % updating results folder
    results_folder          = ['./Example',num2str(n_ex),'/Results'];
    
    % index of n evaluation (one run of the tool in the sensitivity)
    n_eval_ind = 1;
    
    % looping throught the evaluation points n
    for n_eval = n_eval_point_set
        
        % loading the muscle map assessment file
        load(fullfile(results_folder,['Results_MusMapMetrics_N',num2str(n_eval),'_NError10.mat']));
        % creating a structure that summarise sensitivity results
        SensitMusMapResults.RMSE(:,n_eval_ind) = Results_MusMapMetrics.RMSE;
        
        % loading muscle parameters from optimized models
        load(fullfile(results_folder,['Results_MusVarMetrics_N',num2str(n_eval),'.mat']));
        % creating a structure that summarise muscle parameters sensitivity results
        SensitMusVarResults.Lopt_opt(:,n_eval_ind) = Results_MusVarMetrics.Lopt_opt;
        SensitMusVarResults.Lts_opt(:,n_eval_ind) = Results_MusVarMetrics.Lts_opt;
        
        % update index
        n_eval_ind = n_eval_ind+1;
    end
    
    % calculating variations from previous evaluation in the sensitivity
    % analysis
    var_perc_Lopt = abs(diff(SensitMusVarResults.Lopt_opt, 1, 2));
    var_perc_Lts = abs(diff(SensitMusVarResults.Lts_opt, 1, 2));
    var_perc_RMSE = abs(diff(SensitMusMapResults.RMSE, 1, 2));
    
    for n = 1:size(var_perc_Lopt, 2)
        % percentage variation with respect to previous evaluation
        % calculate like: perc_var = 100*[Lopt(n+1)-Lopt(n)/Lopt(n)]
        perc_var_Lopt(:,n) = 100*var_perc_Lopt(:,n)./SensitMusVarResults.Lopt_opt(:,n); %#ok<*SAGROW>
        perc_var_Lts(:,n) = 100*var_perc_Lts(:,n)./SensitMusVarResults.Lts_opt(:,n);
        perc_var_RMSE(:,n) = 100*var_perc_RMSE(:,n)./SensitMusMapResults.RMSE(:,n);
    end
    
    %============== GENERATING THE FIGURE =================
    for n = 1:size(perc_var_Lopt,1)
        % plotting Lopt
        subplot(2,3,1+n_plot_add)
        Lopt_values_at_current_Neval = perc_var_Lopt(n, 1:end);
        plot(n_eval_point_set(2:end), Lopt_values_at_current_Neval,'k'); hold on
        xlim([6 15])
        
        % plotting Lts
        subplot(2,3,2+n_plot_add)
        Lts_values_at_current_Neval = perc_var_Lts(n, 1:end);
        plot(n_eval_point_set(2:end), Lts_values_at_current_Neval,'k'); hold on
        xlim([6 15])
        
        % plotting RMSE
        subplot(2,3,3+n_plot_add)
        RMSE_values_at_current_Neval = perc_var_RMSE(n, 1:end);
        plot(n_eval_point_set(2:end), RMSE_values_at_current_Neval,'k'); hold on
        xlim([6 15])
        ylim([0 5])
    end
    
    clear SensitMusMapResults SensitMusVarResults perc_var_Lopt perc_var_Lts perc_var_RMSE
    
    % updating plots for second row
    n_plot_add = n_plot_add + 3;
end

%============ FINALIZING SUBPLOTS ============
subplot(2,3,1)
title('Optimal fiber length','FontWeight','bold','FontName','Arial','FontSize',12);
ylabel({'Example 1';'';'Variation from previous iteration [%]';''},'FontWeight','bold','FontName','Arial','FontSize',12);
ylim([0 1])

subplot(2,3,2)
title('Tendon slack length','FontWeight','bold','FontName','Arial','FontSize',12);
ylim([0 0.2])

subplot(2,3,3)
title('RMSE','FontWeight','bold','FontName','Arial','FontSize',12);
ylim([0 7])

subplot(2,3,4)
ylabel({'Example 2';'';'Variation from previous iteration [%]';''},'FontWeight','bold','FontName','Arial','FontSize',12);
xlabel('Evaluation points per dof','FontWeight','bold','FontName','Arial','FontSize',12);
ylim([0 4])

subplot(2,3,5)
xlabel('Evaluation points per dof','FontWeight','bold','FontName','Arial','FontSize',12);
ylim([0 7])

subplot(2,3,6)
xlabel('Evaluation points per dof','FontWeight','bold','FontName','Arial','FontSize',12);
ylim([0 5])


% Create textarrow
annotation(gcf,'textarrow',[0.204391891891892 0.185810810810811],...
    [0.773696707105719 0.736568457538995],'TextEdgeColor','none',...
    'String',{'semimbranosus'});

% Create textarrow
annotation(gcf,'textarrow',[0.509290540540541 0.495777027027027],...
    [0.361218370883882 0.325823223570191],'TextEdgeColor','none',...
    'String',{'gluteus max 2'});


% % Create textarrow
% annotation(gcf,'textarrow',[0.809199318568995 0.796138557637706],...
%     [0.206602339181287 0.179824561403509],'TextEdgeColor','none',...
%     'String',{'semimbranosus'});

% Create textarrow
annotation(gcf,'textarrow',[0.8125 0.759290540540541],...
    [0.302292894280763 0.275563258232236],'TextEdgeColor','none',...
    'String',{' psoas'});

% Create arrow
annotation(gcf,'arrow',[0.83702441794435 0.896081771720613],...
    [0.298707602339181 0.273391812865497]);

%============ PRINT FIGURES ============
% checking on the figure folder
checkFolder(Fig_folder)
% printing figure
set(gcf, 'PaperPositionMode','auto')     
saveas(gcf,fullfile(Fig_folder,'Fig3_convergence_profile.fig'))
saveas(gcf,fullfile(Fig_folder,'Fig3_convergence_profile.eps'))
saveas(gcf,fullfile(Fig_folder,'Fig3_convergence_profile.png'))
display( '===============================')
display(['Figure 3 printed in ', Fig_folder]);
display( '===============================')
% close all

% remove functions from path
addpath(genpath('./Functions_MusOptTool'))