function initSetup(contFcnHandle)

global setup

if isempty(setup.modifying)
    setup.modifying = 0;
end

if ~isempty(setup.name) && ~isempty(setup.standard)
    %     % Global settings----------------------------------------------------------
    %     % Make directory for the new setup
    %     dir_name = setup.name;
    %     mkdir('setups',dir_name);
    %     setup.setup_file_path = [pwd filesep 'setups' filesep dir_name filesep];
    %     file_path = [setup.setup_file_path setup.name '_data.xls'];
    %     % Make directory for command window log
    %     log_dir_name = 'command_window_logs';
    %     mkdir(['setups' filesep dir_name filesep],log_dir_name);
    %     % Make datafile for practice runs
    %     practice_file_path = [setup.setup_file_path setup.name '_practice_data.xls'];
    %     % Save figure for 'back'- and 'modify'-buttons
    %     hgsave([pwd filesep 'setups' filesep dir_name filesep 'start_screen.fig']);
    %     close all;
    %
    %     % Open the excel server in advance for rapid action
    %     Excel = actxserver ('Excel.Application');
    %     File=file_path;
    %     if ~exist(File,'file')
    %         ExcelWorkbook = Excel.workbooks.Add;
    %         ExcelWorkbook.SaveAs(File,1);
    %         ExcelWorkbook.Close(false);
    %     end
    %     invoke(Excel.Workbooks,'Open',File);
    %
    %     % Initialize datasheet
    %     xlswrite1(file_path,{'Test Number'},'Subject data','A1:A1');
    %     xlswrite1(file_path,{'Subject'},'Subject data','B1:B1');
    %     xlswrite1(file_path,{'Age'},'Subject data','C1:C1');
    %     xlswrite1(file_path,{'Sex'},'Subject data','D1:D1');
    %     xlswrite1(file_path,{'Current Test Number'},'Subject data','H1:H1');
    %     xlswrite1(file_path,1,'Subject data','H2:H2');
    %
    %     xlswrite1(file_path,{'Standard:'},'Setup information','A1:A1');
    %     xlswrite1(file_path,{setup.standard},'Setup information','B1:B1');
    %     xlswrite1(file_path,{'Version:'},'Setup information','A2:A2');
    %     xlswrite1(file_path,{setup.version},'Setup information','B2:B2');
    %     xlswrite1(file_path,{'Setup name:'},'Setup information','A3:A3');
    %     xlswrite1(file_path,{setup.name},'Setup information','B3:B3');
    %
    %     xlswrite1(file_path,{'CV1 name'},'Setup information','B1:B1');
    %     xlswrite1(file_path,{setup.cv1_name},'Setup information','B2:B2');
    %     xlswrite1(file_path,{'CV2 name'},'Setup information','C1:C1');
    %     xlswrite1(file_path,{setup.cv2_name},'Setup information','C2:C2');
    %     xlswrite1(file_path,{'Monitors randomized'},'Setup information','D1:D1');
    %     xlswrite1(file_path,setup.random_monitors,'Setup information','D2:D2');
    %
    %     % Shut down the excel server
    %     invoke(Excel.ActiveWorkbook,'Save');
    %     Excel.Quit
    %     Excel.delete
    %     clear Excel
    %
    %     % Open the excel server in advance for rapid action
    %     Excel = actxserver ('Excel.Application');
    %     File=practice_file_path;
    %     if ~exist(File,'file')
    %         ExcelWorkbook = Excel.workbooks.Add;
    %         ExcelWorkbook.SaveAs(File,1);
    %         ExcelWorkbook.Close(false);
    %     end
    %     invoke(Excel.Workbooks,'Open',File);
    %
    %     % Initialize practice datasheet
    %     xlswrite1(practice_file_path,{'Test Number'},'Subject data','A1:A1');
    %     xlswrite1(practice_file_path,{'Subject'},'Subject data','B1:B1');
    %     xlswrite1(practice_file_path,{'Age'},'Subject data','C1:C1');
    %     xlswrite1(practice_file_path,{'Sex'},'Subject data','D1:D1');
    %     xlswrite1(practice_file_path,{'Current Test Number'},'Subject data','H1:H1');
    %     xlswrite1(practice_file_path,1,'Subject data','H2:H2');
    %
    %     xlswrite1(file_path,{'Standard:'},'Setup information','A1:A1');
    %     xlswrite1(file_path,{setup.standard},'Setup information','B1:B1');
    %     xlswrite1(file_path,{'Version:'},'Setup information','A2:A2');
    %     xlswrite1(file_path,{setup.version},'Setup information','B2:B2');
    %     xlswrite1(file_path,{'Setup name:'},'Setup information','A3:A3');
    %     xlswrite1(file_path,{setup.name},'Setup information','B3:B3');
    %
    %     xlswrite1(file_path,{'CV1 name'},'Setup information','A4:A4');
    %     xlswrite1(file_path,{setup.cv1_name},'Setup information','B4:B4');
    %     xlswrite1(file_path,{'CV2 name'},'Setup information','A5:A5');
    %     xlswrite1(file_path,{setup.cv2_name},'Setup information','B5:B5');
    %     xlswrite1(file_path,{'Monitors randomized'},'Setup information','A6:A6');
    %     xlswrite1(file_path,setup.random_monitors,'Setup information','B6:B6');
    %
    %     % Shut down the excel server
    %     invoke(Excel.ActiveWorkbook,'Save');
    %     Excel.Quit
    %     Excel.delete
    %     clear Excel
    
    initExcelSheets()
    
    if strcmp(setup.standard,'Still triplet')
        % Create the cross-tabulation excel sheets
        disp('Creating cross tabulation Excel sheets...')
        initCrossTabulationExcel();
        disp('Done.')
    end
    
    
    % Save figure for 'back'- and 'modify'-buttons
    hgsave([pwd filesep 'setups' filesep setup.name filesep 'start_screen.fig']);
    close all;
    
    % Standard specific start-up
    if setup.modifying == 1
        % We are saving an existing setup to a new folder with some
        % modifications
        
        % Move the old sbu-file to the new directory
        copyfile([pwd filesep 'setups' filesep setup.old_name filesep setup.old_name '_sbu.mat'], ...
            [pwd filesep 'setups' filesep setup.name filesep setup.name '_sbu.mat'])
        
        % Save the updated sbu information
        save([pwd filesep 'setups' filesep setup.name filesep setup.name ...
            '_sbu.mat'],'setup','-append');
        
        switch setup.standard
            % Tell the create sbu -function to save the modified sbu file
            case 'ACR'
                % Settings for exiting SBU and initializing QBU with an old
                % setup
                setup.first_time = 0;
                setup.modifying = 2;
                createStillACR_sbu('Push Button3 Pressed');
            case 'Video ACR'
                % Settings for exiting SBU and initializing QBU with an old
                % setup
                setup.first_time = 0;
                setup.modifying = 2;
                createVideoACR_sbu('Push Button3 Pressed');
            case 'Still PC'
                % Settings for exiting SBU and initializing QBU with an old
                % setup
                
                % Create the cross-tabulation excel sheets
                disp('Creating cross tabulation Excel sheets...')
                initPCCrossTabulationExcel();
                disp('Done.')
                
                setup.first_time = 0;
                setup.modifying = 2;
                % Evaluate the Continue button callback function
                feval(contFcnHandle)
            case 'Still triplet'
                % Settings for exiting SBU and initializing QBU with an old
                % setup
                setup.first_time = 0;
                setup.modifying = 2;
                % Evaluate the Continue button callback function
                feval(contFcnHandle)
            case 'Video SSCQE'
                % Settings for exiting SBU and initializing QBU with an old
                % setup
                setup.first_time = 0;
                setup.modifying = 2;
                % Evaluate the Continue button callback function
                feval(contFcnHandle)
        end
        
    else
        % ACR selected-----------------------------------------------------
        if strcmp(standard,'ACR') == 1
            
            setup.modifying = 0;
            createStillACR_sbu('initialize');
            disp('Initializing ACR standard')
            
            % Still PC selected--------------------------------------------
        elseif strcmp(standard,'Still PC') == 1
            
            setup.modifying = 0;
            create_stillPC_sbu('initialize');
            disp('Initializing Still PC standard');
            
            % Still triplet selected---------------------------------------
        elseif strcmp(standard,'Still triplet') == 1
            
            setup.modifying = 0;
            createStillTriplet_sbu('initialize');
            disp('Initializing Still triplet standard');
            
            % Video SSCQE selected-----------------------------------------
        elseif strcmp(standard,'Video SSCQE') == 1
            
            setup.modifying = 0;
            disp('Initializing Video SSCQE standard');
            createVideoSSCQE_sbu('initialize');
            
            % Video ACR selected-------------------------------------------
        elseif strcmp(standard,'Video ACR') == 1
            
            setup.modifying = 0;
            createVideoACR_sbu('initialize');
            disp('Initializing Video ACR standard');
            
            % Questions only selected--------------------------------------
        elseif strcmp(standard,'Questions only') == 1
            
            disp('Initializing Questions only standard');
            
            prompt = 'How many trials:';
            dlg_title = 'Trial count';
            num_lines = 1;
            trial_count = inputdlg(prompt,dlg_title,num_lines);
            
            % Must save settings here, because no SBU for this standard
            if isempty(trial_count)
                disp('Choose the number of trials before continuing.')
            else
                close all;
                setup.trial_count = str2num(trial_count{1});
                
                save([setup_file_path 'settings_sbu'],'trial_count','standard',...
                    'name');
                
                setup.modifying = 0;
                QBU('initialize');
            end
            
        else
            disp('Select standard and setup name before continuing');
        end
    end
else
    disp('Select standard and setup name before continuing');
end

end