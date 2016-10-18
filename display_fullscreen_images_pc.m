function display_fullscreen_images_pc(image_file_index1,image_file_index2,screen_info1,screen_info2)
% Function for showing two stimuli images according to the PC standard.
%
% Syntax: display_fullscreen_images_pc(image_file1,image_file2,screen1,screen2)
% where image_file1 and 2 are the filepaths to the stimuli images and
% screen1 and 2 are the monitor positions.
%
% Global variable 'setup' is needed with the information if the
% stimuli are directed to only one monitor. Also stimuli viewing_time is
% required information.

global setup

if setup.stimuli_in_one_monitor == 0 % If using two monitors
    if setup.is_masking == 1 % If masking
        % Find the masking image
        file_path = [pwd filesep 'images' filesep 'masking_image.jpg'];
        fig_mask1 = figure('visible','off');
        imshow(file_path)
        fig_mask2 = figure('visible','off');
        imshow(file_path)
        set(fig_mask1,'position',screen_info1)
        set(fig_mask1,'visible','on')
        set(fig_mask2,'position',screen_info2)
        set(fig_mask2,'visible','on')
        pause(0.5)
    end
    fig1 = figure('Visible', 'off');    %Create an invisible blank figure
    %imshow( image_file_index1, 5 );     %Display the image on the previous figure
    imshow( image_file_index1 )
    fig2 = figure('Visible', 'off');    %Create an invisible blank figure
    %imshow( image_file_index2, 5 );     %Display the image on the previous figure
    imshow( image_file_index2 )
    
    set(fig1, 'Position',screen_info1); %Set the properties of the given figure
    set(fig2, 'Position',screen_info2); %Set the properties of the given figure
    set(fig1, 'Visible', 'On');         %make the figure visible
    set(fig2, 'Visible', 'On');         %make the figure visible
    
    % Check the viewing time and close stimuli if necessary
    if setup.viewing_time ~= 0
        pause(setup.viewing_time)
        close(fig1)
        close(fig2)
        if setup.is_masking == 1
            close(fig_mask1)
            close(fig_mask2)
        end
        return
    end
    if setup.is_masking == 1
        pause(0.2)
        close(fig_mask1)
        close(fig_mask2)
    end
    
else % the two images are displayed sequentially in one monitor
    % First image----------------------------------------------------------
    fig = figure('Visible', 'off');    %Create an invisible blank figure
    imshow( image_file_index1); 
    %imshow( image_file_index1, 5 );    %Display the image on the previous figure
    set(fig,'Position',screen_info1);  %Set the properties of the given figure
    set(fig,'Visible', 'On');          %make the figure visible
    
    % Pause for viewing time
    pause(setup.viewing_time)
    
    % Check if masking image is selected-----------------------------------
    if setup.is_masking == 1
        fig_mask = figure('visible','off');
        % Find the masking image
        file_path = [pwd filesep 'images' filesep 'masking_image.jpg'];
        % Display the masking image on the previous image
        imshow(file_path)
        set(fig_mask,'position',screen_info1)
        set(fig_mask,'visible','on')
        % Hold it there for 0,5 s
        pause(0.5)
        % Close the stimulus fig
        close(fig)
    else
        % If not, hide figure, pause for 0,5 s and show the second image
        set(fig,'visible','off')
        pause(0.5)
    end
    
    % Second image---------------------------------------------------------
    fig = figure('visible','off');
    imshow(image_file_index2);  
    %imshow(image_file_index2, 5);     %Display the image on the previous figure
    set(fig,'position',screen_info1)
    set(fig, 'Visible', 'On');        %make the figure visible
    % Pause for viewing time and close the figure
    pause(setup.viewing_time)
    close(fig)
    if setup.is_masking == 1
        close(fig_mask)
    end
end

end

























