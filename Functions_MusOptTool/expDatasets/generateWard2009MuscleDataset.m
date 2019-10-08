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
%    Author:   Luca Modenese, March 2015                                  %
%    email:    l.modenese@sheffield.ac.uk                                 % 
% ----------------------------------------------------------------------- %
%
% function implementing the dataset published by Ward et al. (2009)
% Ward, S., Eng, C., Smallwood, L. and Lieber, R., 2009. 
% Clin Orthop Rel Res 467, 1074-1082.
function Ward2009MuscleDataset = generateWard2009MuscleDataset

% NB: 'per_tert_r'; 'tfl_r'; are missing

Ward2009MuscleDataset.rowheaders = {'n_mus',...%nr of samples
                                    'Mass',... %(g;
                                    'Mass_SD',... %(g;
                                    'Lm',...   %Muscle length (cm;
                                    'Lm_SD',...   %Muscle length (cm;
                                    'Lf',... %'Fiber length (cm;'
                                    'Lf_SD',... %'Fiber length (cm;'
                                    'Lf_var_coeff',... %Lf coefficient of variation (%;
                                    'Lf_var_coeff_SD',...
                                    'Ls',... %Ls (?m;
                                    'Ls_SD',...
                                    'penAngle',... %Pennation angle (°;
                                    'penAngle_SD',...
                                    'PCSA',... %PCSA (cm2;
                                    'PCSA_SD',...
                                    'Lf/Lm',...
                                    'Lf/Lm_SD'}; %Lf/Lm ratio
Ward2009MuscleDataset.colheaders = {
 'psoas',...
 'iliacus',...
 'glut_max',...
 'glut_med',...
 'sar',...
 'rect_fem',...
 'vas_lat',...
 'vas_int',...
 'vas_med',...
 'grac',...
 'add_long',...
     'add_brev',...
     'add_mag',...
     'bifemlh',...
     'bifemsh',...
     'semiten',...
     'semimem',...
     'tib_ant',...
     'ext_hal',...
     'ext_dig',...
     'per_long',...
     'per_brev',...
     'med_gas',...
     'lat_gas',...
     'soleus',...
     'flex_hal',...
     'flex_dig',...
     'tib_post'};
 
     'per_tert_r';
     'tfl_r';
 % psoas
Ward2009MuscleDataset.data(:,1) = [ 19;
                                    97.7 ; 33.6;
                                    24.25 ; 4.75;
                                    11.69 ; 1.66;
                                    12.4 ; 5.9;
                                    3.11 ; 0.28;
                                    10.6 ; 3.2;
                                    7.7 ; 2.3;
                                    0.50 ; 0.14];
%iliacus
Ward2009MuscleDataset.data(:,size(Ward2009MuscleDataset.data,2)+1) = [
21;
113.7 ; 37.0;
20.61 ; 4.02;
10.66 ; 1.86;
23.0 ; 9.4;
3.02 ; 0.18;
14.3 ; 5.3;
9.9 ; 3.4;
0.56 ; 0.26];

% glut max
Ward2009MuscleDataset.data(:,size(Ward2009MuscleDataset.data,2)+1) = [18;
547.2 ; 162.2;
26.95 ; 6.42;
15.69 ; 2.57;
15.5 ; 11.0;
2.60 ; 0.36;
21.9 ; 26.2;
33.4 ; 8.8;
0.62 ; 0.22];

%Gluteus medius  
Ward2009MuscleDataset.data(:,size(Ward2009MuscleDataset.data,2)+1) = [16;
273.5 ; 76.9;
19.99 ; 2.86;
7.33 ; 1.57;
20.3 ; 11.8;
2.40 ; 0.18;
20.5 ; 17.3;
33.8 ; 14.4;
0.37 ; 0.08];

%Sartorius  
Ward2009MuscleDataset.data(:,size(Ward2009MuscleDataset.data,2)+1) = [20;
78.5 ; 31.1;
44.81 ; 4.19;
40.30 ; 4.63;
6.4 ; 4.2;
3.11 ; 0.19;
1.3 ; 1.8;
1.9 ; 0.7;
0.90 ; 0.04];

% Rectus femoris  
Ward2009MuscleDataset.data(:,size(Ward2009MuscleDataset.data,2)+1) = [21;
110.6 ; 43.3;
36.28 ; 4.73;
7.59 ; 1.28;
9.7 ; 4.6;
2.42 ; 0.30;
13.9 ; 3.5;
13.5 ; 5.0;
0.21 ; 0.03];

% Vastus lateralis  
Ward2009MuscleDataset.data(:,size(Ward2009MuscleDataset.data,2)+1) = [19;
375.9 ; 137.2;
27.34 ; 4.62;
9.94 ; 1.76;
9.1 ; 6.1;
2.14 ; 0.29;
18.4 ; 6.8;
35.1 ; 16.1;
0.38 ; 0.11];

%Vastus intermedius  
Ward2009MuscleDataset.data(:,size(Ward2009MuscleDataset.data,2)+1) = [20;
171.9 ; 72.9;
41.20 ; 8.17;
9.93 ; 2.03;
10.4 ; 6.3;
2.17 ; 0.42;
4.5 ; 4.5;
16.7 ; 6.9;
0.24 ; 0.04];

% Vastus medialis  
Ward2009MuscleDataset.data(:,size(Ward2009MuscleDataset.data,2)+1) = [19;
239.4 ; 94.8;
43.90 ; 9.85;
9.68 ; 2.30;
10.7 ; 5.7;
2.24 ; 0.46;
29.6 ; 6.9;
20.6 ; 7.2;
0.22 ; 0.04];

% Gracilis  
Ward2009MuscleDataset.data(:,size(Ward2009MuscleDataset.data,2)+1) = [19;
52.5 ; 16.7;
28.69 ; 3.29;
22.78 ; 4.38;
15.9 ; 8.2;
3.24 ; 0.21;
8.2 ; 2.5;
2.2 ; 0.8;
0.79 ; 0.08];

% Adductor longus  
Ward2009MuscleDataset.data(:,size(Ward2009MuscleDataset.data,2)+1) = [20;
74.7 ; 28.4;
21.84 ; 4.46;
10.82 ; 2.02;
11.8 ; 6.2;
3.00 ; 0.37;
7.1 ; 3.4;
6.5 ; 2.2;
0.50 ; 0.07];

% Adductor brevis
Ward2009MuscleDataset.data(:,size(Ward2009MuscleDataset.data,2)+1) = [19;
54.6 ; 24.8;
15.39 ; 2.46;
10.31 ; 1.42;
16.8 ; 7.3;
2.91 ; 0.25;
6.1 ; 3.1;
5.0 ; 2.1;
0.68 ; 0.06];

% Adductor magnus  
Ward2009MuscleDataset.data(:,size(Ward2009MuscleDataset.data,2)+1) = [17;
324.7 ; 127.8;
37.90 ; 7.36;
14.44 ; 2.74;
29.1 ; 8.3;
2.19 ; 0.32;
15.5 ; 7.3;
20.5 ; 7.8;
0.39 ; 0.07];

% Biceps femoris long head  
Ward2009MuscleDataset.data(:,size(Ward2009MuscleDataset.data,2)+1) = [18;
113.4 ; 48.5;
34.73 ; 3.65;
9.76 ; 2.62;
12.8 ; 9.5;
2.35 ; 0.28;
11.6 ; 5.5;
11.3 ; 4.8;
0.28 ; 0.08];

% Biceps femoris short head  
Ward2009MuscleDataset.data(:,size(Ward2009MuscleDataset.data,2)+1) = [19;
59.8 ; 22.6;
22.39 ; 2.50;
11.03 ; 2.06;
9.5 ; 5.2;
3.31 ; 0.17;
12.3 ; 3.6;
5.1 ; 1.7;
0.49 ; 0.07];

% Semitendinosus  
Ward2009MuscleDataset.data(:,size(Ward2009MuscleDataset.data,2)+1) = [19;
99.7 ; 37.8;
29.67 ; 3.86;
19.30 ; 4.12;
29.4 ; 14.0;
2.89 ; 0.28;
12.9 ; 4.9;
4.8 ; 2.0;
0.65 ; 0.11];

% Semimembranosus  
Ward2009MuscleDataset.data(:,size(Ward2009MuscleDataset.data,2)+1) = [19;
134.3 ; 57.6;
29.34 ; 3.42;
6.90 ; 1.83;
13.7 ; 7.5;
2.61 ; 0.25;
15.1 ; 3.4;
18.4 ; 7.5;
0.24 ; 0.06];

% Tibialis anterior  
Ward2009MuscleDataset.data(:,size(Ward2009MuscleDataset.data,2)+1) = [21;
80.1 ; 26.6;
25.98 ; 3.25;
6.83 ; 0.79;
6.6 ; 4.0;
3.14 ; 0.16;
9.6 ; 3.1;
10.9 ; 3.0;
0.27 ; 0.05];

% Extensor hallucis longus  
Ward2009MuscleDataset.data(:,size(Ward2009MuscleDataset.data,2)+1) = [21;
20.9 ; 9.9;
24.25 ; 3.27;
7.48 ; 1.13;
7.7 ; 5.7;
3.24 ; 0.11;
9.4 ; 2.2;
2.7 ; 1.5;
0.31 ; 0.06];

% Extensor digitorum longus  
Ward2009MuscleDataset.data(:,size(Ward2009MuscleDataset.data,2)+1) = [21;
41.0 ; 12.6;
29.00 ; 2.33;
6.93 ; 1.14;
8.0 ; 4.4;
3.12 ; 0.20;
10.8 ; 2.8;
5.6 ; 1.7;
0.24 ; 0.04];

% Peroneus longus  
Ward2009MuscleDataset.data(:,size(Ward2009MuscleDataset.data,2)+1) = [19;
57.7 ; 22.6;
27.08 ; 3.02;
5.08 ; 0.63;
10.4 ; 6.5;
2.72 ; 0.25;
14.1 ; 5.1;
10.4 ; 3.8;
0.19 ; 0.03];

% Peroneus brevis  
Ward2009MuscleDataset.data(:,size(Ward2009MuscleDataset.data,2)+1) = [20;
24.2 ; 10.6;
23.75 ; 3.11;
4.54 ; 0.65;
10.1 ; 6.0;
2.76 ; 0.19;
11.5 ; 3.0;
4.9 ; 2.0;
0.19 ; 0.03];

% Gastrocnemius medial head  
Ward2009MuscleDataset.data(:,size(Ward2009MuscleDataset.data,2)+1) = [20;
113.5 ; 32.0;
26.94 ; 4.65;
5.10 ; 0.98;
13.4 ; 7.0;
2.59 ; 0.26;
9.9 ; 4.4;
21.1 ; 5.7;
0.19 ; 0.03];

% Gastrocnemius lateral head  
Ward2009MuscleDataset.data(:,size(Ward2009MuscleDataset.data,2)+1) = [20;
62.2 ; 24.6;
22.35 ; 3.70;
5.88 ; 0.95;
15.8 ; 11.2;
2.71 ; 0.24;
12.0 ; 3.1;
9.7 ; 3.3;
0.27 ; 0.03];

% Soleus  
Ward2009MuscleDataset.data(:,size(Ward2009MuscleDataset.data,2)+1) = [19;
275.8 ; 98.5;
40.54 ; 8.32;
4.40 ; 0.99;
16.7 ; 6.9;
2.12 ; 0.24;
28.3 ; 10.1;
51.8 ; 14.9;
0.11 ; 0.02];

% Flexor hallucis longus  
Ward2009MuscleDataset.data(:,size(Ward2009MuscleDataset.data,2)+1) = [19;
38.9 ; 17.1;
26.88 ; 3.55;
5.27 ; 1.29;
9.7 ; 5.7;
2.37 ; 0.24;
16.9 ; 4.6;
6.9 ; 2.7;
0.20 ; 0.05];

% Flexor digitorum longus  
Ward2009MuscleDataset.data(:,size(Ward2009MuscleDataset.data,2)+1) = [19;
20.3 ; 10.8;
27.33 ; 5.62;
4.46 ; 1.06;
9.6 ; 5.0;
2.56 ; 0.25;
13.6 ; 4.7;
4.4 ; 2.0;
0.16 ; 0.09];

% Tibialis posterior  
Ward2009MuscleDataset.data(:,size(Ward2009MuscleDataset.data,2)+1) = [20;
58.4 ; 19.2;
31.03 ; 4.68;
3.78 ; 0.49;
9.1 ; 5.6;
2.56 ; 0.32;
13.7 ; 4.1;
14.4 ; 4.9;
0.12 ; 0.02];
