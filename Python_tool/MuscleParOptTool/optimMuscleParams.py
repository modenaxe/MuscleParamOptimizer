#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
Created on Thu Mar 25 15:50:03 2021

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
# 
# This function optimizes the muscle parameters as described in Modenese L, 
# Ceseracciu E, Reggiani M, Lloyd DG (2015). Estimation of 
# musculotendon parameters for scaled and subject specific musculoskeletal 
# models using an optimization technique. Journal of Biomechanics (submitted)
# and prints the results to command window.
# Also it stores information about the optimization in the structure SimInfo

#------ import packages --------- 
import numpy as np
import pandas as pd
import matplotlib.pyplot as plt
from lxml import etree
from pathlib import Path
from scipy.interpolate import interp1d
#-------------------------------- 

def optimMuscleParams(osimModel_ref_filepath, osimModel_targ_filepath, N_eval, log_folder):
    
    
    
    
    
    
    
    
    
    
    
    
    
    # assigning optimized model as output
    osimModel_opt = osimModel_targ;
        
    return osimModel_opt, SimInfo
























