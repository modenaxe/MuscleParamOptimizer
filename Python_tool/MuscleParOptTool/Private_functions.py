#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
Created on Thu Mar 25 15:54:09 2021

@author: emi
"""
# ------------------------------------------------------------------------ #
# Copyright (c) 2019 Modenese L., Ceseracciu, E., Reggiani M., Lloyd, D.G. #
#                                                                          #
# Licensed under the Apache License, Version 2.0 (the "License");          #
# you may not use this file except in compliance with the License.         #
# You may obtain a copy of the License at                                  # 
# http://www.apache.org/licenses/LICENSE-2.0.                              #
#                                                                          # 
# Unless required by applicable law or agreed to in writing, software      #
# distributed under the License is distributed on an "AS IS" BASIS,        #
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or          #
# implied. See the License for the specific language governing             #
# permissions and limitations under the License.                           #
#                                                                          #
#    Author:   Luca Modenese, January 2015                                 #
#    email:    l.modenese@imperial.ac.uk                                   # 
# ------------------------------------------------------------------------ #

#------ import packages --------- 
import numpy as np
from lxml import etree
from itertools import product
import logging

# adding OpenSim to python script
import sys
sys.path.append('/opt/opensim-core/lib/python3.6/site-packages/')
import opensim

# adding tool function to python script
from Public_functions import getModelJointDefinitions, \
                                getChildBodyJoint, \
                                getParentBodyJoint, \
                                getMuscleAttachBody
#-------------------------------- 

def getJointsSpannedByMuscle(osimModel, OSMuscleName):
    # Given as INPUT a muscle OSMuscleName from an OpenSim model, this function
    # returns the OUTPUT list jointNameSet containing the OpenSim jointNames
    # crossed by the OSMuscle.
    # 
    # It works through the following steps:
    #   1) extracts the GeometryPath
    #   2) loops through the single points, determining the body they belong to
    #   3) stores the bodies to which the muscle points are attached to
    #   4) determines the nr of joints based on body indexes
    #   5) stores the crossed OpenSim joints in the output list named jointNameSet
    #
    # NB this function return the crossed joints independently on the
    # constraints applied to the coordinates. Eg patello-femoral is considered as a
    # joint, although in Arnold's model it does not have independent
    # coordinates, but it is moved in dependency of the knee flexion angle.
    
    # Written by Emiliano Ravera emiliano.ravera@uner.edu.ar as part of the 
    # Python version of work by Luca Modenese in the parameterisation of muscle
    # tendon properties.
    
    # useful initializations
    BodySet = osimModel.getBodySet()
    muscle  = osimModel.getMuscles().get(OSMuscleName)
    
    # additions BAK -> adapted by ER
    # load a jointStrucute detailing bone and joint configurations
    # osimModel_file = osimModel.getInputFileName()
    jointStructure = getModelJointDefinitions(osimModel)
    
    # Extracting the PathPointSet via GeometryPath
    musclePath = muscle.getGeometryPath()
    musclePathPointSet = musclePath.getPathPointSet()
    
    # for loops to get the attachment bodies
    muscleAttachBodies = []
    muscleAttachIndex = []
    
    for n_point in range(0, musclePathPointSet.getSize()):
        
        # get the current muscle point
        muscelPathPoint_name =  musclePathPointSet.get(n_point).getName()
        currentAttachBody = getMuscleAttachBody(osimModel, muscelPathPoint_name)
        
        # Initialize
        if n_point == 0:
            previousAttachBody = currentAttachBody
            muscleAttachBodies.append(currentAttachBody)
            muscleAttachIndex.append(BodySet.getIndex(currentAttachBody))
        # building a list of the bodies attached to the muscles
        if currentAttachBody != previousAttachBody:
            muscleAttachBodies.append(currentAttachBody)
            muscleAttachIndex.append(BodySet.getIndex(currentAttachBody))
            previousAttachBody = currentAttachBody
            
    # end of loops to get the attacement bodies
            
    # From distal body checking the joint names going up until the desired
    # OSJointName is found or the proximal body is reached as parent body.
    DistalBodyName = muscleAttachBodies[-1]
    bodyName = DistalBodyName
    ProximalBodyName = muscleAttachBodies[0]
    body =  BodySet.get(DistalBodyName)
    
    spannedJointNameOld = ''
    NoDofjointNameSet = []
    jointNameSet = []
    
    while bodyName != ProximalBodyName:
            
        # BAK implementation -> adapted by ER
        spannedJointName = getChildBodyJoint(jointStructure, body.getName())
        spannedJoint = osimModel.getJointSet().get(spannedJointName[0])
        
        if spannedJointName == spannedJointNameOld:
            # BAK implementation -> adapted by ER
            body = osimModel.getBodySet().get(bodyName)
            spannedJointNameOld = spannedJointName[0]
        else:
            if spannedJoint.numCoordinates() != 0:
                jointNameSet.append(spannedJointName[0])
            else:
                NoDofjointNameSet.append(spannedJointName[0])
            
            spannedJointNameOld = spannedJointName[0]
            bodyName = jointStructure[spannedJointName[0]]['parentBody']
            body = osimModel.getBodySet().get(bodyName)
            
        bodyName = body.getName()
    
     
    if not jointNameSet:
        print('ERORR: ' + 'No joint detected for muscle ' + OSMuscleName)
    
    if NoDofjointNameSet:
        for value in NoDofjointNameSet:
            print('Joint ' + value + ' has no dof.')
    
    varargout = NoDofjointNameSet 
    
    
    return jointNameSet, varargout

# ----------------------------------------------------------------------------
def getIndipCoordAndJoint(osimModel, constraint_coord_name):
    # Function that given a dependent coordinate finds the independent
    # coordinate and the associated joint. The function assumes that the
    # constraint is a CoordinateCoupleConstraint as used by Arnold, Delp and
    # LLLM. The function can be useful to manage the patellar joint for instance.
    
    # Input: OpenSim model objects
    # Output: ind_coord_name and ind_coord_joint_name - the joint with specific constraint
    
    # Written by Emiliano Ravera emiliano.ravera@uner.edu.ar as part of the 
    # Python version of work by Luca Modenese in the parameterisation of muscle
    # tendon properties.
    
    ind_coord_name = ''
    ind_coord_joint_name = ''
    # load model XML file  
    osimModel_filepath = osimModel.getInputFileName()
    osimModel_file = etree.parse(osimModel_filepath)
    model = osimModel_file.getroot()
        
    # double check: if not constrained then function returns
    flag = [1  for constraint in  model.findall('.//CoordinateCouplerConstraint') if constraint.get('name').find(constraint_coord_name)]
       
    if flag == []:
        # print(constraint_coord_name + ' is not a constrained coordinate.')
        logging.error(' ' + constraint_coord_name + ' is not a constrained coordinate.')
        return ind_coord_name, ind_coord_joint_name
    
    # otherwise search through the constraints
    for constraint in  model.findall('.//CoordinateCouplerConstraint'):
        
        # this function assumes that the constraint will be a coordinate
        # coupler contraint ( Arnold's model and LLLM uses this)
                
        # get dep coordinate and check if it is the coord of interest
        dep_coord_name = constraint.find('dependent_coordinate_name').text
        
        if dep_coord_name in constraint_coord_name:
            # print('WARNING: Only one indipendent coordinate is managed by the "getIndipCoordAndJoint" function yet.')
            logging.warning(' Only one indipendent coordinate is managed by the "getIndipCoordAndJoint" function yet.')
            
            ind_coord_name = constraint.find('independent_coordinate_names').text
            ind_coord_joint_name = constraint.find('independent_coordinate_names').text # assume the same name for coordinate and joint 
            
    return ind_coord_name, ind_coord_joint_name


# ----------------------------------------------------------------------------
def sampleMuscleQuantities(osimModel,OSMuscle,muscleQuant, N_EvalPoints):
    # Given as INPUT an OpenSim muscle OSModel, OSMuscle, a muscle variable and a nr
    # of evaluation points this function returns as
    # musOutput a vector of the muscle variable of interest
    # obtained by sampling the ROM of the joint spanned by the muscle in
    # N_EvalPoints evaluation points.
    # For multidof joint the combinations of ROMs are considered.
    # For multiarticular muscles the combination of ROM are considered.
    # The script is totally general because based on generating strings of code 
    # correspondent to the encountered code. The strings are evaluated at the end.
    
    # IMPORTANT 1
    # The function can decrease the N_EvalPoints if there are too many dof 
    # involved (ASSUMPTION is that a better sampling will be vanified by the 
    # huge amount of data generated). This is an option that can be controlled
    # by the user by deciding if to use it or not (setting limit_discr = 0/1)
    # and, in case the sampling is limited, by setting a lower limit to the
    # discretization.
    
    # IMPORTANT 2
    # Another check is done on the dofs: only INDEPENDENT coordinate are
    # considered. This is fundamental for patellofemoral joint that both in
    # LLLM and Arnold's model are constrained dof, dependent on the knee
    # flexion angle. This function assumes to be used with Arnold's model.
    # currentState is initialState;
    
    # IMPORTANT 3
    # At the purposes of the muscle optimizer it is important that here the
    # model is initialize every time. So there are no risk of working with an
    # old state (important for Schutte muscles for instance, where we observed
    # that it was necessary to re-initialize the muscle after updating the
    # muscle parameters).
    
    # Written by Emiliano Ravera emiliano.ravera@uner.edu.ar as part of the 
    # Python version of work by Luca Modenese in the parameterisation of muscle
    # tendon properties.
    
    # ======= SETTINGS ======
    # limit (1) or not (0) the discretization of the joint space sampling
    limit_discr = 0
    # minimum angular discretization
    min_increm_in_deg = 1
    # =======================
    
    # initialize the model
    currentState = osimModel.initSystem()
    
    # getting the joint crossed by a muscle
    muscleCrossedJointSet, _ = getJointsSpannedByMuscle(osimModel, OSMuscle.getName())
            
    # index for effective dofs
    DOF_Index = []
    CoordinateBoundaries = []
    degIncrem = []
    
    for _, curr_joint in enumerate(muscleCrossedJointSet):
        # Initial estimation of the nr of Dof of the CoordinateSet for that
        # joint before checking for locked and constraint dofs.
        nDOF = osimModel.getJointSet().get(curr_joint).numCoordinates()
        
        # skip welded joint and removes welded joint from muscleCrossedJointSet
        if nDOF == 0:
            continue
        
        # calculating effective dof for that joint
        effect_DOF = nDOF
        for n_coord in range(0,nDOF):
            # get coordinate
            curr_coord = osimModel.getJointSet().get(curr_joint).get_coordinates(n_coord)
            curr_coord_name = curr_coord.getName()
            
            # skip dof if locked
            if curr_coord.getLocked(currentState):
                continue
            
            # if coordinate is constrained then the independent coordinate and
            # associated joint will be listed in the sampling "map"
            if curr_coord.isConstrained(currentState) and not curr_coord.getLocked(currentState):
                constraint_coord_name = curr_coord_name
                # finding the independent coordinate
                ind_coord_name, ind_coord_joint_name = getIndipCoordAndJoint(osimModel, constraint_coord_name)
                # updating the coordinate name to be saved in the list
                curr_coord_name = ind_coord_name
                effect_DOF -= 1
                # ignoring constrained dof if they point to an independent
                # coordinate that has already been stored
                if osimModel.getCoordinateSet().getIndex(curr_coord_name) in DOF_Index:
                    continue
                # skip dof if independent coordinate locked (the coord
                # correspondent to the name needs to be extracted)
                if osimModel.getCoordinateSet().get(curr_coord_name).getLocked(currentState):
                    continue
                
            # NB: DOF_Index is used later in the string generated code.
            # CRUCIAL: the index of dof now is model based ("global") and
            # different from the joint based used until now.
            DOF_Index.append(osimModel.getCoordinateSet().getIndex(curr_coord_name))
            
            # necessary update/reload the curr_coord to avoid problems with 
            # dependent coordinates
            curr_coord = osimModel.getCoordinateSet().get(DOF_Index[-1])
            
            # Getting the values defining the range
            jointRange = np.zeros(2)
            jointRange[0] = curr_coord.getRangeMin()
            jointRange[1] = curr_coord.getRangeMax()
            
            # Storing range of motion conveniently
            CoordinateBoundaries.append(jointRange)
            
            # increments in the variables when sampling the mtl space. 
            # Increments are different for each dof and based on N_eval.
            # Defining the increments
            degIncrem.append((jointRange[1] - jointRange[0]) / (N_EvalPoints-1))
            
            # limit or not the discretization of the joint space sampling
            # a limit to the increase can be set though
            if limit_discr == 1 and degIncrem[-1] < np.radians(min_increm_in_deg):
                degIncrem[-1] = np.radians(min_increm_in_deg)
    
        
    # assigns an interval of variation following the initial and final value
    # for each dof X
        
    # setting up for loops in order to explore all the possible combination of
    # joint angles (looping on all the dofs of each joint for all the joint
    # crossed by the muscle).
    # The model pose is updated via: " coordToUpd.setValue(currentState,setAngleDof)"
    # The right dof to update is chosen via: "coordToUpd = osimModel.getCoordinateSet.get(n_instr)"
    
    # generate a dictionary with CoordinateRange for each dof X. 
    # The dictionary keys are the DOF_Index in the model
    CoordinateRange = {}
    for pos, dof in enumerate(DOF_Index):
        CoordinateRange[str(dof)] = np.linspace(CoordinateBoundaries[pos][0] , CoordinateBoundaries[pos][1], N_EvalPoints)
    
    # generate a list of dictionaries to explore all the possible combination of
    # joit angle
    CoordinateCombinations = [dict(zip(CoordinateRange.keys(), element)) for element in product(*CoordinateRange.values())] 
    
    # looping on all the dofs combinations
    musOutput = [None] * len(CoordinateCombinations)
    
    for iteration, DOF_comb in enumerate(CoordinateCombinations):
        # Set the model pose
        for dof_ind in DOF_comb.keys():
            coordToUpd = osimModel.getCoordinateSet().get(int(dof_ind))
            coordToUpd.setValue(currentState, CoordinateCombinations[iteration][dof_ind])
        
        # calculating muscle length for the muscle    
        if muscleQuant == 'MTL':
            musOutput[iteration] = OSMuscle.getGeometryPath().getLength(currentState)
            
        if muscleQuant == 'LfibNorm':
            OSMuscle.setActivation(currentState,1.0)
            osimModel.equilibrateMuscles(currentState)
            musOutput[iteration] = OSMuscle.getNormalizedFiberLength(currentState)
            
        if muscleQuant == 'Lten':
            OSMuscle.setActivation(currentState,1.0)
            osimModel.equilibrateMuscles(currentState)
            musOutput[iteration] = OSMuscle.getTendonLength(currentState)
            
        if muscleQuant == 'Ffib':
            OSMuscle.setActivation(currentState,1.0)
            osimModel.equilibrateMuscles(currentState)
            musOutput[iteration] = OSMuscle.getActiveFiberForce(currentState)
            
        if muscleQuant == 'all':
            OSMuscle.setActivation(currentState,1.0)
            osimModel.equilibrateMuscles(currentState)
            musOutput[iteration] = [ OSMuscle.getGeometryPath().getLength(currentState), \
                                    OSMuscle.getNormalizedFiberLength(currentState), \
                                    OSMuscle.getTendonLength(currentState), \
                                    OSMuscle.getActiveFiberForce(currentState), \
                                    OSMuscle.getPennationAngle(currentState) ]

    return musOutput




















