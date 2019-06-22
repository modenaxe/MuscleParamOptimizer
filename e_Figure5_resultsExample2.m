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
%    Author:   Luca Modenese, September 2014                              %
%    email:    l.modenese@sheffield.ac.uk                                 % 
% ----------------------------------------------------------------------- %
%
% This script reads the results of the Example 2 and generates 
% Figure 5, comparing the estimated muscle parameters for the subject
% specific model to experimental measurements reported from Ward et al.
% 2009 and performed in the LHDL specimen.
% The figure is store in folder "Figure 5".

clear;clc; close all
% importing OpenSim libraries
import org.opensim.modeling.*
% adds functions to load the datasets (removed at the end of the scritpt)
addpath(genpath('./Functions_MusOptTool'))


%============================== SETTINGS ==================================
% Location of Arnold's model
osimArnold = Model('./Example2/MSK_Models/Reference_Arnold_R.osim');
% folder where the figure will be saved
Fig_folder = './Figure 5';
% specify the number of evaluations used in the results to be compared with
% experimental data
N_eval = 10;
% inclination of muscle names in the figure
orientation_labels = -90;
%==========================================================================



%========= INITIALIZING AND IMPORTING NECESSARY DATA ==============
% loading the results for that specified n of evaluation points 
load(['./Example2/Results/Results_MusVarMetrics_N',num2str(N_eval),'.mat'])

% importing Ward dataset
Ward2009MuscleDataset = generateWard2009MuscleDataset;

% importing LHDL measurements
LHDL = generateLHDL_dataset;

% importing muscle sets
muscles_ref = osimArnold.getMuscles;

% extracting muscle names
muscle_names = Results_MusVarMetrics.colheaders;

for n_mus = 0:length(muscle_names)-1
    
    % curr muscle name
    curr_mus_name = muscle_names{n_mus+1};    
    
    % curr muscle 
    curr_mus = muscles_ref.get(curr_mus_name);
    
    % get rid of _r, _l
    if strcmp(curr_mus_name(end-1:end),'_r') || strcmp(curr_mus_name(end-1:end),'_l')
        curr_mus_name = curr_mus_name(1:end-2);
    end
    
    % maintaining number of fiber
    if strcmp(curr_mus_name(end),'1') || strcmp(curr_mus_name(end),'2') || strcmp(curr_mus_name(end),'3')
        curr_mus_name = curr_mus_name(1:end-1);
    end
    
    % searching index for current mus in Ward's dataset
    curr_mus_col_ind = strcmp(curr_mus_name, Ward2009MuscleDataset.colheaders);
    
    % checking if the current muscle was measured by Ward. 
    % Setting value to NaN if it is not found.
    if max(curr_mus_col_ind)==0
        display(['Not measured by Ward:   ',curr_mus_name,]);
        Lopt_Ward2009(n_mus+1) = NaN;
        Lopt_SD_Ward2009(n_mus+1) = NaN;
    elseif max(curr_mus_col_ind)==1
        curr_mus_data = Ward2009MuscleDataset.data(:,curr_mus_col_ind);
        % storing measuremens of Lopt and standard deviation
        Lopt_Ward2009(n_mus+1) = curr_mus_data(6,1);
        Lopt_SD_Ward2009(n_mus+1) = curr_mus_data(7,1);        
    end
    
    % checking if the current muscle was measured in the LHDL specimen. 
    % Setting value to NaN if the tendon was not measured.
    curr_mus_col_ind_LHDL = strcmp(curr_mus_name, LHDL.colheaders);
    if max(curr_mus_col_ind_LHDL)==0
        display(['Not measured in LHDL:   ',curr_mus_name,]);
        Lt_LHDL(1,n_mus+1) = [NaN];
        Lt_LHDL(2,n_mus+1) = [NaN];
    elseif max(curr_mus_col_ind_LHDL)==1
        % storing measuremens of Lten (range)
        Lt_LHDL(1,n_mus+1) = LHDL.Lt(1,curr_mus_col_ind_LHDL);
        Lt_LHDL(2,n_mus+1) = LHDL.Lt(2,curr_mus_col_ind_LHDL);
    end
    
    % get fiber lengths from the reference model (just a check, not used)
    Lopt_ref(n_mus+1) = curr_mus.getOptimalFiberLength;
end

% extracting the muscle parameters from the results of the optimization
Lopt_opt_vect = Results_MusVarMetrics.Lopt_opt;
Lts_opt_vect  = Results_MusVarMetrics.Lts_opt;

% importing values from 
Lopt_templ_vec = Results_MusVarMetrics.Lopt_templ;
Lts_templ_vec  = Results_MusVarMetrics.Lts_templ;
% A final check that we are dealing with correct data
% this should be the template/reference results -> pure double check
if max(Lopt_templ_vec-Lopt_ref)~=0; 
    warndlg('Stored template Lopt values and values from loaded template model seem different. Please double check!!');
