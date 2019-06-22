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
% The function generates a structure including the LHDL tendon lengths as 
% derived from the data available in PSLoader, exported in NMSBuilder and
% manually checked measuring fiber and tendon portion in NMSBuilder. 
%
% NaN has not been measured, 
% value = 0 is tendon zero
function LHDL = generateLHDL_dataset
% LHDL.colheaders = {'add_brev','add_long','add_mag',...
%     'bifemlh','gem','glut_max','glut_med','glut_min',...
%     'grac','iliacus','pect','piri','psoas','quad_fem',...
%     'rect_fem','sar','semimem','semiten','tfl'};

LHDL.colheaders(1) = {'add_brev'};
LHDL.Lt(1,1) = 0;
LHDL.Lt(2,1) = 0;

LHDL.colheaders(2) = {'add_long'};
LHDL.Lt(1,2) = min([61.37,59.75,35.43,72.01,74.65]);
LHDL.Lt(2,2) = max([61.37,59.75,35.43,72.01,74.65]);

LHDL.colheaders(3) = {'add_mag'};
LHDL.Lt(1,3) = min([11.91, 25.88,53.95,38.29, 148.7,62.84]);
LHDL.Lt(2,3) = max([11.91, 25.88,53.95,38.29, 148.7,62.84]);

LHDL.colheaders(4) = {'bifemlh'};
LHDL.Lt(1,4) = min([173.03,171.19,157.23]);
LHDL.Lt(2,4) = max([173.03,171.19,157.23]);

LHDL.colheaders(5) = {'gem'};
LHDL.Lt(1,5) = NaN;
LHDL.Lt(2,5) = NaN;

LHDL.colheaders(6) = {'glut_max'};
LHDL.Lt(1,6) = min([110.69,105.46,120.15]);
LHDL.Lt(2,6) = max([110.69,105.46,120.15]);

LHDL.colheaders(7) = {'glut_med'};
LHDL.Lt(1,7) = 0;
LHDL.Lt(2,7) = 0;

LHDL.colheaders(8) = {'glut_min'};
LHDL.Lt(1,8) = NaN;
LHDL.Lt(2,8) = NaN;

LHDL.colheaders(9) = {'grac'};
LHDL.Lt(1,9) = min([112.83, 106.45]);
LHDL.Lt(2,9) = max([112.83, 106.45]);

LHDL.colheaders(10) = {'iliacus'};
LHDL.Lt(1,10) = 0;
LHDL.Lt(2,10) = 0;

LHDL.colheaders(11) = {'pect'};
LHDL.Lt(1,11) = min([9.12,3.25,15.54]);
LHDL.Lt(2,11) = max([9.12,3.25,15.54]);

LHDL.colheaders(12) = {'piri'};
LHDL.Lt(1,12) = min([51.3,49.39,42.74]);
LHDL.Lt(2,12) = max([51.3,49.39,42.74]);

LHDL.colheaders(13) = {'psoas'};
LHDL.Lt(1,13) = min([134.35,124.86,115.53,103.49]);
LHDL.Lt(2,13) = max([134.35,124.86,115.53,103.49]);

LHDL.colheaders(14) = {'quad_fem'};
LHDL.Lt(1,14) = NaN;
LHDL.Lt(2,14) = NaN;

LHDL.colheaders(15) = {'rect_fem'};
LHDL.Lt(1,15) = min([183.13,184.87,186.66,190.04]);
LHDL.Lt(2,15) = max([183.13,184.87,186.66,190.04]);

LHDL.colheaders(16) = {'sar'};
LHDL.Lt(1,16) = min([78.88,68.08]);
LHDL.Lt(2,16) = max([78.88,68.08]);

LHDL.colheaders(17) = {'semimem'};
LHDL.Lt(1,17) = min([296.72,332.01,374.28,347.51]);
LHDL.Lt(2,17) = max([296.72,332.01,374.28,347.51]);

LHDL.colheaders(18) = {'semiten'};
LHDL.Lt(1,18) = min([201,181.53,201.16]);
LHDL.Lt(2,18) = max([201,181.53,201.16]);

LHDL.colheaders(19) = {'tfl'};
LHDL.Lt(1,19) = min([416.61, 385.53, 384.7]);
LHDL.Lt(2,19) = max([416.61, 385.53, 384.7]);

end
    
    
    
    
    