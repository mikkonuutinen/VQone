function initExcelSheets()
% Function for initializing the Excel data sheets when creating a new setup.

global setup

% Make directory for the new setup
dir_name = setup.name;
mkdir('setups',dir_name);
setup_file_path = [pwd filesep 'setups' filesep dir_name filesep];
file_path = [setup_file_path setup.name '_data.xls'];
% Make directory for command window log
log_dir_name = 'command_window_logs';
mkdir(['setups' filesep dir_name filesep],log_dir_name);
% Make datafile for practice runs
practice_file_path = [setup_file_path setup.name '_practice_data.xls'];
% Make excel-file for stimuli filenames
filenames_file_path = [setup_file_path 'filenames.xls'];
% Make .mat file for the stimulus vector history
vector_history = [];
save([pwd filesep 'setups' filesep setup.name filesep 'vector_history.mat'],...
    'vector_history')

% Initialize datasheet

%----------------------------------------------------------------------
warning off
% Create status bar obejct
%jFrame = get(gcf,'JavaFrame');
%jRootPane = jFrame.fFigureClient.getWindow;
%statusbarObj = com.mathworks.mwswing.MJStatusBar;

% Add a progress-bar to left side of standard MJStatusBar container
%jProgressBar = javax.swing.JProgressBar;
%set(jProgressBar, 'Minimum',0, 'Maximum',500, 'Value',0);
%statusbarObj.add(jProgressBar,'West');  % 'West' => left of text;

% Set this container as the figure's status-bar
%jRootPane.setStatusBar(statusbarObj);

% Note: setting setStatusBarVisible(1) is not enough to display the status-bar
% - we also need to call setText(), even if only with an empty string ''
%statusbarObj.setText('Opening Excel...');
%jRootPane.setStatusBarVisible(1);
%----------------------------------------------------------------------

% Open the excel server in advance for rapid action
Excel = actxserver ('Excel.Application');
File=file_path;
if ~exist(File,'file')
    ExcelWorkbook = Excel.workbooks.Add;
    ExcelWorkbook.SaveAs(File,1);
    ExcelWorkbook.Close(false);
end
invoke(Excel.Workbooks,'Open',File);

% Disable warnings and pop-ups from excel
Excel.Application.DisplayAlerts = false; % or =0

xlswrite1(file_path,{'Test Number'},'Subject data','A1:A1');
xlswrite1(file_path,{'Subject'},'Subject data','B1:B1');
xlswrite1(file_path,{'Age'},'Subject data','C1:C1');
xlswrite1(file_path,{'Sex'},'Subject data','D1:D1');
xlswrite1(file_path,{'Current Test Number'},'Subject data','H1:H1');
xlswrite1(file_path,1,'Subject data','H2:H2');

% Update status bar
%statusbarObj.setText('Initializing data sheet...');
%set(jProgressBar,'Value',100);

xlswrite1(file_path,{'Standard:'},'Setup information','A1:A1');
xlswrite1(file_path,{setup.standard},'Setup information','B1:B1');
xlswrite1(file_path,{'Version:'},'Setup information','A2:A2');
xlswrite1(file_path,{setup.version},'Setup information','B2:B2');
xlswrite1(file_path,{'Setup name:'},'Setup information','A3:A3');
xlswrite1(file_path,{setup.name},'Setup information','B3:B3');

% Remove the pre-named Sheets 1, 2 and 3
hsheet=Excel.Sheets.Item('Sheet1');
hsheet.Delete
hsheet=Excel.Sheets.Item('Sheet2');
hsheet.Delete
hsheet=Excel.Sheets.Item('Sheet3');
hsheet.Delete

% Shut down the excel server
invoke(Excel.ActiveWorkbook,'Save');
Excel.Quit
Excel.delete
clear Excel

% Update status-bar
%statusbarObj.setText('Initializing practice data sheet...');
%set(jProgressBar,'Value',200);

% Open the excel server in advance for rapid action
Excel = actxserver ('Excel.Application');
File=practice_file_path;
if ~exist(File,'file')
    ExcelWorkbook = Excel.workbooks.Add;
    ExcelWorkbook.SaveAs(File,1);
    ExcelWorkbook.Close(false);
end
invoke(Excel.Workbooks,'Open',File);

% Disable warnings and pop-ups from excel
Excel.Application.DisplayAlerts = false; % or =0

% Initialize practice datasheet
xlswrite1(practice_file_path,{'Test Number'},'Subject data','A1:A1');
xlswrite1(practice_file_path,{'Subject'},'Subject data','B1:B1');
xlswrite1(practice_file_path,{'Age'},'Subject data','C1:C1');
xlswrite1(practice_file_path,{'Sex'},'Subject data','D1:D1');
xlswrite1(practice_file_path,{'Current Test Number'},'Subject data','H1:H1');
xlswrite1(practice_file_path,1,'Subject data','H2:H2');

%update status-bar
%set(jProgressBar,'Value',300);

