#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
Created on Thu Mar 25 15:51:17 2021

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

# Written by Emiliano Ravera emiliano.ravera@uner.edu.ar as part of the 
# Python version of work by Luca Modenese in the parameterisation of muscle
# tendon properties.

#------ import packages --------- 
from pathlib import Path

# adding OpenSim to python script
import sys
sys.path.append('/opt/opensim-core/lib/python3.6/site-packages/')
import opensim

# # adding tool function to python script
# from Public_functions import getModelJointDefinitions, \
#                                 getChildBodyJoint, \
#                                 getParentBodyJoint, \
#                                 getMuscleAttachBody

# from Private_functions import getJointsSpannedByMuscle, \
#                                 getIndipCoordAndJoint, \
#                                 sampleMuscleQuantities

from optimMuscleParams import optimMuscleParams
#-------------------------------- 


# ========= USERS SETTINGS =======
actualpath = Path().resolve()
# p = actualpath.parent
path_opensim_files = str(actualpath.parent) + '/Example_case'

# REFERENCE MODEL
# Muscle dynamics from Arnold model will be mapped onto the target model.
osimModel_ref_filepath  = path_opensim_files + '/Input_Models/Reference_Arnold_R.osim' 

# TARGET MODEL
# Target model is a model built from scratch using dataveric data.
osimModel_targ_filepath  = path_opensim_files +  '/Input_Models/Target_LHDL_Schutte_R.osim'

# nr of evaluations per coordinate
N_eval = 10

# ================================

# Folder where to store the optimized model and a log
# checking if folder exists. If not, create it.
optimizedModel_folder = Path(path_opensim_files + '/Optimized_Models')
optimizedModel_folder.mkdir(parents=True, exist_ok=True)
# initializing folders and log file
log_folder = str(optimizedModel_folder)


# optimizing target based on reference model for N_eval points per coord.
osimModel_opt, SimsInfo = optimMuscleParams(osimModel_ref_filepath, osimModel_targ_filepath, N_eval, log_folder);

# printing the optimized model
osimModel_opt.printToXML(str(optimizedModel_folder) + '/' + osimModel_opt.getName())







