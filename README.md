# Fitting and Experiment Design for HIV Reporter using MCP-GFP or smiFISH Labels

This folder contains codes needed to fit models to experimental data and remake figures from the manuscript:

H. Vo et al, Analysis and design of single-cell experiments to harvest fluctuation information while rejecting measurement noise, BioRxiv, 2023, https://www.biorxiv.org/content/10.1101/2021.05.11.443611v4

To run these codes, you will need the following:
1. MATLAB R2021b or later (earlier releases have not been tested).
2. Symbolic Computing Toolbox.
3. Global Optimization Toolbox.
4. Parallel Computing Toolbox.
5. The Matlab Tensor Toolbox, which can be found at https://www.tensortoolbox.org/.  You will need to make sure to add the TTB to the Matlab path before running the provided codes.

The main folder of this repository contains three scripts of interest.  For each, it is recommended that you open these in the matlab editor and run one cell at a time.

"exampleModelScript.m" shows the user how to set up a model, associate experimental data, defie a PDO, run a parameter estimation routine, compute the FIM, and run the Metropolis Hasting search.

"FittingExperimentalData.m" provides commands to run all data fitting routines in order to regenerate all results in the manuscript. To complete fits from scratch, you will need to run the different sections multiple times, which may take a couple days of computing depending on your computer speed and number of available CPUs. 

"PlottingResults.m" provides commands to make the final figures for the paper, plus additional analyses that were left out of the original manuscript, but which might be of interest to some readers.

# Ongoing Efforts

A broader array of model generation and fitting tools (including graphical interface) is under continual development. The current version can be accessed at: https://github.com/MunskyGroup/SSIT

# Questions?

If you have questions or to report bugs, please contact Brian Munsky at brian.munsky@colostate.edu.
