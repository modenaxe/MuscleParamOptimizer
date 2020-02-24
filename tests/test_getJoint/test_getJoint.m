clear;clc;close all

% importing OpenSim libraries
import org.opensim.modeling.*

% test an alternative since getJoint is not a method anymore
osimModel = Model('gait2392_simbody.osim');
osimModel.finalizeConnections()
N_joints = osimModel.getJointSet().getSize();

% ideally I want to discover the joints spanned by a muscle
m = osimModel.getMuscles.get(35);
p = m.getGeometryPath();
startP = p.getPathPointSet.get(0);
endP = p.getPathPointSet.get(p.getPathPointSet.getSize()-1);


% names
endP_body_name = endP.getParentFrame.getName;
startP_body_name = startP.getParentFrame().getName;

cur_prox_body = endP_body_name;
cur_dist_body =  char(startP_body_name);

spanned_joints = [];

% TODO: need to properly print out detials to ensure this is correct
for nj = 0:N_joints-1
    % get joint
    cj = osimModel.getJointSet().get(nj);
%     parent_frame = cj.getParentFrame().getName;
    child_frame_name = char(cj.getChildFrame().findBaseFrame().getName);
    if strcmp(child_frame_name, cur_dist_body)
        % store the joint
        if isempty(spanned_joints)
            spanned_joints = char(cj.getName);
            nj = 2;
        else
            spanned_joints(nj) = {spanned_joints, char(cj.getName)};
            nj=nj+1;
        end
        cur_dist_body = child_frame_name;
    end

end



