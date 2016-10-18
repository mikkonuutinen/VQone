function display_stillACR_references()
global setup test


% Check reference randomizing
if setup.ref_random == 1
    reference_order = randperm(test.references);
else
    reference_order = 1:test.references;
end

%Creates a dummy invisible mask figure
fig_mask = figure('Visible', 'Off');

for ref_index = 1:test.references                % Display reference images
    if setup.ref_exclude_current == 1            % IF skip current image from reference
        
        %Skips the image currently on primary screen from being reference for itself
        if reference_order(ref_index) ~= test.cv2_order(test.current_trial)
            if strcmp(setup.ref_connecting,'CV2')
                stimuli_index = (test.cv1_order(test.current_trial)-1) * setup.cv2 + ...
                    reference_order(ref_index);
            else
                stimuli_index = (reference_order(ref_index)-1) * setup.cv2 + ...
                    test.cv1_order(test.current_trial);
            end
            file_path = [pwd filesep 'images' filesep ...
                test.image_file_names{stimuli_index}];
            % Display ref image filename
            disp('Reference image:')
            disp(test.image_file_names{stimuli_index})
            %Displays reference image on top of the previous masking image
            new_fig = display_fullscreen_image(file_path,test.reference_monitor);
            set(new_fig,'visible','on')
            %disp(image_file_names{stimuli_index});
            
            
            %pause(1);
            pause(setup.dynamic_reference_time); % TÄSSÄ MUUTETAAN REFERENSSIAIKAA!! 
            
            
            if setup.ref_masking == 1
                fig_ref = new_fig;
                close(fig_mask);
                %Displays masking image on top of the previous ref image
                fig_mask = display_fullscreen_masking_image(test.reference_monitor);
                
                pause(0.5);
                close(fig_ref);
            else
                close(fig_mask)
                fig_mask = new_fig;
            end
        end
        if ref_index == setup.cv2
            close(fig_mask);
        end
        
    else    % Show all images from connected cv
        if strcmp(setup.ref_connecting,'CV2')
            stimuli_index = (test.cv1_order(test.current_trial)-1) * setup.cv2 + ...
                reference_order(ref_index);
        else
            stimuli_index = (reference_order(ref_index)-1) * setup.cv2 + ...
                test.cv1_order(test.current_trial)
        end
        file_path = [pwd filesep 'images' filesep test.image_file_names{stimuli_index}];
        % Display ref image filename
        disp('Reference image:')
        disp(test.image_file_names{stimuli_index})
        new_fig = display_fullscreen_image( file_path,test.reference_monitor); %Displays reference image on top of the previous masking image
        set(new_fig,'visible','on')
        
        pause(1);
        
        if setup.ref_masking == 1
            fig_ref = new_fig;
            close(fig_mask);
            
            fig_mask = display_fullscreen_masking_image(test.reference_monitor); %Displays masking image on top of the previous ref image
            
            pause(0.5);
            close(fig_ref);
        else
            close(fig_mask)
            fig_mask = new_fig;
        end
        if ref_index == setup.cv2
            close(fig_mask);
        end
    end
end

end