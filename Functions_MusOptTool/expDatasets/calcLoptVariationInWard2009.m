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
% Script to calculate the variation as SD/mean value of the optimal fiber
% lengths measured by Ward, S., Eng, C., Smallwood, L. and Lieber, R., 2009. 
% Clin Orthop Rel Res 467, 1074-1082.
clear;clc

% generate 
Ward2009MuscleDataset = generateWard2009MuscleDataset;

% standard deviation as % of mean
variationPerc = (Ward2009MuscleDataset.data(7,:)./Ward2009MuscleDataset.data(6,:))*100;

% minimum
[minVar,musMinVarInd] = min(variationPerc);
display([Ward2009MuscleDataset.colheaders{musMinVarInd},' has minimum variation: ', num2str(minVar)] );

% maximum
[maxVar,musMaxVarInd] = max(variationPerc);
display([Ward2009MuscleDataset.colheaders{musMaxVarInd},' has maximum variation: ', num2str(maxVar)] );