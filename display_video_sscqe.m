function display_video_sscqe(video_file,stimulus_monitor,question_monitor)
global fig_video player setup duration test current_continuous_data

% Place the video figure to correct screen
set(fig_video,'Position', stimulus_monitor);

% Check which player is selected
switch setup.sel_player
    
    case 'VLC'
        % VLC Player-------------------------------------------------------
        set(fig_video,'visible','on');
        player.playlist.add(video_file);
        pause(0.3)
        player.playlist.next()
        
        player.playlist.play()
        
        % While opening media
        % vlc.input.state : current state of the input chain given as
        % enumeration (IDLE/CLOSE=0, OPENING=1, BUFFERING=2, PLAYING=3,
        % PAUSED=4, STOPPING=5, ERROR=6)
        while player.input.state ~= 3
            pause(0.01);
            disp('Opening video...')
            if player.input.state == 6
                disp('Error while opening file.')
                pause(0.02)
                player.playlist.items.clear;
                set(fig_video,'visible','off')
                return
            end
        end
        
        % Disable deinterlacing
        %player.video.deinterlace.disable()
        total_length = player.input.Length/1000;
        
        test.tStart = tic;
        % Open the question figure
        file_path = [pwd filesep 'setups' filesep setup.name filesep ...
            setup.name '_continuous_qbu.fig'];
        videoSSCQE_qbu(question_monitor,file_path,player,total_length);
        
    case 'WMP'
        % Windows Media Player --------------------------------------------
        player.URL = video_file;
        pause(0.3)
        player.controls.play;
        set(fig_video, 'Visible', 'On');
        
        while strcmp(player.PlayState,'wmppsPlaying') == 0
            pause(0.001)
            disp(player.OpenState)
        end
        disp(player.PlayState)
        
        duration = player.currentMedia.Duration;
        
        % Show the volume information
        disp(['Player volume:' player.settings.Volume])
        
        test.tStart = tic;
        % Open the question figure
        file_path = [pwd filesep 'setups' filesep setup.name filesep ...
            setup.name '_continuous_qbu.fig'];
        videoSSCQE_qbu(question_monitor,file_path,player,duration);
        
        disp(get(player.error))
        
end

return


end








