function videoSSCQE_qbu(position,file_path,player,total_length)

global current_data fig_video current_continuous_data setup test data
global questions minimum_texts maximum_texts 

% INITIALIZE THE GUI SECTION.
% Make sure that the GUI has not been already initialized in another existing figure.
% NOTE THAT THIS GUI INSTANCE CHECK IS NOT REQUIRED, UNLESS YOU WANT TO INSURE THAT ONLY
% ONE INSTANCE OF THE GUI IS CREATED!
h_figs = get(0,'children');
h_fig = findobj(h_figs,'flat', 'tag','questions_fig');
if ~isempty(h_fig)
    figure(h_fig(1));
    return
end

h_fig = hgload(file_path);     % Load the question GUI

set(h_fig,'position',position, ...  % Make the question GUI visible
    'visible','on',...
    'name','Still ACR questions');

% Get the content questions
    if isempty(questions) == 0
        for i = 1 : length(questions)
            s = char(questions(i));
            % Remove spaces and punctuation
            s = regexprep(s,'[^\w'']','');
            % Check string validity
            for j = 1 : length(s)
                if strcmp(s(j),'ö') == 1
                    s(j) = 'o';
                elseif strcmp(s(j),'ä') == 1
                    s(j) = 'a';
                end
            end
            question{i} = s;
        end
    end

% Slider initializations-----------------------------------------------

% Check if slider start values are set to random
sliders(1) = findobj(h_fig,'tag','slider1');
sliders(2) = findobj(h_fig,'tag','slider2');
sliders(3) = findobj(h_fig,'tag','slider3');
sliders(4) = findobj(h_fig,'tag','slider4');
sliders(5) = findobj(h_fig,'tag','slider5');
sliders(6) = findobj(h_fig,'tag','slider6');
sliders(7) = findobj(h_fig,'tag','slider7');
sliders(8) = findobj(h_fig,'tag','slider8');
sliders(9) = findobj(h_fig,'tag','slider9');
sliders(10) = findobj(h_fig,'tag','slider10');
sliders(11) = findobj(h_fig,'tag','slider11');
sliders(12) = findobj(h_fig,'tag','slider12');

% Content related questions check for slider 12
userdata = get(get(sliders(12),'parent'),'userdata');
if isfield(userdata,'contentRelatedQuestions') == 1
    if strcmp(userdata.contentRelatedQuestions,'true') == 1
        for content = 1 : length(questions)
            if content == test.current_cv
                set(get(sliders(12),'parent'),'title',char(questions(content)));
            else
                data.(question{content})(test.current_trial) = 999;
            end
        end
        
        % Update userdata
        s = char(questions(test.current_cv));
        % Remove spaces and punctuation
        s = regexprep(s,'[^\w'']','');
        % Check string validity
        for i = 1 : length(s)
            if strcmp(s(i),'ö') == 1
                s(i) = 'o';
            elseif strcmp(s(i),'ä') == 1
                s(i) = 'a';
            end
        end
        userdata.question = s;
        set(get(sliders(12),'parent'),'userdata',userdata);
        set(sliders(12),'userdata',userdata);
        
        set(findobj(h_fig,'tag','empty_min1'),'string',minimum_texts(test.current_cv));
        set(findobj(h_fig,'tag','empty_max1'),'string',maximum_texts(test.current_cv));
        
    end
end

for i = 1 : length(sliders)
    if strcmp((get(get(sliders(i),'parent'),'visible')),'on') == 1
        userdata = get(sliders(i),'userdata');
        if strcmp(userdata.isRandom,'on') == 1
            range = get(sliders(i),'max') - get(sliders(i),'min');
            if range > get(sliders(i),'max')
                set(sliders(i),'value',round(range*rand() - ...
                    abs(get(sliders(i),'min'))));
            else
                set(sliders(i),'value',round(range*rand()))
            end
        end
        userdata = get(get(sliders(i),'parent'),'userdata');
        current_data.(char(userdata.question)) = ...
            get(sliders(i),'value');
    end
end

% Triplet panel initialization
if strcmp(get(findobj(h_fig,'tag','triplet_panel'),'visible'),'on') == 1
    current_data.vasen = 3;
    current_data.keskimmainen = 3;
    current_data.oikea = 3;
end

% If extra questions
if test.extras == 1
    test.extras = 0;
    uiwait
    % Else use continuous measurement settings
