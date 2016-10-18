function ACR_sbu()

global questions minimum_texts maximum_texts
global setup test data
persistent old_cv

% Create new stimulus vectors
sequences = createRandomization(setup);

% Check that the vectors aren't similar to previous vectors
load([pwd filesep 'setups' filesep setup.name filesep ...
    'vector_history.mat']);
cv1_similars = 0;
cv2_similars = 0;
sim_pos = 0;
sim_report = '';

if isfield(vector_history,'cv1')
    size_vector_history = length(vector_history.cv1(1,:));
    write_pos = 1;
    for i = 1 : size_vector_history
        test_vector1 = pdist([sequences(1,:);vector_history.cv1(:,i)']);
        test_vector2 = pdist([sequences(2,:);vector_history.cv2(:,i)']);
        sum1 = sum(test_vector1);
        sum2 = sum(test_vector2);
        
        history_report = ['Current stimulus vector distances from history entry No. ' num2str(i) ...
            ': CV1: ' num2str(sum1) ' and CV2: ' num2str(sum2)];
        
        disp(history_report)
        
        % The sums should be non-zero. Otherwise there are similar vectors
        % in the history
        if sum1 == 0
            disp('Found similar cv1 vector...')
            cv1_similars = cv1_similars + 1;
            sim_pos(write_pos) = i;
            write_pos = write_pos + 1;
        elseif sum2 == 0
            disp('Found similar cv2 vector...')
            cv2_similars = cv2_similars + 1;
            sim_pos(write_pos) = i;
            write_pos = write_pos + 1;
        end
    end
    sim_report = ['Found in total ' num2str(cv1_similars) ' similar cv1 vectors' ...
        ' and ' num2str(cv2_similars) ' similar cv2 vectors from the history.'];
    disp(sim_report)
    test.sim_report = sim_report;
    test.sim_pos = sim_pos;
else
    size_vector_history = 0;
    test.sim_report = sim_report;
    test.sim_pos = sim_pos;
end

% Save stimulus vectors
vector_history.cv1(:,size_vector_history + 1) = sequences(1,:);
vector_history.cv2(:,size_vector_history + 1) = sequences(2,:);
save([pwd filesep 'setups' filesep setup.name filesep ...
    'vector_history.mat'],'vector_history')

file_path = [pwd filesep 'setups' filesep setup.name filesep 'filenames.xls'];
%Get image file names
cells_to_read = sprintf('C%d:C%d', 2, setup.cv1*setup.cv2+1);
[~, image_file_names]= xlsread(file_path, cells_to_read);

% Get content related questions
cells_to_read = sprintf('G%d:G%d', 2, setup.cv1+1);
[~, questions] = xlsread(file_path, cells_to_read);
% Get min values
cells_to_read = sprintf('H%d:H%d', 2, setup.cv1+1);
[~, minimum_texts] = xlsread(file_path, cells_to_read);
% Get max values
cells_to_read = sprintf('I%d:I%d', 2, setup.cv1+1);
[~, maximum_texts] = xlsread(file_path, cells_to_read);

% Get static reference images
if strcmp(setup.ref_type,'oneref')
    cells_to_read = sprintf('E%d:E%d', 2, setup.cv1+1);
    [~, oneref_images] = xlsread(file_path, cells_to_read);
elseif strcmp(setup.ref_type,'tworef')
    cells_to_read = sprintf('E%d:E%d', 2, setup.cv1+1);
    [~, tworef_images_1] = xlsread(file_path, cells_to_read);
    cells_to_read = sprintf('F%d:F%d', 2, setup.cv1+1);
    [~, tworef_images_2] = xlsread(file_path, cells_to_read);
end

screens_info = getScreensInfo();

% Position images to correct monitors

switch setup.left_monitor
    case 'Reference'
        reference_monitor = screens_info(1,:);
    case 'Reference 1'
        reference1_monitor = screens_info(1,:);
    case 'Reference 2'
        reference2_monitor = screens_info(1,:);
    case 'Stimulus'
        stimulus_monitor = screens_info(1,:);
end

switch setup.center_monitor
    case 'Reference'
        reference_monitor = screens_info(2,:);
    case 'Reference 1'
        reference1_monitor = screens_info(2,:);
    case 'Reference 2'
        reference2_monitor = screens_info(2,:);
    case 'Stimulus'
        stimulus_monitor = screens_info(2,:);
end

switch setup.right_monitor
    case 'Reference'
        reference_monitor = screens_info(3,:);
    case 'Reference 1'
        reference1_monitor = screens_info(3,:);
    case 'Reference 2'
        reference2_monitor = screens_info(3,:);
    case 'Stimulus'
        stimulus_monitor = screens_info(3,:);
end

switch setup.bottom_monitor
    case 'Reference'
        reference_monitor = screens_info(4,:);
    case 'Reference 1'
        reference1_monitor = screens_info(4,:);
    case 'Reference 2'
        reference2_monitor = screens_info(4,:);
    case 'Stimulus'
        stimulus_monitor = screens_info(4,:);
    case 'Questions'
        question_monitor = screens_info(4,:);
end

%makes settings to display a full screen image
randomization_fullscreen_settings();

% Check reference connecting
if setup.referencing_enabled == 1
    if strcmp(setup.ref_connecting,'CV1') == 1
        references = setup.cv1;
    else
        references = setup.cv2;
    end
    test.references = references;
end

cv1_order = sequences(1,:);
cv2_order = sequences(2,:);

for i = 1 : length(sequences)
    data.cv1_order(i) = cv1_order(i);
    data.cv2_order(i) = cv2_order(i);
end

% Information for the display references function
test.cv1_order = cv1_order;
test.cv2_order = cv2_order;
test.image_file_names = image_file_names;

old_cv = 0;
% How many trials
measure = length(sequences(1,:));

for i = 1 : measure
    
    if strcmp(setup.ref_type,'dynamic')
        data.reWatchReferences(i) = 0;
    end
    %----------------------------------------------------------------------
    % Show all the images at the beginning of each content
    if setup.referencing_enabled == 1 && strcmp(setup.ref_type,'dynamic') == 1 && ...
            cv1_order(i) ~= old_cv
        % Check reference randomizing
        if setup.ref_random == 1
            reference_order = randperm(references);
        else
            reference_order = 1:references;
        end
        %Creates a dummy invisible mask figure
        previous_fig = figure('Visible','Off');
        for ref_index = 1 : references
            if strcmp(setup.ref_connecting,'CV2')
                stimuli_index = (cv1_order(i)-1) * setup.cv2 + ...
                    reference_order(ref_index);
            else
                stimuli_index = (reference_order(ref_index)-1) * setup.cv2 + ...
                    cv1_order(i);
            end
            file_path = [pwd filesep 'images' filesep image_file_names{stimuli_index}];
            %Displays reference image on top of the previous masking image
            new_fig = display_fullscreen_image(file_path,stimulus_monitor);
            set(new_fig,'visible','on')
            
            
            
            %pause(1);
            pause(0.25); % TÄSTÄ MUUTETAAN ALUKSI NÄYTETTÄVIEN REFERENSSIEN AIKAA
            
            
            
            old_cv = cv1_order(i);
            close(previous_fig);
            previous_fig = new_fig;
        end
        close(previous_fig)
    end
    %----------------------------------------------------------------------
    
    % these are needed in the qbu function
    test.current_cv = cv1_order(i);
    test.current_trial = i;
    
    stimuli_index = (cv1_order(i)-1) * setup.cv2 + cv2_order(i);
    close all;
    file_path = [pwd filesep 'images' filesep image_file_names{stimuli_index}];
    data.image_file(i) = {image_file_names{stimuli_index}};
    disp('Current stimulus:')
    disp(data.image_file(i));
    stimulus = display_fullscreen_image(file_path, stimulus_monitor);
    
    % IF REFERENCING
    if setup.referencing_enabled && strcmp(setup.ref_type,'dynamic')
        set(stimulus,'visible','on')
        pause(3);
        
        test.reference_monitor = reference_monitor;
        display_stillACR_references();
        
        test.tStart=tic;
        % path to the qbu settings file
        file_path = [pwd filesep 'setups' filesep setup.name filesep ...
            setup.name '_qbu.fig'];
        ACR_stillqbu('initialize',question_monitor,file_path);
        %------------------------------------------------------------------
    elseif setup.referencing_enabled && strcmp(setup.ref_type,'oneref')
        file_path = [pwd filesep 'images' filesep oneref_images{test.current_cv}];
        fig1 = display_fullscreen_image( file_path,reference1_monitor);
        set(stimulus,'visible','on')
        set(fig1,'visible','on')
        test.tStart=tic;
        % path to the qbu settings file
        file_path = [pwd filesep 'setups' filesep setup.name filesep ...
            setup.name '_qbu.fig'];
        ACR_stillqbu('initialize',question_monitor,file_path);
        %------------------------------------------------------------------
    elseif setup.referencing_enabled && strcmp(setup.ref_type,'tworef')
        file_path = [pwd filesep 'images' filesep tworef_images_1{test.current_cv}];
        fig1 = display_fullscreen_image(file_path,reference1_monitor);
        file_path = [pwd filesep 'images' filesep tworef_images_2{test.current_cv}];
        fig2 = display_fullscreen_image(file_path,reference2_monitor);
        
        set(stimulus,'visible','on')
        set(fig1,'visible','on')
        set(fig2,'visible','on')
        
        test.tStart=tic;
        % path to the qbu settings file
        file_path = [pwd filesep 'setups' filesep setup.name filesep ...
            setup.name '_qbu.fig'];
        ACR_stillqbu('initialize',question_monitor,file_path);
        %------------------------------------------------------------------
    else
        set(stimulus,'visible','on')
        test.tStart=tic;
        % path to the qbu settings file
        file_path = [pwd filesep 'setups' filesep setup.name filesep ...
            setup.name '_qbu.fig'];
        ACR_stillqbu('initialize',question_monitor,file_path);
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
%iptsetpref('ImshowInitialMagnification', 'fit');
% warning('off', 'Images:initSize:adjustingMag'); %turn off warning message due to large image display
warning off; %turn off warning messages
end