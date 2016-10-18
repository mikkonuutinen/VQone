function display_pc_video(video_file1,video_file2,screen_info1,screen_info2)
% Function for displaying two videos simultaneously or sequentially

global player1 player2 fig_video1 fig_video2 setup

% Place the video figures to correct screens
set(fig_video1, 'Position', screen_info1);
set(fig_video2, 'Position', screen_info2);

% Check which player is selected
switch setup.sel_player
    
    case 'VLC'
        % VLC Player-------------------------------------------------------
        set(fig_video2, 'visible','on');
        set(fig_video1, 'visible','on');
        % Add the videos to the playlists
        player1.playlist.add(video_file1);
        player2.playlist.add(video_file2);
        pause(0.3)
        
        % If using two monitors simultaneously
        if setup.stimuli_in_one_monitor == 0
            % Choose next (current) item in the playlists
            player1.playlist.next()
            player2.playlist.next()
            % Play the videos
            player1.playlist.play()
            player2.playlist.play()
            
            % While opening media
            while player1.input.state ~= 3 || player2.input.state ~= 3
                pause(0.001);
                disp('Opening video...')
                % If errors
                if player1.input.state == 7 || player1.input.state == 7
                    disp('Error while opening file.')
                    pause(0.02)
                    player1.playlist.items.clear;
                    player2.playlist.items.clear;
                    set(fig_video1,'visible','off')
                    set(fig_video2,'visible','off')
                    return
                end
            end
            
            % Disable deinterlacing
            %player.video.deinterlace.disable()
            
            % Check the duration
            duration1 = player1.input.length/1000;
            duration2 = player2.input.length/1000;
            
            % Pause the program during the videos
            pause(max(duration1,duration2));
            
            player1.playlist.stop();
            player2.playlist.stop();
            
            pause(0.2)
            set(fig_video1, 'visible','off');
            set(fig_video2, 'visible','off');
            
            % Else only one monitor to display the videos sequentially
        else
            % Choose next (current) item in the playlist1
            player1.playlist.next()
            
            % Play the first video
            player1.playlist.play()
            
            % While opening media
            while player1.input.state ~= 3
                pause(0.001);
                disp('Opening video...')
                % If errors
                if player1.input.state == 7
                    disp('Error while opening file.')
                    pause(0.02)
                    player1.playlist.items.clear;
                    set(fig_video1,'visible','off')
                    return
                end
            end
            
            % Check the duration
            duration1 = player1.input.length/1000;
            
            % Pause the program during the video
            pause(duration1)
            
            % Stop the video and hide the first video figure
            player1.playlist.stop();
            pause(0.2)
            set(fig_video1, 'visible','off');
            
            % Pause for 1 s
            pause(1)
            
            % Choose next (current) item in the playlist2
            player1.playlist.next()
            
            % Play the second video
            player2.playlist.play()
            
            % While opening media
            while player2.input.state ~= 3
                pause(0.001);
                disp('Opening video...')
                % If errors
                if player2.input.state == 7
                    disp('Error while opening file.')
                    pause(0.02)
                    player2.playlist.items.clear;
                    set(fig_video1,'visible','off')
                    return
                end
            end
            
            % Check the duration
            duration2 = player2.input.length/1000;
            
            % Pause the program during the video
            pause(duration2)
            
            % Stop the video and hide the second video figure
            player2.playlist.stop();
            pause(0.2)
            set(fig_video2, 'visible','off');
            
        end
        
    case 'WMP'
        % Windows Media Player --------------------------------------------
        % Add the videos to the playlists
        player1.URL = video_file1;
        player2.URL = video_file2;
        pause(0.3)

        % Make the video figures visible
        set(fig_video2, 'Visible', 'On');
        set(fig_video1, 'Visible', 'On');
        
        % If using two monitors simultaneously
        if setup.stimuli_in_one_monitor == 0
            
            % Play the videos
            player1.controls.play;
            player2.controls.play;
            
            % While opening media
            while (strcmp(player1.PlayState,'wmppsPaused') == 0 && ...
                strcmp(player2.PlayState,'wmppsPaused') == 0)
                pause(0.001)
                disp(player1.OpenState)
                disp(player2.OpenState)
                % If the players try to start playing at different times
                if strcmp(player1.OpenState,'wmposMediaOpen')
                    player1.controls.pause;
                elseif strcmp(player2.OpenState,'wmposMediaOpen')
                    player2.controls.pause;
                end
            end
            
            pause(0.1)
            
            % Play the videos
            player1.controls.play;
            player2.controls.play;
            
            pause(0.1)
            
            disp(['Player 1: ' player1.PlayState])
            disp(['Player 2: ' player2.PlayState])
            
            duration1 = player1.currentMedia.Duration;
            duration2 = player2.currentMedia.Duration;
            
            % Show the volume information
            disp(['Player 1 volume:' player1.settings.Volume])
            disp(['Player 2 volume:' player2.settings.Volume])
            
            % Pause for the longest video duration
            pause(max(duration1,duration2));
            player1.controls.stop;
            player2.controls.stop;
            
            set(fig_video1, 'visible','off');
            set(fig_video2, 'visible','off');
            
            disp(get(player1.error))
            disp(get(player2.error))
            
            % Else only one monitor to display the videos sequentially-----
        else
            % Play the video
            player1.controls.play;
            
            pause(0.1)

            % While opening media
            while strcmp(player1.PlayState,'wmppsPlaying') == 0
                pause(0.001)
                disp(player1.OpenState)
            end
            
            disp(['Player 1: ' player1.PlayState])
            
            duration1 = player1.currentMedia.Duration;
            
            % Show the volume information
            disp(['Player 1 volume:' player1.settings.Volume])
            
            % Pause for the video duration
            pause(duration1)
            
            % Stop the video and hide the first video figure
            player1.controls.stop;
            pause(0.2)
            set(fig_video1,'visible','off')
            
            % Pause for 1 s
            pause(1)
            
            % Play the second video----------------------------------------
            player2.controls.play;
            
            % While opening media
            while strcmp(player2.PlayState,'wmppsPlaying') == 0
                pause(0.001)
                disp(player2.OpenState)
            end
            
            disp(['Player 2: ' player2.PlayState])
            
            duration2 = player2.currentMedia.Duration;
            
            % Show the volume information
            disp(['Player 2 volume:' player2.settings.Volume])
            
            % Pause for the video duration
            pause(duration2)
            
            % Stop the video and hide the second video figure
            player2.controls.stop;
            pause(0.2)
            set(fig_video2,'visible','off')
        end
        
end

end


















