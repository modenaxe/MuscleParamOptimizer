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




#------ import packages --------- 
import subprocess
from pathlib import Path
import pandas as pd
import numpy as np
from scipy.signal import find_peaks
import matplotlib.pyplot as plt
import sys
sys.path.append('/opt/opensim-core/lib/python3.6/site-packages/')
import opensim
from lxml import etree
import gc
#-------------------------------- 


# ========= USERS SETTINGS =======
# REFERENCE MODEL
# Muscle dynamics from Arnold model will be mapped onto the target model.
osimModel_ref_filepath   = '.\Example_case\Input_Models\Reference_Arnold_R.osim';

# TARGET MODEL
# Target model is a model built from scratch using dataveric data.
osimModel_targ_filepath  = '.\Example_case\Input_Models\Target_LHDL_Schutte_R.osim';

# nr of evaluations per coordinate
N_eval = 10;

# Folder where to store the optimized model and a log
optimizedModel_folder = '.\Example_case\Optimized_Models';
# ================================










