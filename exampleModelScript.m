%% Define SSIT Model
clear all
addpath('subroutines');
Model = SSIT;
Model.species = {'x1';'x2';'x3';'x4'}; % Set species names for bursting gene expression model:
Model.stoichiometry = [-1, 1, 0, 0, 0, 0;...
                1,-1,-1, 1, 0, 0;...
                0, 0, 1,-1, 0, 0;...
                0, 0, 0, 0, 1,-1]; % Define Stoichiometry matrix.
Model.propensityFunctions = {'k12*x1';'k21*x2';'omega*x2';'1000*x3';'b*1000*x3*ITrypt';'g*x4'};
% Define propensity functions.

Model.initialCondition = [2;0;0;0]; % Initial condition (defines number of alleles = 2).
Model.parameters = ({'k12',0.0001;...
    'k21',0.000144503877053683;...
    'omega',0.312916841224738;...
    'b',3.3425444227277;...
    'g',0.00521554504466886}); % Parameters (after fitting to t=0,300)
Model.inputExpressions = {'ITrypt','(t<5)'}; % Tryptolide takes effect at 5 min.
Model.fspOptions.initApproxSS=true; % Initial condition is at Steady State

%% Solve SSIT model
Model.fspOptions.bounds = [0 0 0 0 3 3 3 1200]; % Initial bounds for FSP solution.
[FSPsoln,Model.fspOptions.bounds] = Model.solve; % Solve FSP.

%% Load and Assign Experimental Data to Variables
Model = Model.loadData(['Huy_intensity_data_correct',filesep,'NucAndSpotClassification_dTS_2.csv'],{'x4','nucIntens3'});

%% Create PDO (e.g., for FISH intensity data)
Model.pdoOptions.type = 'GaussSpurrious';  % Set the PDO to type Gaussian with Spurrious measurements
% Set PDO parameters -- 7 parameter per species and only the 4th species
% has non-zero parameters.  Here are the parameters that were fit to the
% calibration data.
Model.pdoOptions.props.PDOpars(3*7+1:4*7) = [1225.15968593735 5763.33514930208 1.83194486127572 91.8392775451715 2.18441427191091e-14 797.987351366183 9.1562855790308e-06];
Model.pdoOptions.props.pdoOutputRange = [0,0,0,2259];
Model.pdoOptions.PDO = Model.generatePDO(Model.pdoOptions,...
     Model.pdoOptions.props.PDOpars,FSPsoln.fsp,false);

%% Fit Model to Data
Model.fittingOptions.modelVarsToFit = [2:5]; % Choose parameters to fit.
Model.fittingOptions.timesToFit = [true false true]; % Only fitting t=0,300.

% Define Prior on Model Parameters (log10-normal)
muLog10Prior = [-4,log10(0.2),log10(7.12),log10(0.012)];
sigLog10Prior = [2 1 1 1];
Model.fittingOptions.logPrior = @(p)-(log10(p(:))-muLog10Prior').^2./(2*sigLog10Prior'.^2);

fitOptions = optimset('Display','iter','MaxIter',100); % Set Fitting options
[pars,likelihood] = Model.maximizeLikelihood([],fitOptions); % Fit model
Model.parameters(2:5,2) = num2cell(pars); % Update model parameters

%% Run Sensitivity and FIM Calculation
Model.solutionScheme = 'fspSens'; % Set solutions scheme to FSP Sensitivity
Model.sensOptions.solutionMethod = 'finiteDifference'; % Use Finite Difference approach
sensSoln = Model.solve(FSPsoln.stateSpace);  % Solve the sensitivity problem
fimResults = Model.computeFIM(sensSoln.sens); % Compute FIM
nCells = [135,96,62]; % Number of cells at t = [0,18,300];
fimTotal = nCells(1)*fimResults{1}+nCells(3)*fimResults{3};

%% Run Metropolis Hastings search.
fim = fimTotal(2:5,2:5) + diag((1./sigLog10Prior).^2/log(10)^2);
pars = [Model.parameters{2:5,2}]; % Parameters.
fimLog = diag(pars)*fim*diag(pars); % Convert to log space.
covLog = fimLog^(-1);
MHOptions = struct('numberOfSamples',1000,'burnIn',0,'thin',1,'saveFile','TMPmh_',...
    'useFIMforMetHast',false);
MHOptions.proposalDistribution  = @(x)mvnrnd(x,0.8*covLog);
Model.solutionScheme = 'FSP';   % Set solutions scheme to FSP Sensitivity
Model.fspOptions.fspTol = inf;  % Set high FSP error tolerance to repress expansion
[~,~,chainResultsL] = Model.maximizeLikelihood([],MHOptions,'MetropolisHastings');
