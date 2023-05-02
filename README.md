# Fitting and Experiment Design for HIV Reporter using MCP-GFP or smiFISH Labels

This repository contains all codes needed to fit models to experimental data and remake figures from the manuscript:

H. Vo et al, Analysis and design of single-cell experiments to harvest fluctuation information while rejecting measurement noise, BioRxiv, 2023, https://www.biorxiv.org/content/10.1101/2021.05.11.443611v4

To run these codes, you will need the following:
1. MATLAB R2021b or later (earlier releases have not been tested).
2. Symbolic Computing Toolbox.
3. Global Optimization Toolbox.
4. Parallel Computing Toolbox.

The main folder of this repository contains three scripts of interest.  For each, it is recommended that you open these in the matlab editor and run one cell at a time.

Make sure to change the working directory to the main folder in which this README and the files "exampleModelScript.m", "FittingExperimentalData.m" and "PlottingResults.m" are placed.

"exampleModelScript.m" shows the user how to set up a model, associate experimental data, defie a PDO, run a parameter estimation routine, compute the FIM, and run the Metropolis Hasting search.

"FittingExperimentalData.m" provides commands to run all data fitting routines in order to regenerate all results in the manuscript. To complete fits from scratch, you will need to run the different sections multiple times, which may take a couple days of computing depending on your computer speed and number of available CPUs. 

"PlottingResults.m" provides commands to make the final figures for the paper, plus additional analyses that were left out of the original manuscript, but which might be of interest to some readers.

# Acknowledgements

The SSIT tools in this repository make use of sparse tensors using the Tensor Toolbox for MATLAB (version 3.2.1) provided by Brett W. Bader, Tamara G. Kolda and others at www.tensortoolbox.org under   Users of this software should cite the TTM creators at:

* B. W. Bader and T. G. Kolda, Efficient MATLAB Computations with Sparse and Factored Tensors, SIAM J. Scientific Computing, 30(1):205-231, 2007, http://dx.doi.org/10.1137/060676489. 

The provided SSIT tools also make use a modified version of Expokit for the solution of time-invariant master equations (although these codes are not used for the current publication). Users of this software should cite the creators at:

Sidje, R. B., Expokit Software Package for Computing Matrix Exponentials, ACM Trans. Math. Softw., 24:1, 1998.

# Ongoing Efforts

A broader array of model generation and fitting tools (including graphical interface) is under continual development. The current version can be accessed at: https://github.com/MunskyGroup/SSIT

# Questions?

If you have questions or to report bugs, please contact Brian Munsky at brian.munsky@colostate.edu.
