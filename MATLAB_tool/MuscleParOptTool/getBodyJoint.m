%-------------------------------------------------------------------------%
%    Copyright (c) 2021 Modenese L.                                       %
%    Author:   Luca Modenese,  2021                                       %
%    email:    l.modenese@imperial.ac.uk                                  %
% ----------------------------------------------------------------------- %
% Function replacing the old getJoint() method that we all loved in OpenSim
% 3.3 but currently non available in OpenSim 4.x.
% Returns the joint for which the specified body would be the child.
% ----------------------------------------------------------------------- %
function bodyJoint = getBodyJoint(osimModel, aBodyName, debug_printout)

import org.opensim.modeling.*;

if nargin<3; debug_printout=0; end

% default
bodyJoint = [];

if strcmp(aBodyName, 'ground')
    return
end

% check if body is included in the model
if osimModel.getBodySet().getIndex(aBodyName)<0
    error(['getBodyJoint.m The specified body ', aBodyName,' is not included in the OpenSim model'])
end

% get jointset
jointSet = osimModel.getJointSet();

% loop through jointset
nj = 1;

for n_joint = 0:jointSet.getSize()-1
    
    % get cur joint
    cur_joint = jointSet.get(n_joint);
    
    % child frame from joint
    child_frame = cur_joint.getChildFrame();
    
    % link back to base frame: this could be a body
    body_of_frame = child_frame.findBaseFrame();
    
    % get base frame name
    possible_body_name = char(body_of_frame.getName());

    % if body with that name exist than the joint is that body's joint
    if osimModel.getBodySet.getIndex(possible_body_name)>=0 && strcmp(aBodyName, possible_body_name)
        
        % save the joints with the specified body as Child 
        jointName(nj) = {char(cur_joint.getName())};
        
        if debug_printout
            disp([aBodyName, ' is parent frame on joint: ',jointName{nj}]);
        end
        % update counter
        nj = nj + 1;
        continue
    end
end

% return a string if there is only one body
if numel(jointName)==1
    jointName = jointName{1};
    bodyJoint = osimModel.getJointSet.get(jointName);
else
    error(['getBodyJoint.m More than one joint connected to body of interest', aBodyName,'. This function is design to work as getJoint() in OpenSim 3.3.'])
end

end
