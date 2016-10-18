function initPCCrossTabulationExcel()
% Function for initializing the excel sheets for triplet cross-tabulation
%
% Global variables needed: setup, to get the cv amounts and setup name.

global setup

%------------------------DEBUG
% file_path = [pwd filesep 'setups' filesep 'testi_data.xls'];
% setup.cv1 = 3;
% setup.cv2 = 13;
%------------------------

% Alphabets for excel cell indexing
alphabets = {'a' 'b' 'c' 'd' 'e' 'f' 'g' 'h' 'i' 'j' 'k' 'l' 'm' 'n' 'o' 'p' ...
    'q' 'r' 's' 't' 'u' 'v' 'w' 'x' 'y' 'z' 'aa' 'ab' 'ac' 'ad'};
% Constants
N = setup.cv2;

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
    
    % 2nd submatrix: transpose---------------------------------------------
    cell_to_write = sprintf('%c%d:%c%d', alphabets{1}, 5+N+2, ...
        alphabets{1},5+N+2);
    xlswrite1(file_path,{'TRANSPOSED'},...
        ['Content ' num2str(i) ' matrices'],cell_to_write);
    
    % 3rd submatrix: final-------------------------------------------------
    cell_to_write = sprintf('%c%d:%c%d', alphabets{1}, 5+2*N+5, ...
        alphabets{1},5+2*N+5);
    xlswrite1(file_path,{'FINAL'},...
        ['Content ' num2str(i) ' matrices'],cell_to_write);
    
end

%--------------------------------------------------------------------------
% Shut down the excel server
invoke(Excel.ActiveWorkbook,'Save');
Excel.Quit
Excel.delete
clear Excel

end
















