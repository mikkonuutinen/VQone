function initCrossTabulationExcel()
% Function for initializing the excel sheets for triplet cross-tabulation
%
% Global variables needed: setup, to get the cv amounts and setup name.

global setup

%------------------------
% file_path = [pwd filesep 'setups' filesep 'testi_data.xls'];
% setup.cv1 = 3;
% setup.cv2 = 13;
%------------------------

% Alphabets for excel cell indexing
alphabets = {'a' 'b' 'c' 'd' 'e' 'f' 'g' 'h' 'i' 'j' 'k' 'l' 'm' 'n' 'o' 'p' ...
    'q' 'r' 's' 't' 'u' 'v' 'w' 'x' 'y' 'z' 'aa' 'ab' 'ac' 'ad'};
% Constants
N = setup.cv2;

%----------------------------------------------------------------------
warning off
% Create status bar object
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

%--------------------------------------------------------------------------
% Create the cross tabulation sheets
file_path = [pwd filesep 'setups' filesep setup.name filesep setup.name '_data.xls'];
% Open the excel server in advance for rapid action
Excel = actxserver ('Excel.Application');
File=file_path;
if ~exist(File,'file')
    ExcelWorkbook = Excel.workbooks.Add;
    ExcelWorkbook.SaveAs(File,1);
    ExcelWorkbook.Close(false);
end
invoke(Excel.Workbooks,'Open',File);

% Update status bar
%statusbarObj.setText('Initializing crosstab sheets...');
%set(jProgressBar,'Value',200);

