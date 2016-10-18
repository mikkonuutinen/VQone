function stillTriplet_qbu(command_str,position,file_path)

global current_data data test
global questions minimum_texts maximum_texts

if nargin == 0
    command_str = 'initialize';
end
if ~strcmp(command_str,'initialize')
    % RETRIEVE HANDLES AND REDEFINE THE HANDLE VARIABLES.
    % Assume that the current figure contains the qbuStillBenchMarking.
    h_fig = gcf;
    if ~strcmp(get(h_fig,'tag'),'questions_fig')
        % If the current figure does not have the right tag, find the one that does.
        h_figs = get(0,'children');
        h_fig = findobj(h_figs,'flat', 'tag','questions_fig');
        
        if isempty(h_fig)
            % If the fun_plt4 GUI does not exist initialize it. Then run the command string
            % that was originally requested.
            ACR_stillqbu('initialize'); %first initialize
            ACR_stillqbu(command_str); %then rin the required command
            return;
        end
    end
end

% INITIALIZE THE GUI SECTION.
if strcmp(command_str,'initialize')
    
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
        'name','Still triplet questions');
    
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
            if strcmp(userdata.isRandom,'yes') == 1
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
    
% Update subject response plot
    for i = 1 : length(sliders)
        userdata = get(get(sliders(i),'parent'),'userdata');
        if strcmp(userdata.isPlotting,'true')
            if isfield(data,(char(userdata.question)))
                new_plot = data.(char(userdata.question));
                if isempty(new_plot)
                    new_plot = 100;
                end
            else
                new_plot = 100;
            end
            plotSubjectResponse(new_plot,get(sliders(i),'min'),get(sliders(i),'max'));
        end
    end    
    
    uiwait;
    
end