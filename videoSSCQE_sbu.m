function videoSSCQE_sbu()

global data fig_video player setup test current_continuous_data current_trial
global questions minimum_texts maximum_texts

sequences = createVideoSSCQERandomization(setup);  % Create stimulus vectors

%Get image file names
file_path = [pwd filesep 'setups' filesep setup.name filesep 'filenames.xls'];
cells_to_read = sprintf('C%d:C%d', 2, setup.cv1*setup.cv2+1);
[~, video_file_names] = xlsread(file_path, cells_to_read);

% Get content related questions
cells_to_read = sprintf('G%d:G%d', 2, setup.cv1+1);
[~, questions] = xlsread(file_path, cells_to_read);
% Get min values
cells_to_read = sprintf('H%d:H%d', 2, setup.cv1+1);
[~, minimum_texts] = xlsread(file_path, cells_to_read);
% Get max values
cells_to_read = sprintf('I%d:I%d', 2, setup.cv1+1);
[~, maximum_texts] = xlsread(file_path, cells_to_read);

%delete('tmp.mat');

screens_info = getScreensInfo();

% Position images to correct monitors

switch setup.left_monitor
    case 'Questions'
        question_monitor = screens_info(1,:);
    case 'Stimulus'
        stimulus_monitor = screens_info(1,:);
end

switch setup.center_monitor
    case 'Questions'
        question_monitor = screens_info(2,:);
    case 'Stimulus'
        stimulus_monitor = screens_info(2,:);
end

switch setup.right_monitor
    case 'Questions'
        question_monitor = screens_info(3,:);
    case 'Stimulus'
        stimulus_monitor = screens_info(3,:);
end

switch setup.bottom_monitor
    case 'Stimulus'
        stimulus_monitor = screens_info(4,:);
    case 'Questions'
        question_monitor = screens_info(4,:);
end

% Makes settings to display a full screen image
randomization_fullscreen_settings();

% Create figure for the video screen
fig_video = figure('Visible', 'Off');
set(fig_video, 'Color', 'k');

% Place the video figure to the correct monitor and create Active X object
player = createFigureAndActXMedia(fig_video,stimulus_monitor);

cv1_order = sequences(:,1);
cv2_order = sequences(:,2);

measure = length(sequences(:,1));

for i = 1 : measure
    data.cv1_order(i) = cv1_order(i);
    data.cv2_order(i) = cv2_order(i);
end

for i = 1 : measure
    
    pause(2)
    
    % Initialize rewatch counter
    data.reWatchStimulus(i) = 0;
    
    stimuli_index = (cv1_order(i)-1) * setup.cv2 + cv2_order(i);

    file_path = [pwd filesep 'videos' filesep video_file_names{stimuli_index}];
    
    % Save the filename for data saving
    test.file = video_file_names{stimuli_index};
    disp(['Current video file: ' test.file])
    
    % Test related information for QBU
    current_trial = i;
    test.extras = 0;
    test.video_file = file_path;
    test.stimulus_monitor = stimulus_monitor;
    test.question_monitor = question_monitor;
    test.current_trial = current_trial;
    test.current_cv = cv1_order(i);
    % Play the video and show the evaluation slider
    display_video_sscqe(file_path,stimulus_monitor,question_monitor);
    
    if setup.extra_questions == 1  || setup.extra_questions == 2
        file_path = [pwd filesep 'setups' filesep setup.name filesep ...
            setup.name '_extra_qbu.fig'];
        test.extras = 1;
        videoSSCQE_qbu(question_monitor,file_path);
    end
    
end

close all;

% path to the setup folder
file_path = [pwd filesep 'setups' filesep setup.name filesep];
exit_sequence(file_path,question_monitor);

end


function randomization_fullscreen_settings( )
stream = RandStream('mt19937ar','seed',sum(100*clock)); %Generate a random seed based on the clock
RandStream.setDefaultStream(stream); %Make this random seed as the default for random no. generators
iptsetpref('ImshowBorder','tight'); %to remove the gray border in figure window
set(0,'DefaultFigureMenu','none', 'DefaultFigureNumberTitle', 'off'); %to remove menubar from all the following figures
warning off; %turn off warning messages
end