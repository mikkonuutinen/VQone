function stillPC_sbu()
% Function for showing the stimuli and running the test in Still/Video PC.
% Global variables needed:
%   setup -information about how to run the test
%   data  -variable for storing the test setup info and subject input
%   test  -variable for test related parameters needed in QBU

global data setup test

% Video PC globals
global fig_video1 fig_video2
global player1 player2

% Content related globals
global questions minimum_texts maximum_texts

sequences = createPCRandomization(setup);  % Create stimulus vectors

%Get image file names for Still PC
file_path = [pwd filesep 'setups' filesep setup.name filesep 'filenames.xls'];
if strcmp(setup.standard,'Still PC')
    cells_to_read = sprintf('C%d:C%d', 2, setup.cv1*setup.cv2+4);
    [~, image_file_names]= xlsread( file_path, cells_to_read);
elseif strcmp(setup.standard,'Video PC')
    %Get video file names for Video PC
    cells_to_read = sprintf('C%d:C%d', 2, setup.cv1*setup.cv2+1);
    [~, video_file_names] = xlsread(file_path, cells_to_read);
else
    disp('Unknown standard.')
    return
end

% Get content related questions
cells_to_read = sprintf('G%d:G%d', 2, setup.cv1+1);
[~, questions] = xlsread(file_path, cells_to_read);
% Get min values
cells_to_read = sprintf('H%d:H%d', 2, setup.cv1+1);
[~, minimum_texts] = xlsread(file_path, cells_to_read);
% Get max values
cells_to_read = sprintf('I%d:I%d', 2, setup.cv1+1);
[~, maximum_texts] = xlsread(file_path, cells_to_read);

screens_info = getScreensInfo();

% Position images to correct monitors

switch setup.left_monitor
    case 'Stimulus 1'
        stimulus1_monitor.position = screens_info(1,:);
        stimulus1_monitor.tag = 'left';
    case 'Stimulus 2'
        stimulus2_monitor.position = screens_info(1,:);
        stimulus2_monitor.tag = 'left';
    case 'Both stimuli'
        stimulus1_monitor.position = screens_info(1,:);
        stimulus1_monitor.tag = 'left';
        stimulus2_monitor.position = screens_info(1,:);
        stimulus2_monitor.tag = 'left';
    case 'Questions'
        question_monitor.position = screens_info(1,:);
        question_monitor.tag = 'left';
end

switch setup.center_monitor
    case 'Stimulus 1'
        stimulus1_monitor.position = screens_info(2,:);
        stimulus1_monitor.tag = 'center';
    case 'Stimulus 2'
        stimulus2_monitor.position = screens_info(2,:);
        stimulus2_monitor.tag = 'center';
    case 'Both stimuli'
        stimulus1_monitor.position = screens_info(2,:);
        stimulus1_monitor.tag = 'center';
        stimulus2_monitor.position = screens_info(2,:);
        stimulus2_monitor.tag = 'center';
    case 'Questions'
        question_monitor.position = screens_info(2,:);
        question_monitor.tag = 'center';
end

switch setup.right_monitor
    case 'Stimulus 1'
        stimulus1_monitor.position = screens_info(3,:);
        stimulus1_monitor.tag = 'right';
    case 'Stimulus 2'
        stimulus2_monitor.position = screens_info(3,:);
        stimulus2_monitor.tag = 'right';
    case 'Both stimuli'
        stimulus1_monitor.position = screens_info(3,:);
        stimulus1_monitor.tag = 'right';
        stimulus2_monitor.position = screens_info(3,:);
        stimulus2_monitor.tag = 'right';
    case 'Questions'
        question_monitor.position = screens_info(3,:);
        question_monitor.tag = 'right';
end

switch setup.bottom_monitor
    case 'Stimulus 1'
        stimulus1_monitor.position = screens_info(4,:);
        stimulus1_monitor.tag = 'bottom';
    case 'Stimulus 2'
        stimulus2_monitor.position = screens_info(4,:);
        stimulus2_monitor.tag = 'bottom';
    case 'Questions'
        question_monitor.position = screens_info(4,:);
        question_monitor.tag = 'bottom';
end

% If Video PC, create the video figures and activeX controlled players
if strcmp(setup.standard,'Video PC')
    % Create figures for the video screens
    fig_video1 = figure('Visible', 'Off');
    set(fig_video1, 'Color', 'k');
    fig_video2 = figure('Visible', 'Off');
    set(fig_video2, 'Color', 'k');
    
    % Create Active X objects to the video figures
    player1 = createFigureAndActXMedia(fig_video1,stimulus1_monitor.position);
    player2 = createFigureAndActXMedia(fig_video2,stimulus2_monitor.position);
end

% Needed in QBU, if repeat stimuli button is used
test.stimulus1_monitor = stimulus1_monitor.position;
test.stimulus2_monitor = stimulus2_monitor.position;

%makes settings to display a full screen image
randomization_fullscreen_settings();

cv1_1_order = sequences(:,1);
cv2_1_order = sequences(:,2);

cv1_2_order = sequences(:,3);
cv2_2_order = sequences(:,4);

measure = length(sequences(:,1))

