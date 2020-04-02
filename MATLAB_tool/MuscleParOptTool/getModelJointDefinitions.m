% functon to retun a strcuture for a specifc model, returning a list of the
% joints present in the model and their associated frames and subsequently
% the bodies which make up these joints - operating under the assumption
% that frames are written using the bodyName_offset as naming convention

% Written by Bryce Killen bryce.killen@kuleuven.be as part of an extension
% of work by Luca Modenese in the parameterisation of muscle tendon
% properties 


% Input: OpenSim model objects
% Output structure where each joint is listed followed by the parent and
% child frames / body names 


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function jointStructure = getModelJointDefinitions(osimModel)

% first get the associated jointset
modelJointSet = osimModel.getJointSet();
% return the number of joints 
numJoints = modelJointSet().getSize();

% create an empty structure to hold the data
jointStructure=struct();

for j = 0:numJoints-1
    tempJoint = modelJointSet.get(j);
    % add the name to the structure
    jointStructure.(char(tempJoint.getName())) = struct();
    % add the parent frame name
    jointStructure.(char(tempJoint.getName())).parentFrame = char(tempJoint.getPropertyByName('socket_parent_frame'));
    % add the child frame name
    jointStructure.(char(tempJoint.getName())).childFrame = char(tempJoint.getPropertyByName('socket_child_frame'));
    % add the parent body
    jointStructure.(char(tempJoint.getName())).parentBody = regexprep(char(tempJoint.getPropertyByName('socket_parent_frame')), '_offset','');
    % add the child body
    jointStructure.(char(tempJoint.getName())).childBody = regexprep(char(tempJoint.getPropertyByName('socket_child_frame')), '_offset','');   
end

end