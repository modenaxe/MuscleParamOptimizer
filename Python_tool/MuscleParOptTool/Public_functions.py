#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
Created on Thu Mar 25 15:54:35 2021

@author: emi
"""
#------ import packages --------- 
from lxml import etree
import re

# adding OpenSim to python script
import sys
sys.path.append('/opt/opensim-core/lib/python3.6/site-packages/')
import opensim
#-------------------------------- 


def getModelJointDefinitions(osimModel):
    
    # functon to retun a strcuture for a specifc model, returning a list of the
    # joints present in the model and their associated frames and subsequently
    # the bodies which make up these joints - operating under the assumption
    # that frames are written using the bodyName_offset as naming convention
    
    # Written by Emiliano Ravera emiliano.ravera@uner.edu.ar as part of the 
    # Python version of work by Luca Modenese in the parameterisation of muscle
    # tendon properties.
    
    # load model XML file  
    osimModel_filepath = osimModel.getInputFileName()
    osimModel_file = etree.parse(osimModel_filepath)
    model = osimModel_file.getroot()
    # create an empty dictionary to hold the data  
    jointStructure = {}
    
    # Weld Joint type
    for joint in model.findall('.//WeldJoint'):
        # add the name to the dictionary
        jointStructure[joint.get('name')] = {}
        # add the parent frame name
        jointStructure[joint.get('name')]['parentFrame'] = joint.find('socket_parent_frame').text
        # add the child frame name
        jointStructure[joint.get('name')]['childFrame'] = joint.find('socket_child_frame').text
        # add the parent body
        jointStructure[joint.get('name')]['parentBody'] = re.sub('_offset', '', joint.find('socket_parent_frame').text)
        # add the child body
        jointStructure[joint.get('name')]['childBody'] = re.sub('_offset', '', joint.find('socket_child_frame').text)
    # Pin Joint type
    for joint in model.findall('.//PinJoint'):
        # add the name to the dictionary
        jointStructure[joint.get('name')] = {}
        # add the parent frame name
        jointStructure[joint.get('name')]['parentFrame'] = joint.find('socket_parent_frame').text
        # add the child frame name
        jointStructure[joint.get('name')]['childFrame'] = joint.find('socket_child_frame').text
        # add the parent body
        jointStructure[joint.get('name')]['parentBody'] = re.sub('_offset', '', joint.find('socket_parent_frame').text)
        # add the child body
        jointStructure[joint.get('name')]['childBody'] = re.sub('_offset', '', joint.find('socket_child_frame').text)
    # Slider Joint type
    for joint in model.findall('.//SliderJoint'):
        # add the name to the dictionary
        jointStructure[joint.get('name')] = {}
        # add the parent frame name
        jointStructure[joint.get('name')]['parentFrame'] = joint.find('socket_parent_frame').text
        # add the child frame name
        jointStructure[joint.get('name')]['childFrame'] = joint.find('socket_child_frame').text
        # add the parent body
        jointStructure[joint.get('name')]['parentBody'] = re.sub('_offset', '', joint.find('socket_parent_frame').text)
        # add the child body
        jointStructure[joint.get('name')]['childBody'] = re.sub('_offset', '', joint.find('socket_child_frame').text)
    # Ball Joint type
    for joint in model.findall('.//BallJoint'):
        # add the name to the dictionary
        jointStructure[joint.get('name')] = {}
        # add the parent frame name
        jointStructure[joint.get('name')]['parentFrame'] = joint.find('socket_parent_frame').text
        # add the child frame name
        jointStructure[joint.get('name')]['childFrame'] = joint.find('socket_child_frame').text
        # add the parent body
        jointStructure[joint.get('name')]['parentBody'] = re.sub('_offset', '', joint.find('socket_parent_frame').text)
        # add the child body
        jointStructure[joint.get('name')]['childBody'] = re.sub('_offset', '', joint.find('socket_child_frame').text)
    # Ellipsoid Joint type
    for joint in model.findall('.//EllipsoidJoint'):
        # add the name to the dictionary
        jointStructure[joint.get('name')] = {}
        # add the parent frame name
        jointStructure[joint.get('name')]['parentFrame'] = joint.find('socket_parent_frame').text
        # add the child frame name
        jointStructure[joint.get('name')]['childFrame'] = joint.find('socket_child_frame').text
        # add the parent body
        jointStructure[joint.get('name')]['parentBody'] = re.sub('_offset', '', joint.find('socket_parent_frame').text)
        # add the child body
        jointStructure[joint.get('name')]['childBody'] = re.sub('_offset', '', joint.find('socket_child_frame').text)
    # Free Joint type
    for joint in model.findall('.//FreeJoint'):
        # add the name to the dictionary
        jointStructure[joint.get('name')] = {}
        # add the parent frame name
        jointStructure[joint.get('name')]['parentFrame'] = joint.find('socket_parent_frame').text
        # add the child frame name
        jointStructure[joint.get('name')]['childFrame'] = joint.find('socket_child_frame').text
        # add the parent body
        jointStructure[joint.get('name')]['parentBody'] = re.sub('_offset', '', joint.find('socket_parent_frame').text)
        # add the child body
        jointStructure[joint.get('name')]['childBody'] = re.sub('_offset', '', joint.find('socket_child_frame').text)
    # Custom Joint type
    for joint in model.findall('.//CustomJoint'):
        # add the name to the dictionary
        jointStructure[joint.get('name')] = {}
        # add the parent frame name
        jointStructure[joint.get('name')]['parentFrame'] = joint.find('socket_parent_frame').text
        # add the child frame name
        jointStructure[joint.get('name')]['childFrame'] = joint.find('socket_child_frame').text
        # add the parent body
        jointStructure[joint.get('name')]['parentBody'] = re.sub('_offset', '', joint.find('socket_parent_frame').text)
        # add the child body
        jointStructure[joint.get('name')]['childBody'] = re.sub('_offset', '', joint.find('socket_child_frame').text)
    
        
    return jointStructure


# ----------------------------------------------------------------------------
def getChildBodyJoint(jointStructure, bodyName):
    # Functon to return the name of the joint from a specified model and joint
    # structure ( generatate using getModelJointDefinitions.m ) , where the
    # specified body is the child body
    
    # Written by Emiliano Ravera emiliano.ravera@uner.edu.ar as part of the 
    # Python version of work by Luca Modenese in the parameterisation of muscle
    # tendon properties.
    
    # Input: OpenSim model objects
    # Output: jointName - the joint where the specified body is the child
    
    jointName = []
    
    for joint in jointStructure:
        jointName.append([joint  for (key, value) in jointStructure[joint].items() if value == bodyName and key == 'childBody'])
        
    jointName = list(filter(None, jointName))
    
    jointName = jointName[0]
    
    return jointName


# ----------------------------------------------------------------------------
def getParentBodyJoint(jointStructure, bodyName):
    # Functon to return the name of the joint from a specified model and joint
    # structure ( generatate using getModelJointDefinitions.m ) , where the
    # specified body is the parent body
    
    # Written by Emiliano Ravera emiliano.ravera@uner.edu.ar as part of the 
    # Python version of work by Luca Modenese in the parameterisation of muscle
    # tendon properties.
    
    # Input: OpenSim model objects
    # Output: jointName - the joint where the specified body is the parent
    
    jointName = []
    
    for joint in jointStructure:
        jointName.append([joint  for (key, value) in jointStructure[joint].items() if value == bodyName and key == 'parentBody'])
        
    jointName = list(filter(None, jointName))
    jointName = jointName[0]
    
    return jointName

# ----------------------------------------------------------------------------
def getMuscleAttachBody(osimModel, musclePathPointName):
    # Functon to return the name of the muscel path point from a specified model
    # and muscle, where the specified body is the parent body
    
    # Written by Emiliano Ravera emiliano.ravera@uner.edu.ar as part of the 
    # Python version of work by Luca Modenese in the parameterisation of muscle
    # tendon properties.
    
    # Input: OpenSim model objects
    # Output: bodyName - the body for the specified musclepath
    
    bodyName = []
    # load model XML file  
    osimModel_filepath = osimModel.getInputFileName()
    osimModel_file = etree.parse(osimModel_filepath)
    model = osimModel_file.getroot()
    
    musclePath = model.findall('./' + musclePathPointName)
    
    for musclePath in model.findall('.//PathPoint'):
        if musclePath.get('name') == musclePathPointName:
            bodyName = re.sub('/bodyset/', '', musclePath.find('socket_parent_frame').text)
            
    for musclePath in model.findall('.//ConditionalPathPoint'):
        if musclePath.get('name') == musclePathPointName:
            bodyName = re.sub('/bodyset/', '', musclePath.find('socket_parent_frame').text)
    
    for musclePath in model.findall('.//MovingPathPoint'):
        if musclePath.get('name') == musclePathPointName:
            bodyName = re.sub('/bodyset/', '', musclePath.find('socket_parent_frame').text)
        
    return bodyName

