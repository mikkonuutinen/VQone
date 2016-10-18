function fig = display_fullscreen_image(image_file_index, screen_info)
fig = figure('Visible', 'off'); %Create an invisible blank figure

%%imshow( image_file_index, 5 ); %Display the image on the previous figure

imshow( image_file_index );
set(fig, 'Position',screen_info); %Set the properties of the given figure

%set(fig, 'Visible', 'On'); %make the figure visible
end