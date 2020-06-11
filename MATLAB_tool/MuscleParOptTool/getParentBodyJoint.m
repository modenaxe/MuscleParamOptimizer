% functon to return the name of the joint from a specified model and joint
% structure ( generatate using getModelJointDefinitions.m ) , where the
% specified body is the parent body

% Written by Bryce Killen bryce.killen@kuleuven.be as part of an extension
% of work by Luca Modenese in the parameterisation of muscle tendon
% properties 


% Input: OpenSim model objects
% Output: jointName - the joint where the specified body is the parent

function jointName = getParentBodyJoint(jointStructure, bodyName)

    % return a list of the joints
    allJoints = fieldnames(jointStructure);
    
    % loop through joints to check the child body entry and return if true
    % NOTE: inefficient but will work temp.
    
    for j = 1:length(allJoints)
        if strcmp(jointStructure.(char(allJoints(j))).parentBody , bodyName)
           jointName = char(allJoints(j));
           return
        end  
    end
end