%-----------------------------------
for i = 1 : setup.cv1
    % 1st Sub matrix ------------------------------------------------------
    % header
    cell_to_write = sprintf('%c%d:%c%d', alphabets{1}, 1, ...
        alphabets{1},1);
    xlswrite1(file_path,{'order1 * order2 Crosstabulation'},...
        ['Content ' num2str(i) ' matrices'],cell_to_write);

    % Order headers
    cell_to_write = sprintf('%c%d:%c%d', alphabets{1}, 5, ...
        alphabets{1},5);
    xlswrite1(file_path,{'Rank 1'},...
        ['Content ' num2str(i) ' matrices'],cell_to_write);
    cell_to_write = sprintf('%c%d:%c%d', alphabets{3}, 3, ...
        alphabets{3},3);
    xlswrite1(file_path,{'Rank 2'},...
        ['Content ' num2str(i) ' matrices'],cell_to_write);
    
    % CV2 indices
    indices = 1:N;
    cell_to_write = sprintf('%c%d:%c%d', alphabets{3}, 4, ...
        alphabets{3+N-1},4);
    xlswrite1(file_path,indices,...
        ['Content ' num2str(i) ' matrices'],cell_to_write);
    cell_to_write = sprintf('%c%d:%c%d', alphabets{2}, 5, ...
        alphabets{2},5+N-1);
    xlswrite1(file_path,indices',...
        ['Content ' num2str(i) ' matrices'],cell_to_write);
    
    % Total texts
    cell_to_write = sprintf('%c%d:%c%d', alphabets{3+N}, 3, ...
        alphabets{3+N},3);
    xlswrite1(file_path,{'Total'},...
        ['Content ' num2str(i) ' matrices'],cell_to_write);
    cell_to_write = sprintf('%c%d:%c%d', alphabets{1}, 5+N, ...
        alphabets{1},5+N);
    xlswrite1(file_path,{'Total'},...
        ['Content ' num2str(i) ' matrices'],cell_to_write);
    
    % 2nd sub matrix-------------------------------------------------------
    % header
    cell_to_write = sprintf('%c%d:%c%d', alphabets{1}, 5+N+4, ...
        alphabets{1},5+N+4);
    xlswrite1(file_path,{'order2 * order3 Crosstabulation'},...
        ['Content ' num2str(i) ' matrices'],cell_to_write);
    
    % Order headers
    cell_to_write = sprintf('%c%d:%c%d', alphabets{1}, 5+N+8, ...
        alphabets{1},5+N+8);
    xlswrite1(file_path,{'Rank 2'},...
        ['Content ' num2str(i) ' matrices'],cell_to_write);
    cell_to_write = sprintf('%c%d:%c%d', alphabets{3}, 5+N+6, ...
        alphabets{3},5+N+6);
    xlswrite1(file_path,{'Rank 3'},...
        ['Content ' num2str(i) ' matrices'],cell_to_write);
    
    % CV2 indices
    cell_to_write = sprintf('%c%d:%c%d', alphabets{3}, 4+N+8, ...
        alphabets{3+N-1},4+N+8);
    xlswrite1(file_path,indices,...
        ['Content ' num2str(i) ' matrices'],cell_to_write);
    cell_to_write = sprintf('%c%d:%c%d', alphabets{2}, 5+N+8, ...
        alphabets{2},5+2*N+7);
    xlswrite1(file_path,indices',...
        ['Content ' num2str(i) ' matrices'],cell_to_write);
    
    % Total texts
    cell_to_write = sprintf('%c%d:%c%d', alphabets{3+N}, 5+N+6, ...
        alphabets{3+N},5+N+6);
    xlswrite1(file_path,{'Total'},...
        ['Content ' num2str(i) ' matrices'],cell_to_write);
    cell_to_write = sprintf('%c%d:%c%d', alphabets{1}, 5+2*N+8, ...
        alphabets{1},5+2*N+8);
    xlswrite1(file_path,{'Total'},...
        ['Content ' num2str(i) ' matrices'],cell_to_write);
    
    % 3rd sub matrix-------------------------------------------------------
    % header
    cell_to_write = sprintf('%c%d:%c%d', alphabets{1}, 5+2*N+12, ...
        alphabets{1},5+2*N+12);
    xlswrite1(file_path,{'order1 * order3 Crosstabulation'},...
        ['Content ' num2str(i) ' matrices'],cell_to_write);
    
    % Order headers
    cell_to_write = sprintf('%c%d:%c%d', alphabets{1}, 5+2*N+16, ...
        alphabets{1},5+2*N+16);
    xlswrite1(file_path,{'Rank 1'},...
        ['Content ' num2str(i) ' matrices'],cell_to_write);
    cell_to_write = sprintf('%c%d:%c%d', alphabets{3}, 5+2*N+14, ...
        alphabets{3},5+2*N+14);
    xlswrite1(file_path,{'Rank 3'},...
        ['Content ' num2str(i) ' matrices'],cell_to_write);
    % CV2 indices
    cell_to_write = sprintf('%c%d:%c%d', alphabets{3}, 5+2*N+15, ...
        alphabets{3+N-1},5+2*N+15);
    xlswrite1(file_path,indices,...
        ['Content ' num2str(i) ' matrices'],cell_to_write);
    cell_to_write = sprintf('%c%d:%c%d', alphabets{2},5+2*N+16, ...
        alphabets{2},5+3*N+15);
    xlswrite1(file_path,indices',...
        ['Content ' num2str(i) ' matrices'],cell_to_write);
    
    % Total texts
    cell_to_write = sprintf('%c%d:%c%d', alphabets{3+N}, 5+2*N+14, ...
        alphabets{3+N}, 5+2*N+14);
    xlswrite1(file_path,{'Total'},...
        ['Content ' num2str(i) ' matrices'],cell_to_write);
    cell_to_write = sprintf('%c%d:%c%d', alphabets{1}, 5+3*N+16, ...
        alphabets{1},5+3*N+16);
    xlswrite1(file_path,{'Total'},...
        ['Content ' num2str(i) ' matrices'],cell_to_write);
    
    % 4th submatrix: paste add---------------------------------------------
    cell_to_write = sprintf('%c%d:%c%d', alphabets{1}, 5+3*N+19, ...
        alphabets{1}, 5+3*N+19);
    xlswrite1(file_path,{'PASTE ADD'},...
        ['Content ' num2str(i) ' matrices'],cell_to_write);
    
    % 5th submatrix: transpose---------------------------------------------
    cell_to_write = sprintf('%c%d:%c%d', alphabets{1}, 5+4*N+22, ...
        alphabets{1}, 5+4*N+22);
    xlswrite1(file_path,{'TRANSPOSED'},...
        ['Content ' num2str(i) ' matrices'],cell_to_write);
    
    % 6th submatrix: final-------------------------------------------------
    cell_to_write = sprintf('%c%d:%c%d', alphabets{1}, 5+5*N+25, ...
        alphabets{1}, 5+5*N+25);
    xlswrite1(file_path,{'FINAL'},...
        ['Content ' num2str(i) ' matrices'],cell_to_write);
    
end

% Update status bar
%statusbarObj.setText('Closing Excel...');
%set(jProgressBar,'Value',400);

%--------------------------------------------------------------------------
% Shut down the excel server
invoke(Excel.ActiveWorkbook,'Save');
Excel.Quit
Excel.delete
clear Excel

% Update status bar
%statusbarObj.setText('Done.');
%set(jProgressBar,'Value',500);

end
















