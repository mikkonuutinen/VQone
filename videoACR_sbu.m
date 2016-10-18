function videoACR_sbu()

global data 
global action current_trial stimulus_monitor reference_monitor
global current_stimulus current_bad_ref current_good_ref
global questions minimum_texts maximum_texts setup test
global fig_video player current_cv

sequences = createVideoACRRandomization(setup);  % Create stimulus vectors

%Get video file names
file_path = [pwd filesep 'setups' filesep setup.name filesep 'filenames.xls'];
cells_to_read = sprintf('C%d:C%d', 2, setup.cv1*setup.cv2+1);
[~, video_file_names] = xlsread(file_path, cells_to_read);

if setup.referencing_enabled
    %Get reference videos
    % Bad refs
    cells_to_read = sprintf('E%d:E%d',2,setup.cv1+1);
    [~, bad_videos] = xlsread(file_path, cells_to_read);
    
    % Good refs
    cells_to_read = sprintf('F%d:F%d',2,setup.cv1+1);
    [~, good_videos] = xlsread(file_path, cells_to_read);
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
    case 'Questions'
        question_monitor = screens_info(1,:);
    case 'Stimulus'
        stimulus_monitor = screens_info(1,:);
    case 'References'
        reference_monitor = screens_info(1,:);
    case 'Stimulus & References'
        stimulus_monitor = screens_info(1,:);
        reference_monitor = screens_info(1,:);
end

switch setup.center_monitor
    case 'Questions'
        question_monitor = screens_info(2,:);
    case 'Stimulus'
        stimulus_monitor = screens_info(2,:);
    case 'References'
        reference_monitor = screens_info(2,:);
    case 'Stimulus & References'
        stimulus_monitor = screens_info(2,:);
        reference_monitor = screens_info(2,:);
end

switch setup.right_monitor
    case 'Questions'
        question_monitor = screens_info(3,:);
    case 'Stimulus'
        stimulus_monitor = screens_info(3,:);
    case 'References'
        reference_monitor = screens_info(3,:);
    case 'Stimulus & References'
        stimulus_monitor = screens_info(3,:);
        reference_monitor = screens_info(3,:);
end

switch setup.bottom_monitor
    case 'Stimulus'
        stimulus_monitor = screens_info(4,:);
    case 'Questions'
        question_monitor = screens_info(4,:);
    case 'References'
        reference_monitor = screens_info(4,:);
end

% Makes settings to display a full screen image
randomization_fullscreen_settings();

% Create figure for the video screen
fig_video = figure('Visible', 'Off');
set(fig_video, 'Color', 'k');

% Create Active X object to the video figure
player = createFigureAndActXMedia(fig_video,stimulus_monitor);

cv1_order = sequences(:,1);
cv2_order = sequences(:,2);

measure = length(sequences(:,1));

for i = 1 : measure
    data.cv1_order(i) = cv1_order(i);
    data.cv2_order(i) = cv2_order(i);
end

old_cv = 0;

for i = 1 : measure
    if old_cv ~= cv1_order(i)
        seen_already = 0;
    end
    
    current_cv = cv1_order(i);
    current_trial = i;
    data.reWatchStimulus(i) = 0;
    data.reWatchReferences(i) = 0;
    test.current_cv = current_cv;
    test.current_trial = i;
    
    stimuli_index = (cv1_order(i)-1) * setup.cv2 + cv2_order(i);
    
    if setup.referencing_enabled == 1 && seen_already == 0
        % Bad reference
        file_path = [pwd filesep 'videos' filesep bad_videos{cv1_order(i)}];
        current_bad_ref = file_path;
        display_video(file_path,reference_monitor);
        
        pause(0.5)
        
        % Good reference
        file_path = [pwd filesep 'videos' filesep good_videos{cv1_order(i)}];
        current_good_ref = file_path;
        display_video(file_path,reference_monitor);
        seen_already = 1;
        
        % Ask if the subject wants to see the references again or continue
        roadBlock(question_monitor)
        while action ~= 0
            switch action
                case 1
                    % Bad reference
                    file_path = [pwd filesep 'videos' filesep bad_videos{cv1_order(i)}];
                    display_video(file_path,reference_monitor);
                    
                    pause(0.5)
                    
                    % Good reference
                    file_path = [pwd filesep 'videos' filesep good_videos{cv1_order(i)}];
                    display_video(file_path,reference_monitor);
                    roadBlock(question_monitor);
                case 2
                    action = 0;
            end
        end
        
    end
    
    % Play the stimulus video
    file_path = [pwd filesep 'videos' filesep video_file_names{stimuli_index}];
    current_stimulus = file_path;
    
    data.video_file(i) = {video_file_names{stimuli_index}};
    disp('Current stimulus:')
    disp(data.video_file(i));
    
    display_video(file_path,stimulus_monitor);
    
    % Show the questions screen
    test.tStart = tic;
    file_path = [pwd filesep 'setups' filesep setup.name filesep setup.name '_qbu.fig'];
    videoACR_qbu('initialize',question_monitor,file_path);
    
    old_cv = cv1_order(i);
    
end

close all;

% path to the setup folder
file_path = [pwd filesep 'setups' filesep setup.name filesep];
exit_sequence(file_path,question_monitor);

end

function randomization_fullscreen_settings()
stream = RandStream('mt19937ar','seed',sum(100*clock)); %Generate a random seed based on the clock
RandStream.setDefaultStream(stream); %Make this random seed as the default for random no. generators
iptsetpref('ImshowBorder','tight'); %to remove the gray border in figure window
set(0,'DefaultFigureMenu','none', 'DefaultFigureNumberTitle', 'off'); %to remove menubar from all the following figures
warning off; %turn off warning messages
end