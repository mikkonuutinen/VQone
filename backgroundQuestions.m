function backgroundQuestions(command_str)
% Opens the question figure for background information

% Evaluation number needed in QBU to save the data
global evaluation_number test setup

%Generate a random seed based on the clock
stream = RandStream('mt19937ar','seed',sum(100*clock));
%Make this random seed as the default for random no. generators
RandStream.setGlobalStream(stream);

if nargin == 0
    command_str = 'initialize';
end
if ~strcmp(command_str,'initialize')
    % RETRIEVE HANDLES AND REDEFINE THE HANDLE VARIABLES.
    % Assume that the current figure contains the backgroundQuestions.
    h_fig = gcf;
    if ~strcmp(get(h_fig,'tag'),'backgroundQuestions')
        % If the current figure does not have the right tag, find the one that does.
        h_figs = get(0,'children');
        h_fig = findobj(h_figs,'flat', 'tag','backgroundQuestions');
        
        if isempty(h_fig)
            % If the fun_plt2 GUI does not exist initialize it. Then run the command string
            % that was originally requested.
            backgroundQuestions('initialize'); %first initialize
            backgroundQuestions(command_str); %then rin the required command
            return;
        end
    end
end
disp(setup)
% INITIALIZE THE GUI SECTION.
if strcmp(command_str,'initialize')
    
    if setup.practice == 0;
        test.file_path = [pwd filesep 'setups' filesep setup.name filesep ...
            setup.name '_data.xls'];
        test.practice = 0;
    else
        test.file_path = [pwd filesep 'setups' filesep setup.name filesep ...
            setup.name '_practice_data.xls'];
        test.practice = 1;
    end
    
    test.test_index = xlsread(test.file_path, 'Subject data', 'H2:H2');
    
    % Make sure that the GUI has not been already initialized in another existing figure.
    % NOTE THAT THIS GUI INSTANCE CHECK IS NOT REQUIRED, UNLESS YOU WANT TO INSURE THAT ONLY
    % ONE INSTANCE OF THE GUI IS CREATED!
    h_figs = get(0,'children');
    h_fig = findobj(h_figs,'flat', 'tag','backgroundQuestions');
    if ~isempty(h_fig)
        figure(h_fig(1));
        return
    end
    
    set(0,'DefaultFigureMenu','none', ...
        'DefaultFigureNumberTitle', 'off');
    
    screens_info = get(0,'MonitorPosition');
    
    % If the program is run at the triplets
    if length(screens_info(:,1)) == 4
        position = [1 1 200 100]; % For real use
    else
        position = [1 1 1200 600];
        %position = screens_info(1,:); % for debugging
    end
    
    h_fig = figure('position', position, ...
        'name','Background Questions', ...
        'tag','backgroundQuestions', ...
        'menu', 'none');
    
    % Create the edit box for text data entry.
    uicontrol(h_fig, 'Style','text',...
        'units','normalized', ...
        'Position',[0.4 0.7 0.1 0.06], ...
        'String','Name:', ...
        'HorizontalAlignment', 'left', ...
        'FontSize', 12,...
        'back',get(h_fig,'color'));
    
    uicontrol(h_fig, 'Style','edit', ...
        'units','normalized', ...
        'Position',[0.4 0.695 0.2 0.035], ...
        'CallBack',@name_box,...
        'tag','nameBox', ...
        'HorizontalAlignment', 'left', ...
        'BackgroundColor', 'w',...
        'fontsize',12);
    
    uicontrol(h_fig, 'Style','text', ...
        'units','normalized', ...
        'Position',[0.4 0.6 0.05 0.06], ...
        'String','Age:', ...
        'HorizontalAlignment', 'left', ...
        'FontSize', 12,...
        'back',get(h_fig,'color'));
    
    uicontrol(h_fig, 'Style','edit', ...
        'units','normalized', ...
        'Position',[0.4 0.595 0.05 0.035], ...
        'CallBack',@age_box,...
        'tag','ageBox', ...
        'HorizontalAlignment', 'left',...
        'BackgroundColor', 'w',...
        'fontsize',12);
    
    % Create the set of two Radio buttons.
    sex_panel = uipanel(h_fig,...
        'units','normalized', ...
        'Position',[0.4 0.4 0.2 0.15], ...
        'title','Gender', ...
        'FontSize', 12,...
        'back',get(h_fig,'color'));
    
    uicontrol(sex_panel, 'style','radio',...
        'units','normalized', ...
        'position',[0.1 0.67 0.4 0.2], ...
        'callback',@male_button,...
        'tag','male', ...
        'string','Male',...
        'fontsize',12,...
        'back',get(h_fig,'color'));
    
    uicontrol(sex_panel, 'style','radio', ...
        'units','normalized', ...
        'position',[0.1 0.27 0.5 0.2], ...
        'callback',@female_button,...
        'tag','female', ...
        'string','Female',...
        'fontsize',12,...
        'back',get(h_fig,'color'));
    
    uicontrol(h_fig, 'style','pushbutton', ...
        'units','normalized', ...
        'position',[0.35 0.1 0.3 0.05], ...
        'CallBack','backgroundQuestions(''Start Experiment'');',...
        'tag','startExperiment', ...
        'string','Start experiment', ...
        'FontSize', 14);
  
    % Set focus for the name box
    setfocus(findobj(h_fig,'tag','nameBox'));
    
    
    % CALLBACK FOR THE Push Button.----------------------------------------
