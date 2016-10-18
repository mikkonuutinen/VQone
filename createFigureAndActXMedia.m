function h = createFigureAndActXMedia(fig,screen_info)
global setup

% Check which player is selected
switch setup.sel_player
    
    case 'VLC'
        % VLC Player---------------------------------------------------------------
        h = actxcontrol('VideoLAN.VLCPlugin.2', ...
            [0 0 screen_info(3) screen_info(4)], fig);
        h.AutoPlay = 0;
        
    case 'WMP'
        % Windows Media Player-----------------------------------------------------
        %feature('COM_ActxProgidCheck',0)
        h = actxcontrol('WMPlayer.OCX.7',[0 0 screen_info(3) screen_info(4)], fig);
        h.settings.autoStart = 0;
        h.uimode = 'none';
        h.enableContextMenu = 0;
        
end