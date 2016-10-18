function display_video(video_file,screen_info)

global duration player fig_video setup

% Place the video figure to correct screen
set(fig_video, 'Position', screen_info);

% Check which player is selected
switch setup.sel_player
    
    case 'VLC'
        % VLC Player-------------------------------------------------------
        set(fig_video, 'visible','on');
        player.playlist.add(video_file);
        pause(0.3)
        player.playlist.next()
        
        player.playlist.play()
        
        % While opening media
        while player.input.state ~= 3
            pause(0.001);
            disp('Opening video...')
            if player.input.state == 7
                disp('Error while opening file.')
                pause(0.02)
                player.playlist.items.clear;
                set(fig_video,'visible','off')
                return
            end
        end
        
        % Disable deinterlacing
        %player.video.deinterlace.disable()
        
        duration = player.input.length/1000;
        
        pause(duration);
        
        player.playlist.stop();
        
        pause(0.2)
        set(fig_video, 'visible','off');
        
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
        
        pause(duration);
        player.controls.stop;
        
        set(fig_video, 'visible','off');
        
        disp(get(player.error))
        
        return
end

end












