function randomization_fullscreen_settings( )
% Summary of this function goes here
% Detailed explanation goes here
stream = RandStream('mt19937ar','seed',sum(100*clock)); %Generate a random seed based on the clock
RandStream.setDefaultStream(stream); %Make this random seed as the default for random no. generators
iptsetpref('ImshowBorder','tight'); %to remove the gray border in figure window
set(0,'DefaultFigureMenu','none', 'DefaultFigureNumberTitle', 'off'); %to remove menubar from all the following figures
%iptsetpref('ImshowInitialMagnification', 'fit'); 
% warning('off', 'Images:initSize:adjustingMag'); %turn off warning message due to large image display
warning off; %turn off warning messages
end