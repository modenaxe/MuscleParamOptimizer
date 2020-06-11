# Introduction

This repository contains a MATLAB package implementing an algorithm for optimizing the parameters of Hill-type muscle models defined by adimensional force-lenght-velocity curves, as described by _Zajac (1989)_.


The algorithm is generic but the implementation is specific for musculoskeletal models of the software for biomechanical analyses [OpenSim](https://opensim.stanford.edu/).


The repository is made available as accompanying material of [this publication](https://research-repository.griffith.edu.au/bitstream/handle/10072/101916/ModenesePUB918.pdf?sequence=1): 

```bibtex
@article{modenese2016estimation,
  title={Estimation of musculotendon parameters for scaled and subject specific musculoskeletal models using an optimization technique},
  author={Modenese, Luca and Ceseracciu, Elena and Reggiani, Monica and Lloyd, David G},
  journal={Journal of biomechanics},
  volume={49},
  number={2},
  pages={141--148},
  year={2016},
  publisher={Elsevier}
}
```
and includes scripts, models and materials to reproduce figures and results of that work.

# Requirements

In order to use this MATLAB package it is necessary to:
* install MATLAB with the Optimization Toolbox
* install OpenSim 3.2 or higher
* setup the OpenSim API (Application User Interface) for MATLAB as described [at this link](http://simtk-confluence.stanford.edu:8080/display/OpenSim/Scripting+with+Matlab).

# Contents from the paper

## Algorithm description
The algorithm starts from an existing model in which the muscle parameters, and the derived muscle dynamics, are assumed to be accurate. These models, known as _generic models_ and here referred to as _Reference Models_, are generally created from 
cadaveric measurements.

The idea consists in mapping the normalized muscle contractile conditions from these reference models to those of personalised models, i.e. linearly scaled or fully subject-specific, for the same joint angles and muscle activation levels. In this respect, the algorithm is a generalization of method proposed by _Winby et al. (2008)_ for the knee-spanning muscles.

## Considered Cases
* **Scaled generic model**: a lower limb model was scaled linearly to the size of an individual to [perform a running simulation](https://simtk.org/projects/runningsim) as published by _Hamner et al. (2010)_. The muscle parameters of the [obtained model](https://github.com/modenaxe/MuscleParamOptimizer/tree/master/manuscript_material/Example1/MSK_Models) were then optimized non-linearly using the original generic model as reference model.
* **Subject-specific model**: a [model of the lower limb](https://github.com/modenaxe/MuscleParamOptimizer/tree/master/manuscript_material/Example2/MSK_Models) was built from scratch using the LHDL cadaveric dataset and its muscle parameters were estimated and validated using the [lower limb model](https://simtk.org/projects/lowlimbmodel09) of _Arnold et al. (2010)_ as reference model.

## MATLAB Scripts
Following the alphabetic order of the scripts in the main folder, it is possible to:
* reproduce exactly the results presented in the associated publication in the manuscript (scripts a and b)
* generate the associated Figures (scripts c-d-e).

__Please note__ that reproducing the sensitivity study can be time-consuming, depending on the available computational resources.

# Example of use of a generic MATLAB tool

An example of use of a MATLAB tool is available in the [corresponding folder](https://github.com/modenaxe/MuscleParamOptimizer/tree/master/MATLAB_tool). 
The same main script can be easily adapted for the optimization of other personalized models.

# OpenSim C++ plugin and User Interface Menu

A generic tool to optimize musculotendon parameters in musculoskeletal models is also available at [this repository](https://github.com/MuscleOptimizer/MuscleOptimizer) as:
* C++ OpenSim plugin 
* as menu extension of the OpenSim GUI (graphical user interface).
Please refer directly to the repository and to the nice documentation available at [this website](http://muscleoptimizer.github.io/MuscleOptimizer/).

# Contributord
Thank you to Bryce Killen from KU Leuven for updating the code for OpenSim 4.1!

# References
* Zajac, F.E. Muscle and tendon: properties, models, scaling, and application to biomechanics and motor control. Critical Reviews in Biomedical Engineering. 17: 359-411, 1989. [LINK](https://www.ncbi.nlm.nih.gov/pubmed/2676342)
* Winby, C.R., Lloyd, D.G.  Kirk, T.B. Evaluation of different analytical methods for subject-specific scaling of musculotendon parameters. Journal of Biomechanics. 41: 1682-1688, 2008. [LINK](https://www.ncbi.nlm.nih.gov/pubmed/18456272)
* Hamner, S.R., Seth, A.  Delp, S.L. Muscle contributions to propulsion and support during running. Journal of Biomechanics. 43: 2709-2716, 2010. [LINK](https://www.ncbi.nlm.nih.gov/pubmed/20691972)
* Arnold, E., Ward, S., Lieber, R.  Delp, S. A Model of the Lower Limb for Analysis of Human Movement. Annals of Biomedical Engineering. 38: 269-279, 2010. [LINK](https://www.ncbi.nlm.nih.gov/pubmed/19957039)