xlswrite1(practice_file_path,{'Standard:'},'Setup information','A1:A1');
xlswrite1(practice_file_path,{setup.standard},'Setup information','B1:B1');
xlswrite1(practice_file_path,{'Version:'},'Setup information','A2:A2');
xlswrite1(practice_file_path,{setup.version},'Setup information','B2:B2');
xlswrite1(practice_file_path,{'Setup name:'},'Setup information','A3:A3');
xlswrite1(practice_file_path,{setup.name},'Setup information','B3:B3');

% Remove the pre-named Sheets 1, 2 and 3
hsheet=Excel.Sheets.Item('Sheet1');
hsheet.Delete
hsheet=Excel.Sheets.Item('Sheet2');
hsheet.Delete
hsheet=Excel.Sheets.Item('Sheet3');
hsheet.Delete

% Shut down the excel server
invoke(Excel.ActiveWorkbook,'Save');
Excel.Quit
Excel.delete
clear Excel

% Open the excel server in advance for rapid action
Excel = actxserver ('Excel.Application');
File=filenames_file_path;
if ~exist(File,'file')
    ExcelWorkbook = Excel.workbooks.Add;
    ExcelWorkbook.SaveAs(File,1);
    ExcelWorkbook.Close(false);
end
invoke(Excel.Workbooks,'Open',File);

%update status-bar
%statusbarObj.setText('Initializing filenames sheet...');
%set(jProgressBar,'Value',400);

% Initialize filenames datasheet
% Headers
%xlswrite1(filenames_file_path,{'Content'},'A1:A1')
%xlswrite1(filenames_file_path,{'Product'},'B1:B1')
xlswrite1(filenames_file_path,{'CV1'},'A1:A1')
xlswrite1(filenames_file_path,{'CV2'},'B1:B1')
xlswrite1(filenames_file_path,{'Filename'},'C1:C1')
xlswrite1(filenames_file_path,{'CV1 (optional)'},'D1:D1')
xlswrite1(filenames_file_path,{'Reference 1 (optional)'},'E1:E1')
xlswrite1(filenames_file_path,{'Reference 2 (optional)'},'F1:F1')
xlswrite1(filenames_file_path,{'CV1 related questions (optional)'},'G1:G1')
xlswrite1(filenames_file_path,{'Min (optional)'},'H1:H1')
xlswrite1(filenames_file_path,{'Max (optional)'},'I1:I1')

if strcmp(setup.standard,'ACR') || strcmp(setup.standard,'Still PC') || ...
        strcmp(setup.standard,'Still triplet')
    % Example contents
    xlswrite1(filenames_file_path,[1;1;2;2;3;3],'A2:A7')
    xlswrite1(filenames_file_path,[1;2;1;2;1;2],'B2:B7')
    xlswrite1(filenames_file_path,[{'1_1.jpg'};{'1_2.jpg'};{'2_1.jpg'};...
        {'2_2.jpg'};{'3_1.jpg'};{'3_2.jpg'}],'C2:C7')
    xlswrite1(filenames_file_path,[1;2;3],'D2:D4')
    xlswrite1(filenames_file_path,[{'1_1.jpg'};{'2_1.jpg'};{'3_1.jpg'}],'E2:E4')
    xlswrite1(filenames_file_path,[{'1_2.jpg'};{'2_2.jpg'};{'3_2.jpg'}],'F2:F4')
    xlswrite1(filenames_file_path,[{'Question for scene 1'};...
        {'Question for scene 2'};{'Question for scene 3'}],'G2:G4')
    xlswrite1(filenames_file_path,[{'Bad'};{'Very annoying'};{'Blurry'}],'H2:H4')
    xlswrite1(filenames_file_path,[{'Excellent'};{'Imperceptible'};{'Sharp'}],'I2:I4')
else
    % Example contents
    xlswrite1(filenames_file_path,[1;1;2;2],'A2:A5')
    xlswrite1(filenames_file_path,[1;2;1;2],'B2:B5')
    xlswrite1(filenames_file_path,[{'beach.wmv'};{'test.avi'};{'beach.wmv'};...
        {'test.avi'}],'C2:C5')
    xlswrite1(filenames_file_path,[1;2],'D2:D3')
    xlswrite1(filenames_file_path,[{'beach.wmv'};{'beach.wmv'}],'E2:E3')
    xlswrite1(filenames_file_path,[{'test.avi'};{'test.avi'}],'F2:F3')
    xlswrite1(filenames_file_path,[{'Question for scene 1'};...
        {'Question for scene 2'}],'G2:G3')
    xlswrite1(filenames_file_path,[{'Bad'};{'Very annoying'}],'H2:H3')
    xlswrite1(filenames_file_path,[{'Excellent'};{'Imperceptible'}],'I2:I3')
end


% Update status-bar
%statusbarObj.setText('Closing Excel...');
%set(jProgressBar,'Value',500);

% Shut down the excel server
invoke(Excel.ActiveWorkbook,'Save');
Excel.Quit
Excel.delete
clear Excel

end

























