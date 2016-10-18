function VQone()
% VQone software for creating and running subjective visual quality tests.
%   
%   Syntax:
%   Type 'VQone' to the command prompt to start the program.
%
% Visual Cognition Research Group, University of Helsinki
% (http://www.helsinki.fi/psychology/groups/visualcognition/)
%
% 2012-2014 Mikko Nuutinen (mikko.nuutinen@helsinki.fi)
% 2010-2011 Olli Rummukainen (olli.rummukainen@aalto.fi)

clear all; close all;

global setup

%--------------------------------------------------------------------------

% INITIALIZE THE GUI SECTION
h_figs = get(0,'children');
h_fig = findobj(h_figs,'flat', 'tag','vqone');
if ~isempty(h_fig)
    figure(h_fig(1));
else
    % First initialization
    sel_player = 'WMP'; % Choose VLC or WMP
    
    % Set root level figure properties-------------------------------------
    % Remove menus and titles
    set(0,'DefaultFigureMenu','none','DefaultFigureNumberTitle', 'off');
    % Define new figure open and close request functions for L&F
    set(0,'DefaultFigureCreateFcn',@fig_create)
    set(0,'DefaultFigureCloseRequestFcn',@fig_close)
    
    %----------------------------------------------------------------------
    h_fig = figure('position',[50 50 1200 700], ...
        'name',['VQone ' getVersion], ...
        'tag','vqone');
    
    %h_fig = figure('position',[50 50 600 350], ...
    %    'name',['VQone ' getVersion], ...
    %    'tag','vqone');
    
    
    h_panel1 = uipanel(h_fig, ...
        'title', 'Create Setup', ...
        'Units', 'Normalized', ...
        'Position',[0.1 0.1 0.25 0.55], ...
        'Tag', 'panel1',...
        'fontsize',12,...
        'titleposition','centertop');
    
    set(h_fig,'color',get(h_panel1,'background'))
    
    h_panel2 = uipanel(h_fig, ...
        'title', 'Load Setup', ...
        'Units', 'Normalized', ...
        'Position',[0.4 0.1 0.25 0.55], ...
        'Tag', 'panel2',...
        'fontsize',12,...
        'titleposition','centertop');
    
    h_panel3 = uipanel(h_fig, ...
        'title', 'Analyze Data', ...
        'Units', 'Normalized', ...
        'Position',[0.7 0.1 0.25 0.55], ...
        'Tag', 'panel3',...
        'fontsize',12,...
        'titleposition','centertop');
    
    
    
    % UI controls for panel1----------
    
    uicontrol(h_panel1, ...
        'Style','edit', ...
        'Units', 'normalized', ...
        'Position',[.4 .7 .4 .09], ...
        'CallBack',@setup_name,...
        'tag','textBox1', ...
        'BackgroundColor', 'w',...
        'fontsize',12,...
        'horizontal','left');
        
    uicontrol(h_panel1,...
        'Style','popupmenu', ...
        'units', 'normalized', ...
        'String',{'Select method...',...
        'ACR',...
        'Still PC',...
        'Still triplet',...
        'Video ACR',...
        'Video PC',...
        'Video SSCQE',...
        'Questions only'},...
        'Value',1, ...
        'Position',[0.4 0.5 0.5 0.1],...
        'CallBack',@popup_sel,...
        'tag','popup',...
        'fontsize',12);
    
    uicontrol(h_panel1, ...
        'style','pushbutton', ...
        'Units', 'Normalized', ...
        'position',[0.3 0.2 0.4 0.15],...
        'CallBack',@start_button, ...
        'tag','button', ...
        'string','Create', ...
        'FontSize', 20);
    
        uicontrol(h_panel1, ...
        'Style','text', ...
        'Units', 'normalized', ...
        'Position',[0 0.71 0.35 0.06], ...
        'String','Setup name:', ...
        'FontSize', 12,...
        'horizontal','right');
    
    uicontrol(h_panel1, ...
        'Style','text', ...
        'Units', 'normalized', ...
        'Position',[0 0.53 0.35 0.06], ...
        'String','Test Method:', ...
        'FontSize', 12,...
        'horizontal','right');
    
    
  % UI controls for panel2-------------
    uicontrol(h_panel2, ...
        'style','pushbutton', ...
        'Units', 'Normalized', ...
        'position',[0.3 0.7 0.4 0.09],...
        'CallBack',@select_setup_file,...
        'tag','filebutton', ...
        'string','Select file', ...
        'FontSize', 12);
    
    uicontrol(h_panel2, ...
        'Style','text', ...
        'Units', 'normalized', ...
        'Position',[0.01 0.55 0.99 0.1], ...
        'String','file name', ...
        'FontSize', 12,...
        'tag','file name');
    
    uicontrol(h_panel2, ...
        'style','pushbutton', ...
        'Units', 'Normalized', ...
        'position',[0.27 0.3 0.45 0.15],...
        'CallBack',@startload, ...
        'tag','button2', ...
        'string','Begin test', ...
        'FontSize', 20);
    
    uicontrol(h_panel2,...
        'style','pushbutton', ...
        'Units', 'Normalized', ...
        'position',[0.27 0.12 0.45 0.065],...
        'CallBack',@startmod, ...
        'tag','button3', ...
        'string','Modify setup', ...
        'FontSize', 12);
    
    uicontrol(h_panel2, ...
        'style','pushbutton', ...
        'Units', 'Normalized', ...
        'position',[0.27 0.2 0.45 0.065],...
        'CallBack',@startpractice, ...
        'tag','button2', ...
        'string','Practice run', ...
        'FontSize', 12);
    
    uicontrol(h_panel2,...
        'style','pushbutton', ...
        'Units', 'Normalized', ...
        'position',[0.27 0.04 0.45 0.065],...
        'CallBack',@setup_info, ...
        'tag','setup_info_button', ...
        'string','Setup summary', ...
        'FontSize', 12);
    

    % UI controls for panel3----------
    uicontrol(h_panel3, ...
        'style','pushbutton', ...
        'Units', 'Normalized', ...
        'position',[0.3 0.7 0.4 0.09],...
        'CallBack',@select_setup_file,...
        'tag','filebutton', ...
        'string','Select file', ...
        'FontSize', 12);
    
    uicontrol(h_panel3, ...
        'Style','text', ...
        'Units', 'normalized', ...
        'Position',[0.01 0.55 0.99 0.1], ...
        'String','file name', ...
        'FontSize', 12,...
        'tag','file name');
    
   uicontrol(h_panel3, ...
        'style','pushbutton', ...
        'Units', 'Normalized', ...
        'position',[0.27 0.3 0.45 0.15],...
        'CallBack',@plotdata, ...
        'tag','button2', ...
        'string','Plot Data', ...
        'FontSize', 20);
    
    
    %----------------------------------------------------------------------
    % Version info
    uicontrol(h_fig, ...
        'Style','text', ...
        'Units', 'normalized', ...
        'Position',[0.005 0 0.1 0.03], ...
        'String',['VQone ' getVersion], ...
        'FontSize', 10,...
        'back',get(h_fig,'color'),...
        'horizontal','left');
    
    % Create the VQone logo------------------------------------------------
    Y = rand(20,10);
    area(Y)
    axis off
    set(gca,'position',[0.15 0.68 0.7 0.3])
    set(gca,'Layer','top')
    colormap bone
    
    text('position',[1.1 1.5 0],...
        'string','VQone',...
        'fontsize',30,...
        'color','white',...
        'fontname','fixedwidth')
    
    text('position',[1.1 0.4 0],...
        'String','Visual Cognition Research Group | University of Helsinki',...
        'color','white',...
        'fontsize',10,...
        'fontname','fixedwidth');
    
    
    %----------------------------------------------------------------------
    % Create struct for sbu data
    setup.cv1_locked = 1;
    setup.cv2_locked = 1;
    setup.cv1_random = 0;
    setup.cv2_random = 0;
    setup.dom_enabled = 1;
    setup.dom_value = 1;
    setup.cv1 = [];
    setup.cv2 = [];
    setup.cv1_name = 'contents';
    setup.cv2_name = 'pipes';
    setup.standard = [];
    setup.name = [];
    setup.file_path = [];
    setup.file = [];
    setup.modifying = 0;
    setup.first_time = 0;
    setup.feedback = 0;
    setup.feedback_text = [];
    setup.version = getVersion;
    setup.old_name = [];
    setup.sequences = [];
    setup.pair_repetition = [];
    setup.viewing_time = 0;
    setup.sel_player = sel_player;
    setup.trial_count = [];
    setup.extra_questions = 0;
    setup.time_step = 1;
    setup.practice = 0;
    setup.subject_response_plot_position = [.7832 .15 .2077 .83];
    setup.continuous_subject_response_plot_position = [.01 .01 0.98 .2077];
    setup.max_difference = inf;
    % Referencing
    setup.referencing_enabled = 0;
    setup.dynamic_reference_time = 1;
    setup.ref_random = [];
    setup.ref_exclude_current = [];
    setup.ref_connecting = 'CV2';
    setup.ref_masking = [];
    setup.ref_type = [];
    setup.reference_path = [];
    setup.reference1_path = [];
    setup.reference2_path = [];
    setup.is_masking = [];
    % Monitor information
    setup.left_monitor = 'Disabled';
    setup.center_monitor = 'Disabled';
    setup.right_monitor = 'Disabled';
    setup.bottom_monitor = 'Disabled';
    setup.random_mode = 'serial';
    setup.random_monitors = 0;
    setup.stimuli_in_one_monitor = 0;
    
    
    screens_info(1,:) = [1 560 600 376]; %[1 20 1200 750];
    screens_info(2,:) = [560 560 600 376];
    screens_info(3,:) = [1120 560 600 376];
    screens_info(4,:) = [200 37 700 500];
    
    
    
    setup.screens_info11 = 1;
    setup.screens_info12 = 560;
    setup.screens_info13 = 600;
    setup.screens_info14 = 376;
    
    setup.screens_info21 = 560;
    setup.screens_info22 = 560;
    setup.screens_info23 = 600;
    setup.screens_info24 = 376;
    
    setup.screens_info31 = 1120;
    setup.screens_info32 = 560;
    setup.screens_info33 = 600;
    setup.screens_info34 = 376;
    
    setup.screens_info41 = 200;
    setup.screens_info42 = 37;
    setup.screens_info43 = 700;
    setup.screens_info44 = 500;
    
    
end
end


%--------------------------------------------------------------------------
%%%% CALLBACKS %%%%%%%%%
function popup_sel(source,~)
global setup
str = get(source, 'String');
val = get(source, 'value');

switch str{val};
    case 'ACR'
        setup.standard = 'ACR';              % ACR standard selected
        disp('ACR selected');
    case 'Still PC'
        setup.standard = 'Still PC';          % Still PC standard selected
        disp('Still PC selected');
    case 'Still triplet'                % Still Triplet standard selected
        disp('Still triplet comparison selected');
        setup.standard = 'Still triplet';
    case 'Video ACR'
        disp('Video ACR selected');
        setup.standard = 'Video ACR';
    case 'Video PC'
        disp('Video PC selected');
        setup.standard = 'Video PC';
    case 'Video SSCQE'                  % Video SSCQE standard selected
        disp('Video Single Stimulus Continuous Quality Evaluation Selected');
        setup.standard = 'Video SSCQE';
    case 'Questions only'               % Questions only selected
        disp('Questions only selected');
        setup.standard = 'Questions only';
    otherwise
        disp('Standard not selected')
        setup.standard = '';
end
end

%--------------------------------------------------------------------------
function setup_name(source,~)
global setup
name = get(source,'string');
setup.name = [name '_' setup.version];
disp('Name: '); disp(setup.name);
end

%--------------------------------------------------------------------------
function start_button(~,~)      % Start building setup
global setup

if ~isempty(setup.name) && ~isempty(setup.standard)
    
    % Initialize datasheet
    initExcelSheets()
    
    % Save figure for 'back'- and 'modify'-buttons
    hgsave([pwd filesep 'setups' filesep setup.name filesep 'start_screen.fig']);
    % Get figure position for the next figure
    position = get(gcf,'position');
    
    close all
    
    % Standard specific start-up
    
    % ACR selected---------------------------------------------------------
    if strcmp(setup.standard,'ACR')
        
        createStillACR_sbu('initialize',position);
        disp('Initializing ACR standard')
        
        % Still PC selected------------------------------------------------
    elseif strcmp(setup.standard,'Still PC')
        
        create_stillPC_sbu('initialize',position);
        disp('Initializing Still PC standard');
        
        % Still triplet selected-------------------------------------------
    elseif strcmp(setup.standard,'Still triplet')
        
        createStillTriplet_sbu('initialize',position);
        disp('Initializing Still triplet standard');
        
        % Video SSCQE selected---------------------------------------------
    elseif strcmp(setup.standard,'Video SSCQE')
        
        disp('Initializing Video SSCQE standard');
        createVideoSSCQE_sbu('initialize',position);
        
        % Video ACR selected-----------------------------------------------
    elseif strcmp(setup.standard,'Video ACR')
        
        createVideoACR_sbu('initialize',position);
        disp('Initializing Video ACR standard');
        
        % Video PC selected------------------------------------------------
    elseif strcmp(setup.standard,'Video PC')
        createVideoPC_sbu('initialize',position)
        disp('Initializing Video PC standard.')
        
        % Questions only selected------------------------------------------
    elseif strcmp(setup.standard,'Questions only')
        
        disp('Initializing Questions only standard');
        
        prompt = 'How many trials:';
        dlg_title = 'Trial count';
        num_lines = 1;
        setup.trial_count = inputdlg(prompt,dlg_title,num_lines);
        
        % Must save settings here, because no SBU for this standard
        if isempty(setup.trial_count)
            disp('Choose the number of trials before continuing.')
        else
            close all;
            setup.trial_count = str2double(setup.trial_count{1});
            
            setup_file_path = [pwd filesep 'setups' filesep setup.name filesep];
            save(strcat(setup_file_path,setup.name,'_sbu'),'setup');
            
            setup.modifying = 0;
            QBU('initialize',position);
        end
        
    else
        disp('Select standard and setup name before continuing');
    end
else
    disp('Select standard and setup name before continuing');
end
end


%--------------------------------------------------------------------------
function startpractice(~,~)
global setup
if isempty(setup.file_path)
    disp('Select SBU file before continuing');
    return
end
setup.practice = 1;
close all;
backgroundQuestions('initialize');
end

%--------------------------------------------------------------------------
function select_setup_file(~,~)
global setup

% Find the file info panel's text field
h_setup_file_name = findobj(gcf,'tag','file name');
% Get the path to the setup file
[file, file_path] = uigetfile({'*_sbu.mat'},...
    'Select SBU file',[pwd filesep 'setups' filesep]);
% Set the string in the file info panel
set(h_setup_file_name,'string',file);
if file ~= 0
    % Load the setup settings
    load([file_path file])
    disp('Setup loaded')
    setup.file = file;
    setup.file_path = file_path;
else
    disp('Setup not loaded')
end
end

%--------------------------------------------------------------------------
function startload(~,~)      % Start test
global setup
disp(setup)
if isempty(setup.file_path)
    disp('Select SBU file before continuing');
    return
end

close all;
backgroundQuestions('initialize');
end

%--------------------------------------------------------------------------
function startmod(~,~)      % Start modifying
global setup
if isempty(setup.file_path)
    disp('Select SBU file before continuing');
    return
end

setup.modifying = 1;
setup.first_time = 1;
% Save figure for 'back'- and 'modify'-buttons
hgsave([pwd filesep 'setups' filesep setup.name filesep 'start_screen.fig']);

delete(gcf)
close all;

switch setup.standard
    case 'Questions only'
        % Ask for a new number of trials
        prompt = 'How many trials:';
        dlg_title = 'New trial count';
        old_trial_count = num2str(setup.trial_count);
        num_lines = 1;
        setup.trial_count = inputdlg(prompt,dlg_title,num_lines,...
            {old_trial_count});
        if isempty(setup.trial_count)
            disp('Choose the number of trials before continuing.')
        else
            close all;
            setup.trial_count = str2double(setup.trial_count{1});
            
            setup_file_path = [pwd filesep 'setups' filesep setup.name filesep];
            save(strcat(setup_file_path,setup.name,'_sbu'),'setup');
            
            % Load the QBU figure
            hgload([pwd filesep 'setups' filesep setup.name filesep 'qbu_screen.fig']);
            % Load saved handles
            load([pwd filesep 'setups' filesep setup.name filesep 'qbu_state.mat'])
            guidata(gcf,qbu_state);
        end
    otherwise
        % Load the figure
        hgload([pwd filesep 'setups' filesep setup.name filesep 'sbu_screen.fig']);
        % Load saved handles
        load([pwd filesep 'setups' filesep setup.name filesep 'sbu_state.mat'])
        guidata(gcf,sbu_state);
end
end



function fig_create(~,~)
% set metallic l&f
newLnF = 'javax.swing.plaf.metal.MetalLookAndFeel';
javax.swing.UIManager.setLookAndFeel(newLnF);
end

function fig_close(~,~)
% return to windows l&f
newLnF = 'com.sun.java.swing.plaf.windows.WindowsLookAndFeel';
javax.swing.UIManager.setLookAndFeel(newLnF);
closereq
end

function setup_info(~,~)
global setup

if isempty(setup.file_path) == 1
    disp('Select SBU file first');
    return
end

disp(setup)
end


%--------------------------------------------------------------------------
function plotdata(~,~)              % Plot data
global setup

if ~isempty(setup.name) && ~isempty(setup.standard)
% Standard specific start-up
    
    % ACR selected---------------------------------------------------------
    if strcmp(setup.standard,'ACR')
        disp('ACR selected')
        analyzeStillACR()
        
        
        % Still PC selected------------------------------------------------
    elseif strcmp(setup.standard,'Still PC')
        disp('Still PC selected')
        analyzeStillPC()
        
        % Still triplet selected-------------------------------------------
    elseif strcmp(setup.standard,'Still triplet')
        disp('Still triplet selected')
        analyzeStillTriplet()
        
        % Video SSCQE selected---------------------------------------------
    elseif strcmp(setup.standard,'Video SSCQE')
        disp('Video SSCQE selected')

        
        % Video ACR selected-----------------------------------------------
    elseif strcmp(setup.standard,'Video ACR')
        disp('Video ACR selected')
        analyzeVideoACR()

        % Video PC selected------------------------------------------------
    elseif strcmp(setup.standard,'Video PC')
        disp('Video PC selected')
        analyzeVideoPC()
        
        % Questions only selected------------------------------------------
    elseif strcmp(setup.standard,'Questions only')
        disp('Questions only selected')
    else
        disp('Select standard and setup name before continuing');
    end
else
    disp('Select standard and setup name before continuing');
end
end
