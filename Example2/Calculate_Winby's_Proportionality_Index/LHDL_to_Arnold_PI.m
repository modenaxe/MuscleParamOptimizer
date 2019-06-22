%-------------------------------------------------------------------------%
% Copyright (c) 2015 Griffith University and the Author(s)                %
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
%    email:    l.modenese@griffith.edu.au                                 % 
% ----------------------------------------------------------------------- %
%
% Script to calculate proportionality index of scaling that would scale
% Delp's model to LHDL model (only pelvis and femur, as only hip is
% modeled)
clear;clc; close all

% dimensions of 2392 (Assuming they are the same as Arnold)
D_pelvis_dim1 = 238; %Pelvic width
D_pelvis_dim2 = 147; %Pelvic depth
D_thigh_length = 404; % estimated from epicondyles virtual markers
D_shank_length = 399.5;% estimated from malleoli virtual markers as norm([0.0005 -0.3994 0.0075])

% dimensions of LHDL (measured in NMSBuilder)
L_pelvis_dim1 = 242; %Pelvic width
L_pelvis_dim2 = 143; %Pelvic depth
L_thigh_length = 397.03;
L_shank_length = 373.58;

% calculating scaling factor
pelvis_scaling_fact = L_pelvis_dim1/D_pelvis_dim1;
% pelvis_scaling_fact2 = L_pelvis_dim2/D_pelvis_dim2;
thigh_scaling_fact = L_thigh_length/D_thigh_length;
shank_scaling_fact = L_shank_length/D_shank_length;

% muscles just crossing the hip
BA(1) = abs(pelvis_scaling_fact-thigh_scaling_fact);
% muscles crossing hip and knee
BA(2) = abs(pelvis_scaling_fact-thigh_scaling_fact)+...
        abs(thigh_scaling_fact-shank_scaling_fact);
% calculating Proportionality Index (PI) as the mean
PI = mean(BA);

% display
display(['Proportionality Index is: ',num2str(PI)])