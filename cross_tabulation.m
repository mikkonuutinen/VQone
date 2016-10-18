function cross_tabulation(data)
global setup

% setup.cv2 = 3;
% setup.cv1 = 2;

% Number of combinations for each content
N = setup.cv2 * (setup.cv2 - 1) / 6;

% Load the crosstabulation history
load([pwd filesep 'setups' filesep setup.name filesep 'crosstabulation.mat'])

idx = 1;
for i = 1 : 3 : length(data.rank1)
    full_rank1(idx) = data.order1(i);
    full_rank2(idx) = data.order2(i);
    full_rank3(idx) = data.order3(i);
    idx = idx + 1;
end

idx = 1;
for i = 1 : N : length(full_rank1)
    content(idx) = data.cv1_1_order((i-1)*3+1);
    idx = idx + 1;
end

contents = 1;
for content_index = 1 : N : length(full_rank1)
    % Choose the contentwise ranks only
    rank1 = full_rank1(content_index : content_index + N - 1);
    rank2 = full_rank2(content_index : content_index + N - 1);
    rank3 = full_rank3(content_index : content_index + N - 1);
        
    % Initialize the cross tabulation matrices
    crosstabs1vs2 = zeros(setup.cv2);
    crosstabs1vs3 = zeros(setup.cv2);
    crosstabs2vs3 = zeros(setup.cv2);
    
    % Count the cross tabs
    for i = 1 : length(rank1)
        crosstabs1vs2(rank1(i),rank2(i)) = crosstabs1vs2(rank1(i),rank2(i)) + 1;
        crosstabs1vs3(rank1(i),rank3(i)) = crosstabs1vs3(rank1(i),rank3(i)) + 1;
        crosstabs2vs3(rank2(i),rank3(i)) = crosstabs2vs3(rank2(i),rank3(i)) + 1;
    end
    
    crosstab_paste = crosstabs1vs2 + crosstabs1vs3 + crosstabs2vs3;
    
%     disp(crosstabs1vs2)
%     disp(crosstabs1vs3)
%     disp(crosstabs2vs3)
%     disp(crosstab_paste)

    % Update crosstabulation history 
    crosstabulation(content(contents)).crosstabs1vs2 = ...
        crosstabulation(content(contents)).crosstabs1vs2 + crosstabs1vs2;
    crosstabulation(content(contents)).crosstabs1vs3 = ...
        crosstabulation(content(contents)).crosstabs1vs3 + crosstabs1vs3;
    crosstabulation(content(contents)).crosstabs2vs3 = ...
        crosstabulation(content(contents)).crosstabs2vs3 + crosstabs2vs3;
    crosstabulation(content(contents)).crosstabs_paste = ...
        crosstabulation(content(contents)).crosstabs_paste + crosstab_paste;
    
    % Calculate the row and column sums
    % First columns:
    crosstabulation(content(contents)).crosstabs1vs2(setup.cv2+1,:) = ...
        sum(crosstabulation(content(contents)).crosstabs1vs2);
    crosstabulation(content(contents)).crosstabs1vs3(setup.cv2+1,:) = ...
        sum(crosstabulation(content(contents)).crosstabs1vs3);
    crosstabulation(content(contents)).crosstabs2vs3(setup.cv2+1,:) = ...
        sum(crosstabulation(content(contents)).crosstabs2vs3);
    
    % Then rows:
    crosstabulation(content(contents)).crosstabs1vs2(:,setup.cv2+1) = ...
        sum(crosstabulation(content(contents)).crosstabs1vs2,2);
    crosstabulation(content(contents)).crosstabs1vs3(:,setup.cv2+1) = ...
        sum(crosstabulation(content(contents)).crosstabs1vs3,2);
    crosstabulation(content(contents)).crosstabs2vs3(:,setup.cv2+1) = ...
        sum(crosstabulation(content(contents)).crosstabs2vs3,2);

    contents = contents + 1;
    
end

% Write the crosstabulation data to excel
file_path = [pwd filesep 'setups' filesep setup.name filesep setup.name '_data.xls'];
%file_path = [pwd filesep 'setups' filesep 'test_data.xls'];
% Open the excel server in advance for rapid action
Excel = actxserver ('Excel.Application');
File=file_path;
if ~exist(File,'file')
    ExcelWorkbook = Excel.workbooks.Add;
    ExcelWorkbook.SaveAs(File,1);
    ExcelWorkbook.Close(false);
end
invoke(Excel.Workbooks,'Open',File);
%--------------------------------------------------------------------------
N = setup.cv2;
for i = 1 : setup.cv1
    % 1st sub-matrix 1vs2
    cell_to_write = sprintf('%c%d','c',5);
    xlswrite1(file_path,crosstabulation(i).crosstabs1vs2,...
        ['Content ' num2str(i) ' matrices'],cell_to_write);
    
    % 2nd sub-matrix 2vs3
    cell_to_write = sprintf('%c%d','c',5+N+8);
    xlswrite1(file_path,crosstabulation(i).crosstabs2vs3,...
        ['Content ' num2str(i) ' matrices'],cell_to_write);
    
    % 3rd sub-matrix 1vs3
    cell_to_write = sprintf('%c%d','c',5+2*N+16);
    xlswrite1(file_path,crosstabulation(i).crosstabs1vs3,...
        ['Content ' num2str(i) ' matrices'],cell_to_write);
    
    % 4th sub-matrix paste-add
    cell_to_write = sprintf('%c%d','c',5+3*N+20);
    xlswrite1(file_path,crosstabulation(i).crosstabs_paste,...
        ['Content ' num2str(i) ' matrices'],cell_to_write);
    
    % 5th sub-matrix transposed
    cell_to_write = sprintf('%c%d','c',5+4*N+23);
    xlswrite1(file_path,crosstabulation(i).crosstabs_paste',...
        ['Content ' num2str(i) ' matrices'],cell_to_write);
    
    % 6th sub-matrix reduced
    cell_to_write = sprintf('%c%d','c',5+5*N+26);
    xlswrite1(file_path,(crosstabulation(i).crosstabs_paste - ...
        crosstabulation(i).crosstabs_paste'),...
        ['Content ' num2str(i) ' matrices'],cell_to_write);
    
    % Remove the sum rows and columns
    crosstabulation(i).crosstabs1vs2 = ...
        crosstabulation(i).crosstabs1vs2(1:setup.cv2,1:setup.cv2);
    crosstabulation(i).crosstabs1vs3 = ...
        crosstabulation(i).crosstabs1vs3(1:setup.cv2,1:setup.cv2);
    crosstabulation(i).crosstabs2vs3 = ...
        crosstabulation(i).crosstabs2vs3(1:setup.cv2,1:setup.cv2);
    
end
%--------------------------------------------------------------------------
% Shut down the excel server
invoke(Excel.ActiveWorkbook,'Save');
Excel.Quit
Excel.delete
clear Excel

% Save the updated crosstabulation history
save([pwd filesep 'setups' filesep setup.name filesep 'crosstabulation.mat'],...
    'crosstabulation')

end
