% Check max differences between products
if setup.max_difference ~= Inf
    idx = 1;
    to_be_removed = [];
    for i = 1 : measure
        index1 = (cv1_1_order(i)-1) * setup.cv2 + cv2_1_order(i);
        index2 = (cv1_2_order(i)-1) * setup.cv2 + cv2_2_order(i);
        difference = abs(index1 - index2);
        % Mark the trials with too large difference for removal
        if difference > setup.max_difference
            to_be_removed(idx) = i;
            idx = idx + 1;
        end
    end
        
    if ~isempty(to_be_removed)
        cv1_1_order(to_be_removed) = [];
        cv2_1_order(to_be_removed) = [];
        cv1_2_order(to_be_removed) = [];
        cv2_2_order(to_be_removed) = [];
    end
    measure = length(cv1_1_order)
    
end
measure = length(cv1_1_order)

for i = 0 : length(cv1_1_order(:)) - 1
    ind = i;
    for j = 1 : 2
        data.cv1_1_order(2 * ind + j) = cv1_1_order(i + 1);
        data.cv2_1_order(2 * ind + j) = cv2_1_order(i + 1);
        data.cv1_2_order(2 * ind + j) = cv1_2_order(i + 1);
        data.cv2_2_order(2 * ind + j) = cv2_2_order(i + 1);
    end
end

for i = 1 : measure
    
    if strcmp(setup.standard,'Still PC')
        close all
    end
    
    % Information needed in repeat stimuli function and qbu
    test.current_cv = cv1_1_order(i);
    test.current_trial = i;
    
    stimuli1_index = (cv1_1_order(i)-1) * setup.cv2 + cv2_1_order(i);
    stimuli2_index = (cv1_2_order(i)-1) * setup.cv2 + cv2_2_order(i);
    
    test.camera1 = cv2_1_order(i);
    test.camera2 = cv2_2_order(i);
    % Check if random monitors and more than one monitor in use
    if setup.random_monitors == 1 && setup.stimuli_in_one_monitor == 0
        dice = rand();
        % Switch stimuli monitors randomly
        if dice < 0.5
            tmp = stimuli1_index;
            stimuli1_index = stimuli2_index;
            stimuli2_index = tmp;
            test.camera1 = cv2_2_order(i);
            test.camera2 = cv2_1_order(i);
        end
    end
    
    % Initialize repeat stimuli counter
    data.reWatchStimuli(test.current_trial,:) = [0 0];
    
    % Find the stimuli images
    if strcmp(setup.standard,'Still PC')
        test.file_path1 = [pwd filesep 'images' filesep image_file_names{stimuli1_index}];
        test.file_path2 = [pwd filesep 'images' filesep image_file_names{stimuli2_index}];
    elseif strcmp(setup.standard,'Video PC')
        test.file_path1 = [pwd filesep 'videos' filesep video_file_names{stimuli1_index}];
        test.file_path2 = [pwd filesep 'videos' filesep video_file_names{stimuli2_index}];
    end
    
    % Save the stimuli info
    if strcmp(setup.standard,'Still PC')
        test.camera1_file = {image_file_names{stimuli1_index}};
        test.camera2_file = {image_file_names{stimuli2_index}};
    elseif strcmp(setup.standard,'Video PC')
        test.camera1_file = {video_file_names{stimuli1_index}};
        test.camera2_file = {video_file_names{stimuli2_index}};
    end
    %----------------------------------------------------------------------
    % Show the stimuli
    if strcmp(setup.standard,'Still PC')
        display_fullscreen_images_pc(test.file_path1,test.file_path2,...
            stimulus1_monitor.position,stimulus2_monitor.position);
        %         % Save monitor & stimuli information
        %         data.monitor1(i) = {stimulus1_monitor.tag};
        %         data.monitor1_content(i) = {image_file_names{stimuli1_index}};
        %         data.monitor2(i) = {stimulus2_monitor.tag};
        %         data.monitor2_content(i) = {image_file_names{stimuli2_index}};
    elseif strcmp(setup.standard,'Video PC')
        display_pc_video(test.file_path1,test.file_path2,...
            stimulus1_monitor.position,stimulus2_monitor.position);
        %         % Save monitor & stimuli information
        %         data.monitor1(i) = {stimulus1_monitor.tag};
        %         data.monitor1_content(i) = {video_file_names{stimuli1_index}};
        %         data.monitor2(i) = {stimulus2_monitor.tag};
        %         data.monitor2_content(i) = {video_file_names{stimuli2_index}};
    end
    
    pause(0.5);
    
    test.tStart=tic;
    
    % path to the qbu settings file
    file_path = [pwd filesep 'setups' filesep setup.name filesep setup.name '_qbu.fig'];
    stillPC_qbu('initialize',question_monitor.position,file_path);
    
end

close all;

% path to the setup folder
file_path = [pwd filesep 'setups' filesep setup.name filesep];
exit_sequence(file_path,question_monitor.position);

end

function randomization_fullscreen_settings( )
%Generate a random seed based on the clock
stream = RandStream('mt19937ar','seed',sum(100*clock));

%Make this random seed as the default for random no. generators
RandStream.setDefaultStream(stream);

iptsetpref('ImshowBorder','tight'); %to remove the gray border in figure window

%to remove menubar from all the following figures
set(0,'DefaultFigureMenu','none', 'DefaultFigureNumberTitle', 'off');

warning off; %turn off warning messages
end