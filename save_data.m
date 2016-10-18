function save_data()
% Function that saves the subject input data and test data after a test.
%
% Global variables needed:
%   - data: the data to be saved is read from here
%   - test: data about the test is read from here
%   - setup: data about the test and subject is read from here
%   - continuous_data: if continuous standard is used, the data is read
%       from here

global data test setup continuous_data

% For still acr, check similarity
if strcmp(setup.standard,'ACR')
    % Display stimulus vector similarity report
    disp(test.sim_report)
    disp('Similar vectors found from test numbers:')
    disp(test.sim_pos')
end

% Change the standard to ACR for Video ACR and Video SSCQE because the
% data is saved in a similar fashion in these standards
if strcmp(setup.standard,'Video ACR') || strcmp(setup.standard,'Video SSCQE')
    setup.standard = 'ACR';
end

% Change Video PC standard to Still PC, because the data is saved similarly
if strcmp(setup.standard,'Video PC')
    setup.standard = 'Still PC';
end

% Make the cross tabulation for rank data if present
if strcmp(setup.standard,'Still triplet') && isfield(data,'rank1')
    disp('Writing cross-tabulations...')
    cross_tabulation(data)
    disp('Done.')
elseif strcmp(setup.standard,'Still PC') && isfield(data,'rank1')
    disp('Writing cross-tabulations...')
    PC_cross_tabulation(data)
    disp('Done.')
end

% Alphabets for excel cell indexing
alphabets = {'a' 'b' 'c' 'd' 'e' 'f' 'g' 'h' 'i' 'j' 'k' 'l' 'm' 'n' 'o' 'p' ...
    'q' 'r' 's' 't' 'u' 'v' 'w' 'x' 'y' 'z' 'aa' 'ab' 'ac' 'ad'};

% Choose file path
if test.practice == 0;
    file_path = [pwd filesep 'setups' filesep setup.name filesep setup.name ...
        '_data.xls'];
else
    file_path = [pwd filesep 'setups' filesep setup.name filesep setup.name ...
        '_practice_data.xls'];
end

subject_index = (test.test_index) * length(data.subject) - (length(data.subject)-2);
triplet_subject_index = (test.test_index) * (length(data.subject)/3) - ...
    (length(data.subject)/3 - 2);

% Open the excel server in advance for rapid action
Excel = actxserver ('Excel.Application');
File=file_path;
if ~exist(File,'file')
    ExcelWorkbook = Excel.workbooks.Add;
    ExcelWorkbook.SaveAs(File,1);
    ExcelWorkbook.Close(false);
end
invoke(Excel.Workbooks,'Open',File);

% Write evaluation number
cell_to_write = sprintf('%c%d:%c%d', alphabets{1}, 1, ...
    alphabets{1},1);
xlswrite1(file_path,{'Evaluation number'},'Test data',cell_to_write)

number_of_tests = length(data.evaluation_number);
running_number = subject_index : subject_index+number_of_tests-1;
triplet_running_number = triplet_subject_index : triplet_subject_index+number_of_tests-1;
first_index = running_number(1);
last_index = running_number(number_of_tests);
% Modify running number when using triplet or pc
if strcmp(setup.standard,'Still triplet')
    trial_count = number_of_tests / 3;
    for i = 1 : trial_count
        tmp_running_number(3*(i-1)+1:3*(i-1)+3) = triplet_running_number(i);
    end
    running_number = tmp_running_number;
end

cell_to_write = sprintf('%c%d:%c%d',alphabets{1},first_index, ...
    alphabets{1},last_index);
xlswrite1(file_path,running_number(:)-1,'Test data',cell_to_write)

% Write trial index
cell_to_write = sprintf('%c%d:%c%d', alphabets{2}, 1, ...
    alphabets{2},1);
xlswrite1(file_path,{'Trial index'},'Test data',cell_to_write)
for j = subject_index : subject_index+number_of_tests-1
    cell_to_write = sprintf('%s%d:%s%d', alphabets{2}, j,...
        alphabets{2}, j);
    
    input = data.evaluation_number(j-subject_index+1);
    xlswrite1(file_path,input,'Test data',cell_to_write);
end
data = rmfield(data, 'evaluation_number');

%--------------------------------------------------------------------------
% First write cv information and subject name
% CV 1
if strcmp(setup.standard,'ACR') == 1
    cell_to_write = sprintf('%c%d:%c%d', alphabets{3}, 1, ...
        alphabets{3},1);
    xlswrite1(file_path,{'CV 1'},'Test data',cell_to_write)
    for j = subject_index : subject_index+number_of_tests-1
        cell_to_write = sprintf('%s%d:%s%d', alphabets{3}, j,...
            alphabets{3}, j);
        
        input = data.cv1_order(j-subject_index+1);
        xlswrite1(file_path,input,'Test data',cell_to_write);
    end
    data = rmfield(data, 'cv1_order');
    %----------------------------------------------------------------------
    % Stille PC
elseif strcmp(setup.standard,'Still PC') == 1
    cell_to_write = sprintf('%c%d:%c%d', alphabets{3}, 1, ...
        alphabets{3},1);
    xlswrite1(file_path,{'CV 1_1'},'Test data',cell_to_write)
    for j = subject_index : subject_index+number_of_tests-1
        cell_to_write = sprintf('%s%d:%s%d', alphabets{3}, j,...
            alphabets{3}, j);
        
        input = data.cv1_1_order(j-subject_index+1);
        xlswrite1(file_path,input,'Test data',cell_to_write);
    end
    data = rmfield(data, 'cv1_1_order');
    %-----------------
    cell_to_write = sprintf('%c%d:%c%d', alphabets{5}, 1, ...
        alphabets{5},1);
    xlswrite1(file_path,{'CV 1_2'},'Test data',cell_to_write)
    for j = subject_index : subject_index+number_of_tests-1
        cell_to_write = sprintf('%s%d:%s%d', alphabets{5}, j,...
            alphabets{5}, j);
        
        input = data.cv1_2_order(j-subject_index+1);
        xlswrite1(file_path,input,'Test data',cell_to_write);
    end
    data = rmfield(data, 'cv1_2_order');
    %----------------------------------------------------------------------
    % Still triplet
elseif strcmp(setup.standard,'Still triplet') == 1
    cell_to_write = sprintf('%c%d:%c%d', alphabets{3}, 1, ...
        alphabets{3},1);
    xlswrite1(file_path,{'CV 1_1'},'Test data',cell_to_write)
    for j = subject_index : subject_index+number_of_tests-1
        cell_to_write = sprintf('%s%d:%s%d', alphabets{3}, j,...
            alphabets{3}, j);
        
        input = data.cv1_1_order(j-subject_index+1);
        xlswrite1(file_path,input,'Test data',cell_to_write);
    end
    data = rmfield(data, 'cv1_1_order');
    %-----------------
    cell_to_write = sprintf('%c%d:%c%d', alphabets{5}, 1, ...
        alphabets{5},1);
    xlswrite1(file_path,{'CV 1_2'},'Test data',cell_to_write)
    for j = subject_index : subject_index+number_of_tests-1
        cell_to_write = sprintf('%s%d:%s%d', alphabets{5}, j,...
            alphabets{5}, j);
        
        input = data.cv1_2_order(j-subject_index+1);
        xlswrite1(file_path,input,'Test data',cell_to_write);
    end
    data = rmfield(data, 'cv1_2_order');
    %-----------------
    cell_to_write = sprintf('%c%d:%c%d', alphabets{7}, 1, ...
        alphabets{7},1);
    xlswrite1(file_path,{'CV 1_3'},'Test data',cell_to_write)
    for j = subject_index : subject_index+number_of_tests-1
        cell_to_write = sprintf('%s%d:%s%d', alphabets{7}, j,...
            alphabets{7}, j);
        
        input = data.cv1_3_order(j-subject_index+1);
        xlswrite1(file_path,input,'Test data',cell_to_write);
    end
    data = rmfield(data, 'cv1_3_order');
end
%--------------------------------------------------------------------------
% CV 2
if strcmp(setup.standard,'ACR') == 1
    cell_to_write = sprintf('%c%d:%c%d', alphabets{4}, 1, ...
        alphabets{4},1);
    xlswrite1(file_path,{'CV 2'},'Test data',cell_to_write)
    for j = subject_index : subject_index+number_of_tests-1
        cell_to_write = sprintf('%s%d:%s%d', alphabets{4}, j,...
            alphabets{4}, j);
        
        input = data.cv2_order(j-subject_index+1);
        xlswrite1(file_path,input,'Test data',cell_to_write);
    end
    data = rmfield(data, 'cv2_order');
    %----------------------------------------------------------------------
    % Still PC
elseif strcmp(setup.standard,'Still PC') == 1
    cell_to_write = sprintf('%c%d:%c%d', alphabets{4}, 1, ...
        alphabets{4},1);
    xlswrite1(file_path,{'CV 2_1'},'Test data',cell_to_write)
    for j = subject_index : subject_index+number_of_tests-1
        cell_to_write = sprintf('%s%d:%s%d', alphabets{4}, j,...
            alphabets{4}, j);
        
        input = data.cv2_1_order(j-subject_index+1);
        xlswrite1(file_path,input,'Test data',cell_to_write);
    end
    data = rmfield(data, 'cv2_1_order');
    %-----------------
    cell_to_write = sprintf('%c%d:%c%d', alphabets{6}, 1, ...
        alphabets{6},1);
    xlswrite1(file_path,{'CV 2_2'},'Test data',cell_to_write)
    for j = subject_index : subject_index+number_of_tests-1
        cell_to_write = sprintf('%s%d:%s%d', alphabets{6}, j,...
            alphabets{6}, j);
        
        input = data.cv2_2_order(j-subject_index+1);
        xlswrite1(file_path,input,'Test data',cell_to_write);
    end
    data = rmfield(data, 'cv2_2_order');
    %----------------------------------------------------------------------
    % Triplet
elseif strcmp(setup.standard,'Still triplet') == 1
    cell_to_write = sprintf('%c%d:%c%d', alphabets{4}, 1, ...
        alphabets{4},1);
    xlswrite1(file_path,{'CV 2_1'},'Test data',cell_to_write)
    for j = subject_index : subject_index+number_of_tests-1
        cell_to_write = sprintf('%s%d:%s%d', alphabets{4}, j,...
            alphabets{4}, j);
        
        input = data.cv2_1_order(j-subject_index+1);
        xlswrite1(file_path,input,'Test data',cell_to_write);
    end
    data = rmfield(data, 'cv2_1_order');
    %-----------------
    cell_to_write = sprintf('%c%d:%c%d', alphabets{6}, 1, ...
        alphabets{6},1);
    xlswrite1(file_path,{'CV 2_2'},'Test data',cell_to_write)
    for j = subject_index : subject_index+number_of_tests-1
        cell_to_write = sprintf('%s%d:%s%d', alphabets{6}, j,...
            alphabets{6}, j);
        
        input = data.cv2_2_order(j-subject_index+1);
        xlswrite1(file_path,input,'Test data',cell_to_write);
    end
    data = rmfield(data, 'cv2_2_order');
    %-----------------
    cell_to_write = sprintf('%c%d:%c%d', alphabets{8}, 1, ...
        alphabets{8},1);
    xlswrite1(file_path,{'CV 2_3'},'Test data',cell_to_write)
    for j = subject_index : subject_index+number_of_tests-1
        cell_to_write = sprintf('%s%d:%s%d', alphabets{8}, j,...
            alphabets{8}, j);
        
        input = data.cv2_3_order(j-subject_index+1);
        xlswrite1(file_path,input,'Test data',cell_to_write);
    end
    data = rmfield(data, 'cv2_3_order');
end

% Check offset for the rest of the columns based on the number of cv indexes
switch setup.standard
    case 'Questions only'
        offset = 3;
    case 'ACR'
        offset = 5;
    case 'Still PC'
        offset = 7;
    case 'Still triplet'
        offset = 9;
end

% Subject name
cell_to_write = sprintf('%c%d:%c%d', alphabets{offset}, 1, ...
    alphabets{offset},1);
xlswrite1(file_path,{'Subject'},'Test data',cell_to_write)
for j = subject_index : subject_index+number_of_tests-1
    cell_to_write = sprintf('%s%d:%s%d', alphabets{offset}, j,...
        alphabets{offset}, j);
    
    input = data.subject(j-subject_index+1);
    xlswrite1(file_path,input,'Test data',cell_to_write);
end
data = rmfield(data, 'subject');

% Subject sex
cell_to_write = sprintf('%c%d:%c%d', alphabets{offset+1}, 1, ...
    alphabets{offset+1},1);
xlswrite1(file_path,{'Sex'},'Test data',cell_to_write)
for j = subject_index : subject_index+number_of_tests-1
    cell_to_write = sprintf('%s%d:%s%d', alphabets{offset+1}, j,...
        alphabets{offset+1}, j);
    
    input = data.sex(j-subject_index+1);
    xlswrite1(file_path,input,'Test data',cell_to_write);
end
data = rmfield(data, 'sex');

% Subject age
cell_to_write = sprintf('%c%d:%c%d', alphabets{offset+2}, 1, ...
    alphabets{offset+2},1);
xlswrite1(file_path,{'Age'},'Test data',cell_to_write)
for j = subject_index : subject_index+number_of_tests-1
    cell_to_write = sprintf('%s%d:%s%d', alphabets{offset+2}, j,...
        alphabets{offset+2}, j);
    
    input = data.age(j-subject_index+1);
    xlswrite1(file_path,input,'Test data',cell_to_write);
end
data = rmfield(data, 'age');

% Subject number
cell_to_write = sprintf('%c%d:%c%d', alphabets{offset+3}, 1, ...
    alphabets{offset+3},1);
xlswrite1(file_path,{'Subject number'},'Test data',cell_to_write)
for j = subject_index : subject_index+number_of_tests-1
    cell_to_write = sprintf('%s%d:%s%d', alphabets{offset+3}, j,...
        alphabets{offset+3}, j);
    
    input = data.subject_number(j-subject_index+1);
    xlswrite1(file_path,input,'Test data',cell_to_write);
end
data = rmfield(data, 'subject_number');

%----------------------------------------------------------------------
% Then write all the data
data = orderfields(data);
fields = fieldnames(data);

for i = 1 : length(fields)
    cell_to_write = sprintf('%c%d:%c%d', alphabets{i+offset+3}, 1, ...
        alphabets{i+offset+3},1);
    xlswrite1(file_path,fields(i),'Test data',cell_to_write)
    
    for j = subject_index : subject_index+number_of_tests-1
        cell_to_write = sprintf('%s%d:%s%d', alphabets{i+offset+3}, j,...
            alphabets{i+offset+3}, j);
        
        input = data.(char(fields(i)))(j-subject_index+1);
        
        xlswrite1(file_path,input,'Test data',cell_to_write);
    end
end

%--------------------------------------------------------------------------
% Check if continuous measurement is used and save the data
if ~isempty(continuous_data)
    % Initialize continuous measurement data sheet, if SSCQE standard
    xlswrite1(file_path,{'Evaluation number'},'Continuous data','A1:A1');
    xlswrite1(file_path,{'Subject'},'Continuous data','B1:B1');
    xlswrite1(file_path,{'File name'},'Continuous data','C1:C1');
    xlswrite1(file_path,{'Continuous data'},'Continuous data','D1:D1');
    
    fields = fieldnames(continuous_data.file);
    % Write the evaluation numbers to column A
    index = 1;
    for j = subject_index : subject_index+number_of_tests-1
        cell_to_write = sprintf('A%d:A%d',j,j);
        input = continuous_data.evaluation_number(index);
        index = index + 1;
        xlswrite1(file_path,{input},'Continuous data',cell_to_write);
    end
    % Write the subject name first to column B
    for j = subject_index : subject_index+number_of_tests-1
        cell_to_write = sprintf('B%d:B%d',j,j);
        input = test.subject;
        xlswrite1(file_path,{input},'Continuous data',cell_to_write);
    end
    % Write the file names to column C
    for i = 1 : length(fields)
        cell_to_write = sprintf('C%d:C%d',subject_index+i-1,subject_index+i-1);
        xlswrite1(file_path,continuous_data.file.(char(fields(i))),...
            'Continuous data',cell_to_write)
    end
    % Write the data horizontally beginning from column D
    for i = 1 : length(fields)
        cell_to_write = sprintf('D%d',subject_index+i-1);
        input = continuous_data.values.(char(fields(i)));
        xlswrite1(file_path,input,'Continuous data',cell_to_write);
    end
end

%--------------------------------------------------------------------------
% Shut down the excel server*
invoke(Excel.ActiveWorkbook,'Save');
Excel.Quit
Excel.delete
clear Excel

disp(['Data saved to: ' file_path]);

% End command window logging
diary off

clear all
close all

end




