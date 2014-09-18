% Example script for backing up project-related data.
% This script backs up the data for the following paper: 
%   Ecker et al. 2014, Neuron

restr = nc.AnalysisStims * ae.LfpParams & 'sort_method_num = 5 AND min_freq = 0.5 AND max_freq = 10';
schemas = {'acq', 'cont', 'detect', 'sort', 'stimulation', 'ephys', 'ae', 'nc'};
exclude = {...
    {'Aod*', '*2', 'TberPulses'}, ...
    {}, ...
    {}, ...
    {'Tetrodes*', 'Variational*', 'KalmanTemp'}, ...
    {'*Info'}, ...
    {'SpikesAligned*', 'ReceptiveFields'}, ...
    {}, ...
    {}};

for i = 1 : numel(schemas)
    backupSchemaData(schemas{i}, restr, exclude{i}{:});
end