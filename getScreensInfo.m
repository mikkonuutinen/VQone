function [screens_info] = getScreensInfo()
% Summary of this function goes here
% Detailed explanation goes here
global setup

screens_info = get(0,'MonitorPosition'); %Get information about the monitor screens

% If the program is run at the triplets
%if length(screens_info(:,1)) == 4
    
    % TRIPLETS-------------------------------------------------------------
    %
    %screens_info(2,3) = screens_info(1,3); %Setting for my home screens
    %screens_info(1,:) = [1 1 1920 1200];
    %screens_info(2,:) = screens_info(1,:);
    %screens_info(1,1) = -1923;
    %screens_info(3,:) = [1921 1 1920 1200];
    %screens_info(4,:) = [460 -770 1024 748];

    %screens_info(1,:) = [setup.screens_info11 setup.screens_info12 setup.screens_info13 setup.screens_info14]; %[1 20 1200 750];
    %screens_info(2,:) = [setup.screens_info21 setup.screens_info22 setup.screens_info23 setup.screens_info24];
    %screens_info(3,:) = [setup.screens_info31 setup.screens_info32 setup.screens_info33 setup.screens_info34];
    %screens_info(4,:) = [setup.screens_info41 setup.screens_info42 setup.screens_info43 setup.screens_info44];
    
    
    %
    %----------------------------------------------------------------------
    
% Simulate the triplets if the program is run somewhere else
%else
    
    % LAPTOP---------------------------------------------------------------
    
    % Single screen (1680 x 1050)------------------------------------------
    %
    %screens_info(1,:) = [1 560 600 376]; %[1 20 1200 750];
    %screens_info(2,:) = [560 560 600 376];
    %screens_info(3,:) = [1120 560 600 376];
    %screens_info(4,:) = [200 37 700 500];
    %
    %----------------------------------------------------------------------
    
    screens_info(1,:) = [setup.screens_info11 setup.screens_info12 setup.screens_info13 setup.screens_info14]; %[1 20 1200 750];
    screens_info(2,:) = [setup.screens_info21 setup.screens_info22 setup.screens_info23 setup.screens_info24];
    screens_info(3,:) = [setup.screens_info31 setup.screens_info32 setup.screens_info33 setup.screens_info34];
    screens_info(4,:) = [setup.screens_info41 setup.screens_info42 setup.screens_info43 setup.screens_info44];
    
%end

end