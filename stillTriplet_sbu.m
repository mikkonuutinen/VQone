function stillTriplet_sbu()

global setup
global current_data data test
global questions minimum_texts maximum_texts


% Check the cv2 amount
numbers = [3 7 9 13 15 19 21 25 27];
tmp = numbers == setup.cv2;
if tmp == 0
    disp('Impossible number of CV2s. Please choose 3, 7, 9, 13, 15, 19, 21, 25 or 27 ')
    return
end

sequences = createTripletRandomization(setup);  % Create stimulus vectors

%Get image file names
file_path = [pwd filesep 'setups' filesep setup.name filesep 'filenames.xls'];
cells_to_read = sprintf('C%d:C%d',2, setup.cv1*setup.cv2+4);
[~, image_file_names]= xlsread( file_path, cells_to_read);

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
    case 'Stimulus 3'
        stimulus3_monitor.position = screens_info(1,:);
        stimulus3_monitor.tag = 'left';
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
    case 'Stimulus 3'
        stimulus3_monitor.position = screens_info(2,:);
        stimulus3_monitor.tag = 'center';
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
    case 'Stimulus 3'
        stimulus3_monitor.position = screens_info(3,:);
        stimulus3_monitor.tag = 'right';
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
    case 'Stimulus 3'
        stimulus3_monitor.position = screens_info(4,:);
        stimulus3_monitor.tag = 'bottom';
    case 'Questions'
        question_monitor.position = screens_info(4,:);
        question_monitor.tag = 'bottom';
end

%makes settings to display a full screen image
randomization_fullscreen_settings();

cv1_1_order = sequences(:,1);
cv2_1_order = sequences(:,2);

cv1_2_order = sequences(:,3);
cv2_2_order = sequences(:,4);

cv1_3_order = sequences(:,5);
cv2_3_order = sequences(:,6);

for i = 0 : length(cv1_1_order(:)) - 1
    ind = i;
    for j = 1 : 3
        data.cv1_1_order(3 * ind + j) = cv1_1_order(i + 1);
        data.cv2_1_order(3 * ind + j) = cv2_1_order(i + 1);
        data.cv1_2_order(3 * ind + j) = cv1_2_order(i + 1);
        data.cv2_2_order(3 * ind + j) = cv2_2_order(i + 1);
        data.cv1_3_order(3 * ind + j) = cv1_3_order(i + 1);
        data.cv2_3_order(3 * ind + j) = cv2_3_order(i + 1);
    end
end
        
measure = length(sequences(:,1));

for i = 1 : measure
    
    if setup.is_masking == 1
        %Displays masking image on top of the previous
        display_fullscreen_masking_image(stimulus1_monitor.position,...
            stimulus2_monitor.position, stimulus3_monitor.position);
        pause(0.5);
    end
    
    % Information needed in repeat stimuli function and qbu
    test.current_cv = cv1_1_order(i);
    test.current_trial = i;
    
    stimuli1_index = (cv1_1_order(i)-1) * setup.cv2 + cv2_1_order(i);
    stimuli2_index = (cv1_2_order(i)-1) * setup.cv2 + cv2_2_order(i);
    stimuli3_index = (cv1_3_order(i)-1) * setup.cv2 + cv2_3_order(i);
    
    test.camera1 = cv2_1_order(i);
    test.camera2 = cv2_2_order(i);
    test.camera3 = cv2_3_order(i);
    test.camera1_file = {image_file_names{stimuli1_index}};
    test.camera2_file = {image_file_names{stimuli2_index}};
    test.camera3_file = {image_file_names{stimuli3_index}};
        
    % Check if random monitors
    if setup.random_monitors == 1
        order = randperm(3);
        stimuli(1,1) = stimuli1_index;
        stimuli(2,1) = stimuli2_index;
        stimuli(3,1) = stimuli3_index;
        stimuli(:,2) = order;
        % Save the camera numbers before mixing
        stimuli(1,3) = cv2_1_order(i);
        stimuli(2,3) = cv2_2_order(i);
        stimuli(3,3) = cv2_3_order(i);
        % Mix
        stimuli = sortrows(stimuli,2);
        stimuli1_index = stimuli(1,1);
        stimuli2_index = stimuli(2,1);
        stimuli3_index = stimuli(3,1);
        test.camera1 = stimuli(1,3);
        test.camera2 = stimuli(2,3);
        test.camera3 = stimuli(3,3);
        test.camera1_file = {image_file_names{stimuli1_index}};
        test.camera2_file = {image_file_names{stimuli2_index}};
        test.camera3_file = {image_file_names{stimuli3_index}};
    end
    
    close all;
    file_path1 = [pwd filesep 'images' filesep image_file_names{stimuli1_index}];
    file_path2 = [pwd filesep 'images' filesep image_file_names{stimuli2_index}];
    file_path3 = [pwd filesep 'images' filesep image_file_names{stimuli3_index}];
    display_fullscreen_images(...
        file_path1,...
        file_path2,...
        file_path3,...
        stimulus1_monitor.position,...
        stimulus2_monitor.position,...
        stimulus3_monitor.position);
    
      % THESE ARE REDUNDANT DATA IF EVERYTHING IS WORKING PROPERLY
      % USE FOR DEBUGGING
