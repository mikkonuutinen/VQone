function startVQone(setup_name, practice_run)
% Start VQone software from the command prompt
%
% Give the setup name as the first argument and optionally string 
% 'practice' as the second argument if you want to practice the setup.
%
% Example: startVQone('mySetup','practice')


global setup

version = ['_' getVersion];

if nargin < 1
    disp('Not enough input arguments. Give the setup name as argument')
end

if nargin < 2
   practice_run = ''; 
end

% Load the setup settings
file = [setup_name version];
load([pwd filesep 'setups' filesep file filesep file '_sbu.mat']);


if strcmp(practice_run,'practice') || strcmp(practice_run,'practise');
    setup.practice = 1;
else
    setup.practice = 0;
end

close all;
backgroundQuestions('initialize');

end