%% Vo_et_al_FittingExperimentalData.m
clear all
addpath('subroutines')
addpath('src')
TMP = SSIT(); clear TMP; % Load definition of the SSIT class for later use.

%% Set Variables to Control Fit
fileStr = ['Parameter_Fit_Files',filesep,'NewParameterSet']; % name for saving the fitting results
vars.timeSet = [0,300]; % Data to fit (0,18,300) or subset.
vars.doFit = true; % Set the code to fitting mode. 
vars.display = 'final'; % Repress iteration in parameter searches.
vars.fitCases = [1:5]; % Set code to try all data sets and PDOs.
vars.modelVarsToFit = [2:5]; % Variables allowed to change in fit.
vars.pdoTimes = [0,300]; % Times to include in the calculation of PDO.
vars.priorScale = 2; % Scaling factor to make prior broader.
vars.muLog10Prior = [-4,-4,log10(0.2),log10(7.12),log10(0.012)]'; 
vars.sigLog10Prior = [1,1,.5,.5,.5]'*vars.priorScale;
vars.makePlots = false; % Turn of figure generation
vars.initialFspBounds = [0 0 0 0 3 3 3 1200]; % Initial FSP bounds.
vars.modelChoice = '2stateBurst'; % Choice of model.
vars.covWithPrior = true; % Use prior in FIM display.

%% Step 1 - Find the PDO parameters.
vars.iter = 50000;
FittingFunctionsFISHTrue(1,[fileStr,'_0_300'],vars);
% This cell runs the fits of the various PDOs to the various data sets.  It
% is sometimes helpful to run this a few times to ensure convergence. To
% check how well the fits have converged, run the first cell of the script
% "Vo_et_al_PlottingResults" (make sure to change the file
% names to your current fits).

%% Step 2 - Fit the Data (fminsearch)
vars.iter = 1000; % Number of iterations in fminsearch
vars.timeSet = [0,300]; % Data to fit (0,18,300) or subset.
FittingFunctionsFISHTrue(32,[fileStr,'_0_300'],vars); 
% This section fit the data at chosen time points ([0,300] in this case).
% It is pretty common that you will get stuck in a local minimum during
% this fit.  To help with that, we run a few fits using the different PDOs
% and exchanging initial parametr guesses. 
% It is recommended that you run this a couple times before continuing to
% the next step. Also, it is recommended to redo this a couple times after
% completing Step 4 in cases a better parameter set was found using the
% MH. To check how well the fit is doing, you can run the first few cells
% of the code "Vo_et_al_PlottingResults" (make sure to change the file
% names to your current fits).
% Note, if you wish to re-run this fit for other data sets (e.g.,
% [0,18,300]), make sure to change both vars.timeSet and the name of the
% file to which you are saving the results (e.g., change [fileStr,'_0_300']
% to [fileStr,'_0_18_300']. An example script for how to do this for many
% cases at a time is provided at "Other_Useful_Functions/IterateFitsAndMHN.m".
%% Step 3 - Compute Fisher Information Matrix (current experiment design)
FittingFunctionsFISHTrue(3,[fileStr,'_0_300'],vars)
% This section computes and saves the FIM for all the different data sets
% and the current experiment design.
%% Step 4 - Quantify Uncertainty (Met. Hast.)
vars.nMH = 1000;
vars.mhScaling = 0.8;
FittingFunctionsFISHTrue(4,[fileStr,'_0_300'],vars)
% It is sometimes helpful to run a few short chains (e.g., ~100) and 
% adjust the proposal scaling 'vars.mhscaling' until you get an acceptance
% rate of about  0.2-0.4.  This will lead to better mixing of the chain. If
% the fit from the previous section is not fully converged, you will have a
% poor starting point. In this case it is helpful to iterate steps 2-4 to
% get closer to a global MLE before running long chains.
% Once this is complete, you can plot results by running the MH cells in
% the script "Vo_et_al_PlottingResults" (make sure to change the file
% names to your current fits).
%% Step 5 - Compute FIM for subsequent experiment designs
vars.nFIMsamples = 1;
FittingFunctionsFISHTrue(5,[fileStr,'_0_300'],vars)
% This section will compute the FIM for a very large number of possible
% experiment time points and for all of the different PDOs.
