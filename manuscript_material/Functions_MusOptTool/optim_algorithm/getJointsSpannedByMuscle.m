%-------------------------------------------------------------------------%
% Copyright (c) 2019 Modenese L., Ceseracciu, E., Reggiani M., Lloyd, D.G.%
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
%    Author:   Luca Modenese, July 2013                                   %
%    email:    l.modenese@sheffield.ac.uk                                 % 
% ----------------------------------------------------------------------- %
%
% Given as INPUT a muscle OSMuscleName from an OpenSim model, this function
% returns the OUTPUT structure jointNameSet containing the OpenSim jointNames
% crossed by the OSMuscle.
%
% It works through the following steps:
%   1) extracts the GeometryPath
%   2) loops through the single points, determining the body they belong to
%   3) stores the bodies to which the muscle points are attached to
%   4) determines the nr of joints based on body indexes
%   5) stores the crossed OpenSim joints in the output structure named jointNameSet
%
% NB this function return the crossed joints independently on the
% constraints applied to the coordinates. Eg patello-femoral is considered as a
% joint, although in Arnold's model it does not have independent
% coordinates, but it is moved in dependency of the knee flexion angle.


function [jointNameSet,varargout] = getJointsSpannedByMuscle(osimModel, OSMuscleName)

% just in case the OSMuscleName is given as java string
OSMuscleName = char(OSMuscleName);

%useful initializations
BodySet = osimModel.getBodySet();
muscle  = osimModel.getMuscles.get(OSMuscleName);

% Extracting the PathPointSet via GeometryPath
musclePath = muscle.getGeometryPath();
musclePathPointSet = musclePath.getPathPointSet();

% for loops to get the attachment bodies
n_body = 1;
jointNameSet = [];
muscleAttachBodies = '';
muscleAttachIndex = [];
for n_point = 0:musclePathPointSet.getSize()-1
    
    % get the current muscle point
    currentAttachBody = char(musclePathPointSet.get(n_point).getBodyName());
    
    %Initialize
    if n_point ==0;
        previousAttachBody = currentAttachBody;
        muscleAttachBodies{n_body} = currentAttachBody;
        muscleAttachIndex(n_body) = BodySet.getIndex(currentAttachBody);
        n_body = n_body+1;
    end;
    
    % building a vectors of the bodies attached to the muscles
    if ~strncmp(currentAttachBody,previousAttachBody, size(char(currentAttachBody),2))
        muscleAttachBodies{n_body} = currentAttachBody;
        muscleAttachIndex(n_body) = BodySet.getIndex(currentAttachBody);
        previousAttachBody = currentAttachBody;
        n_body = n_body+1;
    end
end

% From distal body checking the joint names going up until the desired
% OSJointName is found or the proximal body is reached as parent body.
DistalBodyName = muscleAttachBodies{end};
bodyName = DistalBodyName;
ProximalBodyName= muscleAttachBodies{1};
body =  BodySet.get(DistalBodyName);
spannedJointNameOld = '';
n_spanJoint = 1;
n_spanJointNoDof = 1;
NoDofjointNameSet = [];
jointNameSet = [];
while ~strcmp(bodyName,ProximalBodyName)
    
    spannedJoint = body.getJoint();
    spannedJointName = char(spannedJoint.getName());
    
    if strcmp(spannedJointName, spannedJointNameOld)
         body =  spannedJoint.getParentBody();
         spannedJointNameOld = spannedJointName;
    else
            if spannedJoint.getCoordinateSet().getSize()~=0
         
        jointNameSet{n_spanJoint} =  spannedJointName;
        n_spanJoint = n_spanJoint+1;
            else
                NoDofjointNameSet{n_spanJointNoDof} =  spannedJointName;
                n_spanJointNoDof = n_spanJointNoDof+1;
            end
        spannedJointNameOld = spannedJointName;
        body =  spannedJoint.getParentBody();
    end
    bodyName = char(body.getName());
end

if isempty(jointNameSet)
    error(['No joint detected for muscle ',OSMuscleName]);
end
if  ~isempty(NoDofjointNameSet)
    for n_v = 1:length(NoDofjointNameSet)
        display(['Joint ',NoDofjointNameSet{n_v},' has no dof.'])
    end
end

varargout = NoDofjointNameSet;
end