elseif strcmp(command_str,'Start Experiment')
    disp('Start Button Pressed');
    % Check inputs
    if ~isfield(test,'sex')
        disp('Sex information missing.')
        return
    end
    if ~isfield(test,'age')
        disp('Age information missing.')
        return
    end
    if ~isfield(test,'subject')
        disp('Subject name missing.')
        return
    end
    % Write subject information
    % Open the excel server in advance for rapid action
    Excel = actxserver ('Excel.Application');
    File=test.file_path;
    if ~exist(File,'file')
        ExcelWorkbook = Excel.workbooks.Add;
        ExcelWorkbook.SaveAs(File,1);
        ExcelWorkbook.Close(false);
    end
    invoke(Excel.Workbooks,'Open',File);
    
    cell_to_write = sprintf('A%d:A%d', test.test_index+1, test.test_index+1);
    xlswrite1( test.file_path, test.test_index, 'Subject data', cell_to_write);
    % sex
    cell_to_write = sprintf('D%d:D%d', test.test_index+1, test.test_index+1);
    xlswrite1( test.file_path,{test.sex},'Subject data',cell_to_write);
    % age
    cell_to_write = sprintf('C%d:C%d', test.test_index+1, test.test_index+1);
    xlswrite1( test.file_path,{test.age},'Subject data', cell_to_write);
    % name
    cell_to_write = sprintf('B%d:B%d', test.test_index+1, test.test_index+1);
    xlswrite1( test.file_path, {test.subject}, 'Subject data', cell_to_write);
    
    % New test index
    xlswrite1( test.file_path, test.test_index+1, 'Subject data', 'H2:H2');
    
    % Shut down the excel server
    invoke(Excel.ActiveWorkbook,'Save');
    Excel.Quit
    Excel.delete
    clear Excel
    
    % Begin logging command window
    log_path = [pwd filesep 'setups' filesep setup.name filesep ...
        'command_window_logs' filesep date '_' test.subject '.txt'];
    diary(log_path)
    diary on
    
    close;
    
    if strcmp(setup.standard,'ACR')
        close all;
        evaluation_number = 1;
        ACR_sbu()
    elseif strcmp(setup.standard,'Still PC')
        close all;
        evaluation_number = 1;
        stillPC_sbu()
    elseif strcmp(setup.standard,'Video PC')
        close all;
        evaluation_number = 1;
        % Same SBU function as with Still PC
        stillPC_sbu()
    elseif strcmp(setup.standard,'Still triplet')
        close all;
        evaluation_number = 1;
        stillTriplet_sbu()
    elseif strcmp(setup.standard,'Video SSCQE')
        close all;
        evaluation_number = 1;
        videoSSCQE_sbu()
    elseif strcmp(setup.standard,'Video ACR')
        close all;
        evaluation_number = 1;
        videoACR_sbu()
    elseif strcmp(setup.standard,'Questions only')
        close all;
        file_path = [pwd filesep 'setups' filesep setup.name filesep ...
            'settings_sbu.mat'];
        evaluation_number = 1;
        questionsOnly_sbu()
    else
        disp('SBU file not selected');
    end
    
end
end

% CALLBACKS----------------------------------------------------------------
function male_button(source,~)
global test
test.sex = 'male';
disp(['Sex: ' test.sex])
set(findobj(gcf,'tag','female'),'value',abs(get(source,'value')-1))
end

function female_button(source,~)
global test
test.sex = 'female';
disp(['Sex: ' test.sex])
set(findobj(gcf,'tag','male'),'value',abs(get(source,'value')-1))
end

function age_box(source,~)
global test
test.age = get(source,'string');
disp(['Age: ' test.age])
end

function name_box(source,~)
global test
test.subject = get(source,'string');
disp(['Subject: ' test.subject])
end


