end


%=================== GENERATING THE FIGURE ====================

% creating figure of nice proportions
figure('Position',[ 123   147   918   672])

%=========== GENERATING FIRST SUBPLOT (WARD AND ARNOLD) ======= 
h1 =subplot(2,2,1:2);

% plotting Ward dataset (black) [cm]
errorbar(1:n_mus+1, Lopt_Ward2009,  2*Lopt_SD_Ward2009,  'sk', 'MarkerFaceColor','k','MarkerEdgeColor',[0 0 0],'MarkerSize',10), hold on

% plotting Arnold muscle data [cm]
plot(1:n_mus+1,     Lopt_ref*100, 'vw', 'MarkerFaceColor','w','MarkerEdgeColor',[0 0 0],'MarkerSize',8)  , hold on
xlim([0, length(muscle_names)+1])

% plotting subject specific results [cm]
plot(1:n_mus+1,Lopt_opt_vect*100,'ow', 'MarkerFaceColor','w','MarkerEdgeColor',[0 0 0])  , hold on
% highlighting results not consistent with Ward et al (2009)(outside 2SD range) 
ind_outliers = Lopt_opt_vect*100>(Lopt_Ward2009+2*Lopt_SD_Ward2009) | (Lopt_opt_vect*100<Lopt_Ward2009-2*Lopt_SD_Ward2009);
plot(find(ind_outliers), Lopt_opt_vect(ind_outliers)*100,'*r', 'MarkerSize',8,'MarkerFaceColor','r','MarkerEdgeColor',[0 0 0])

% y label
ylabel('Optimal Fiber Length [cm]')

% adding legend
hleg1 = legend ('Ward et al. (2009)', 'Arnold et al. (2009)', 'Subject specific model', 'Not compatible with Ward et al. (2009)');
set(hleg1,'Location','NorthWest');

%=========== GENERATING SECOND SUBPLOT (LHDL) ======= 
% PLOTTING TENDON RESULTS FOR CHOSEN SETUP AGAINST ARNOLD AND LHDL
% MEASUREMENTS
h2 = subplot(2,2,3:4);

% plotting subject specific optimized results
plot(1:n_mus+1,Lts_opt_vect*100,'ow', 'MarkerFaceColor','w','MarkerEdgeColor',[0 0 0]) ; hold on

% plot LHDL tendon measurements just as ranges (no sense having a mean
% value)
errb = errorbar(1:n_mus+1,  Lt_LHDL(1,:)/10, 0*Lt_LHDL(1,:)/10, (Lt_LHDL(2,:)-Lt_LHDL(1,:))/10,'k.', 'MarkerSize',0.1);

% plotting
plot(1:n_mus+1,Lts_templ_vec*100,'vw', 'MarkerFaceColor','w','MarkerEdgeColor',[0 0 0])
xlim([0, length(muscle_names)+1])
ylabel('Tendon Slack Length [cm]')

% adjusting muscle names for muscles to be plotted (different set from
% previous adjustment)
for n_mus = 1:length(muscle_names)
    Results_MusVarMetrics.colheaders{n_mus} = [' ',Results_MusVarMetrics.colheaders{n_mus}(1:end-1)];
end
Results_MusVarMetrics.colheaders = strrep(Results_MusVarMetrics.colheaders,'_',' ');

% set names on first subplot (Lopt)
set(h1,'xTick', 1:n_mus,'xTickLabel', Results_MusVarMetrics.colheaders,'TickLength',[0 0]);%,'FontName','arial','FontSize',12
rotateXLabels( h1, orientation_labels)

% set names on second subplot (Lts)
set(h2,'xTick', 1:n_mus,'xTickLabel', Results_MusVarMetrics.colheaders,'TickLength',[0 0]);%,'FontName','arial','FontSize',12
rotateXLabels( gca, orientation_labels)

% finalizing plot
set(h1,'YGrid','on')
set(h2,'YGrid','on')

% =========== PRINTING THE FIGURE ====================
% check existence of the Fig folder
checkFolder(Fig_folder);
% print figures
set(gcf, 'PaperPositionMode','auto')     %# WYSIWYG
saveas(gcf,fullfile(Fig_folder,'Fig5_Example2Res.fig'))
saveas(gcf,fullfile(Fig_folder,'Fig5_Example2Res.eps'))
saveas(gcf,fullfile(Fig_folder,'Fig5_Example2Res.png'))
% close all
display( '===============================')
display(['Figure 5 printed in ', Fig_folder]);
display( '===============================')
% remove used functions
rmpath(genpath('./Functions_MusOptTool'))