%     % Save monitor&stimulus information
%     data.monitor1(3*(i-1)+1) = {stimulus1_monitor.tag};
%     data.monitor1(3*(i-1)+2) = {stimulus1_monitor.tag};
%     data.monitor1(3*(i-1)+3) = {stimulus1_monitor.tag};
%     
%     data.monitor1_content(3*(i-1)+1) = {image_file_names{stimuli1_index}};
%     data.monitor1_content(3*(i-1)+2) = {image_file_names{stimuli1_index}};
%     data.monitor1_content(3*(i-1)+3) = {image_file_names{stimuli1_index}};
%     
%     data.monitor2(3*(i-1)+1) = {stimulus2_monitor.tag};
%     data.monitor2(3*(i-1)+2) = {stimulus2_monitor.tag};
%     data.monitor2(3*(i-1)+3) = {stimulus2_monitor.tag};
%     
%     data.monitor2_content(3*(i-1)+1) = {image_file_names{stimuli2_index}};
%     data.monitor2_content(3*(i-1)+2) = {image_file_names{stimuli2_index}};
%     data.monitor2_content(3*(i-1)+3) = {image_file_names{stimuli2_index}};
%     
%     data.monitor3(3*(i-1)+1) = {stimulus3_monitor.tag};
%     data.monitor3(3*(i-1)+2) = {stimulus3_monitor.tag};
%     data.monitor3(3*(i-1)+3) = {stimulus3_monitor.tag};
%     
%     data.monitor3_content(3*(i-1)+1) = {image_file_names{stimuli3_index}};
%     data.monitor3_content(3*(i-1)+2) = {image_file_names{stimuli3_index}};
%     data.monitor3_content(3*(i-1)+3) = {image_file_names{stimuli3_index}};
    
% Check the viewing time setting and close stimuli if needed
if setup.viewing_time ~= 0
    pause(setup.viewing_time)
    close all
else
    pause(0.5);
end

    test.tStart=tic;
    
    % path to the qbu settings file
    file_path = [pwd filesep 'setups' filesep setup.name filesep setup.name '_qbu.fig'];
    stillTriplet_qbu('initialize',question_monitor.position,file_path);
end

close all;

% path to the setup folder
file_path = [pwd filesep 'setups' filesep setup.name filesep];
exit_sequence(file_path,question_monitor.position);

end

function display_fullscreen_images(image_file_index1,image_file_index2,...
    image_file_index3,screen_info1,screen_info2,screen_info3)
fig1 = figure('Visible', 'off');    %Create an invisible blank figure
%imshow( image_file_index1, 5 );     %Display the image on the previous figure
imshow( image_file_index1 );     %Display the image on the previous figure
fig2 = figure('Visible', 'off');    %Create an invisible blank figure
%imshow( image_file_index2, 5 );     %Display the image on the previous figure
imshow( image_file_index2 );     %Display the image on the previous figure
fig3 = figure('Visible', 'off');    %Create an invisible blank figure
%imshow( image_file_index3, 5 );     %Display the image on the previous figure
imshow( image_file_index3 );     %Display the image on the previous figure

set(fig1, 'Position',screen_info1); %Set the properties of the given figure
set(fig2, 'Position',screen_info2); %Set the properties of the given figure
set(fig3, 'Position',screen_info3); %Set the properties of the given figure
set([fig1 fig2 fig3],'visible','on')
end

function display_fullscreen_masking_image(screen_info1,screen_info2,screen_info3)
file_path = [pwd filesep 'images' filesep 'masking_image.jpg'];
fig1 = figure('Visible', 'off');     %Create an invisible blank figure
imshow(file_path);                  %Display the image on the previous figure
fig2 = figure('Visible', 'off');     %Create an invisible blank figure
imshow(file_path);                  %Display the image on the previous figure
fig3 = figure('Visible', 'off');     %Create an invisible blank figure
imshow(file_path);                  %Display the image on the previous figure

set(fig1, 'Position',screen_info1);   %Set the properties of the given figure
set(fig2, 'Position',screen_info2);   %Set the properties of the given figure
set(fig3, 'Position',screen_info3);   %Set the properties of the given figure
set(fig1, 'Visible', 'On');          %make the figure visible
set(fig2, 'Visible', 'On');          %make the figure visible
set(fig3, 'Visible', 'On');          %make the figure visible
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
