else
    % Find the continuous slider object
    cont_slider = findobj(gcf,'tag','continuous_slider');
    set(cont_slider,'enable','on')
    
    % Find continue button and rewatch button
    cont_button = findobj(gcf,'tag','continue_button');
    repeat_button = findobj(gcf,'tag','repeat_sscqe_stimulus_button');
    
    % Find min and max values
    min = get(cont_slider,'min');
    max = get(cont_slider,'max');
    
    % Define new Window Scroll Wheel Function
    set(gcf,'WindowScrollWheelFcn',{@figScroll,cont_slider})
    
    % While the video is playing
    % vlc.input.state: current state of the input chain given as
    % enumeration (IDLE/CLOSE=0, OPENING=1, BUFFERING=2, PLAYING=3,
    % PAUSED=4, STOPPING=5, ERROR=6)
    current_values = [];
    
    % Plot continuous data if selected
    userdata = get(cont_slider,'userdata');
    if strcmp(userdata.isPlotting,'yes') == 1
        plotContinuousSubjectResponse(current_values,min,max,...
            round(total_length/setup.time_step))
    end
    
    % Disable continue button and rewatch button during the video
    set(cont_button,'enable','off')
    set(repeat_button,'enable','off')
    
    
    time_stamp = 1;
    % Save slider values and plot the timeline
    if strcmp(setup.sel_player,'VLC')
        while player.input.state == 3
            % Get new value from slider
            current_val = round(get(cont_slider,'value'));
            disp(current_val)
            current_values(time_stamp) = current_val;
            time_stamp = time_stamp + 1;
            % Plot continuous data if selected
            userdata = get(cont_slider,'userdata');
            if strcmp(userdata.isPlotting,'true') == 1
                plotContinuousSubjectResponse(current_values,min,max,...
                    round(total_length/setup.time_step))
            end
            % Pause for the time_step
            pause(setup.time_step)
        end
        player.playlist.stop();
    elseif strcmp(setup.sel_player,'WMP')
        while strcmp(player.PlayState,'wmppsPlaying')
            % Get new value from slider
            current_val = round(get(cont_slider,'value'));
            disp(current_val)
            current_values(time_stamp) = current_val;
            time_stamp = time_stamp + 1;
            % Plot continuous data if selected
            userdata = get(cont_slider,'userdata');
            if strcmp(userdata.isPlotting,'true') == 1
                plotContinuousSubjectResponse(current_values,min,max,...
                    round(total_length/setup.time_step))
            end
            % Pause for the time_step
            pause(setup.time_step)
        end
        player.controls.stop;
    else
        disp('Video player not selected.')
        return
    end
    
    
    % Move data to global variable
    current_continuous_data.values = 0;
    current_continuous_data.values = current_values;
    current_continuous_data.file = test.file;
    
    disp(current_data)
    disp(current_continuous_data)
    
    % Hide video figure
    set(fig_video, 'visible','off')
    
    % Enable continue button after the video
    set(cont_button,'enable','on')
    set(repeat_button,'enable','on')
    
    % Wait here for button press
    if setup.extra_questions == 1 || setup.extra_questions == 2
        
        % Hide slider
        set(get(cont_slider,'parent'),'visible','off')
        
        % Continue button
        uicontrol(h_fig, ...
            'style','pushbutton', ...
            'Units', 'Normalized', ...
            'position',[0.2 0.5 0.6 .04],...
            'CallBack',@continue_to_questions, ...
            'tag','continue_to_questions', ...
            'string','Vastaa seuraavaksi kysymyksiin äskeisestä videosta.', ...
            'FontSize', 12,...
            'back',[230/255 232/255 250/255]);
        
        % Wait here for button press
        uiwait(h_fig)
    else
        % Disable slider
        set(cont_slider,'enable','off')
        
        % Wait here for button press
        uiwait
    end
end

end

function figScroll(~,event,slider_handle)
% Get old slider value
old_value = get(slider_handle,'value');

% Get the scroll wheel step size from userdata
userdata = get(slider_handle,'userdata');
step_size = userdata.scroll_step;

% Calculate new slider value
new_value = old_value - (event.VerticalScrollCount * step_size);

% Check min and max values
min = get(slider_handle,'min');
max = get(slider_handle,'max');

if new_value > max
    new_value = max;
elseif new_value < min
    new_value = min;
end

% Set new value
set(slider_handle,'value',new_value)
end

function continue_to_questions(~,~)
close gcf
end

















