function params = getparams(method, root)
% GETPARAMS  Get default params for trainCRBM
%
%   See also TRAINCRBM
%
%   Written by: Peng Qi, Sep 27, 2012

%% Model parameters
params.nmap = 50;
params.szFilter = 5;
params.szPool = 2;
params.method = 'CD';

%% Learining parameters
params.epshbias = 1e-3;
params.epsvbias = 1e-3;
params.epsW = 1e-4;
params.phbias = 0.5;
params.pvbias = 0.5;
params.pW = 0.5;
params.decayw = .01;
params.szBatch = 25;
params.sparseness = .02;
params.whitenData = 0;%1;

% params.epshbias = 1e-3;
% params.epsvbias = 1e-4;
% params.epsW = .001;
% params.phbias = 0.1;
% params.pvbias = 0.1;
% params.pW = 0.1;
% params.decayw = 0;
%% Running parameters
params.iter = 10000;
params.verbose = 4;
params.mfIter = 5;
params.saveInterv = 5;
params.useCuda = 0;
params.saveName = strcat(root,'model.mat');%'/home/jingwei/bird/model.mat';

end