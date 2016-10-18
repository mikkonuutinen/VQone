function fig = display_fullscreen_masking_image(screen_info)
fig = figure('Visible', 'off'); %Create an invisible blank figure
file_path = [pwd filesep 'images' filesep 'masking_image.jpg'];
imshow(file_path); %Display the image on the previous figure
set(fig, 'Position',screen_info); %Set the properties of the given figure
set(fig, 'Visible', 'On'); %make the figure visible
end