function questionsOnly_sbu()
global test setup
global questions minimum_texts maximum_texts

set(0,'DefaultFigureMenu','none', ...
        'DefaultFigureNumberTitle', 'off');

file_path = [pwd filesep 'setups' filesep setup.name filesep 'filenames.xls'];
% Get content related questions
cells_to_read = sprintf('G%d:G%d', 2, 2);
[~, questions] = xlsread(file_path, cells_to_read);
% Get min values
cells_to_read = sprintf('H%d:H%d', 2, 2);
[~, minimum_texts] = xlsread(file_path, cells_to_read);
% Get max values
cells_to_read = sprintf('I%d:I%d', 2, 2);
[~, maximum_texts] = xlsread(file_path, cells_to_read);
    
% Show the questions screen
file_path = [pwd filesep 'setups' filesep setup.name filesep setup.name ...
    '_qbu.fig'];

screens_info = get(0,'MonitorPosition');
% If the program is run at the triplets
if length(screens_info(:,1)) == 4
    position = [449 -767 1024 740]; % For real use
else
    position = get(0,'monitor'); % for debugging
    position = position(1,:);
end

% Create empty background masking figure
figure('position',position);

for i = 1 : setup.trial_count
    test.tStart = tic;
    questionsOnly_qbu('initialize',position,file_path);
end

close all;

% path to the setup folder
file_path = [pwd filesep 'setups' filesep setup.name filesep];
exit_sequence(file_path,position);

end
