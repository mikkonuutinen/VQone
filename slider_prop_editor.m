function slider_prop_editor(S)
% Open the property editor window for slider components in the QBU
%
% Argument S is the handle to the particular slider component
% S must also include userdata-field with the following structure:
%   userdata.isRandom = 'yes or no';
%   userdata.flowControl = 'on or off';
%   userdata.stopMessage = 'message for preventing continuing';
%   userdata.isTouched = 'true or false';
%   userdata.question = 'slider's question';
%   userdata.isPlotting = 'true or false';
%
% NOTICE: Written with Java-syntax using JIDE component library

global setup

% Initialize JIDE's usage within Matlab
com.mathworks.mwswing.MJUtilities.initJIDE;

% Prepare the properties list:
list = java.util.ArrayList();

%--------------------------------------------------------------------------
% Char array for title string
title = com.jidesoft.grid.DefaultProperty();
title.setName('Title text');
title.setType(javaclass('char',1));
title.setValue(get(S.empty_panel,'title'));
title.setCategory('Strings');
title.setDisplayName('Title text');
title.setDescription('Set the title of the slider, empty box means no title');
title.setEditable(true);
list.add(title);

% Char array for min string
min = com.jidesoft.grid.DefaultProperty();
min.setName('Min value text');
min.setType(javaclass('char',1));
min.setValue(get(S.empty_min,'string'));
min.setCategory('Strings');
min.setDisplayName('Min value text');
min.setDescription('Set the text for minimum value, empty box means no text');
min.setEditable(true);
list.add(min);

% Char array for max string
max = com.jidesoft.grid.DefaultProperty();
max.setName('Max value text');
max.setType(javaclass('char',1));
max.setValue(get(S.empty_max,'string'));
max.setCategory('Strings');
max.setDisplayName('Max value text');
max.setDescription('Set the text for maximum value, empty box means no text');
max.setEditable(true);
list.add(max);

%--------------------------------------------------------------------------
% Integer boxes for fontsizes
% Title font size
title_font = com.jidesoft.grid.DefaultProperty();
title_font.setName('Title font size');
title_font.setType(javaclass('int32'));
title_font.setValue(get(S.empty_panel,'fontsize'));
title_font.setCategory('Font sizes');
title_font.setDescription('Set font size for the question text');
list.add(title_font);
% Min text font size
min_text_font = com.jidesoft.grid.DefaultProperty();
min_text_font.setName('Min text font size');
min_text_font.setType(javaclass('int32'));
min_text_font.setValue(get(S.empty_min,'fontsize'));
min_text_font.setCategory('Font sizes');
min_text_font.setDescription('Set font size for the minimum text');
list.add(min_text_font);
% Max text font size
max_text_font = com.jidesoft.grid.DefaultProperty();
max_text_font.setName('Max text font size');
max_text_font.setType(javaclass('int32'));
max_text_font.setValue(get(S.empty_max,'fontsize'));
max_text_font.setCategory('Font sizes');
max_text_font.setDescription('Set font size for the maximum text');
list.add(max_text_font);

%--------------------------------------------------------------------------
% Integer box for min value
min_value = com.jidesoft.grid.DefaultProperty();
min_value.setName('Slider min value');
min_value.setType(javaclass('int32'));
min_value.setValue(get(S.h_slider,'min'));
min_value.setCategory('Values');
min_value.setDescription('Set the minimum slider value');
list.add(min_value);

% Integer box for max value
max_value = com.jidesoft.grid.DefaultProperty();
max_value.setName('Slider max value');
max_value.setType(javaclass('int32'));
max_value.setValue(get(S.h_slider,'max'));
max_value.setCategory('Values');
max_value.setDescription('Set the maximum slider value');
list.add(max_value);

% Check box for random start value
random_start = com.jidesoft.grid.DefaultProperty();
random_start.setName('Is starting value random');
random_start.setType(javaclass('logical'));
userdata = get(S.h_slider,'userdata');
if strcmp(userdata.isRandom,'yes') == 1
    random_start.setValue(true)
else
    random_start.setValue(false);
end
random_start.setCategory('Values');
random_start.setDescription('Is the slider starting value random?');
random_start.setEditorContext(com.jidesoft.grid.BooleanCheckBoxCellEditor.CONTEXT);
list.add(random_start);

% Integer box for starting value
starting_value = com.jidesoft.grid.DefaultProperty();
starting_value.setName('Slider starting value');
starting_value.setType(javaclass('int32'));
starting_value.setValue(get(S.h_slider,'value'));
starting_value.setCategory('Values');
starting_value.setDescription('Set the slider starting value');
list.add(starting_value);

% Integer box for arrow click step size
arrow_click = com.jidesoft.grid.DefaultProperty();
arrow_click.setName('Step size for arrow click in %');
arrow_click.setType(javaclass('int32'));
step = get(S.h_slider,'sliderstep');
arrow_click.setValue(step(1)*100);
arrow_click.setCategory('Values');
arrow_click.setDescription('Step size for arrow click. Scale from 0 % to 100 %');
list.add(arrow_click);

% Integer box for trough click step size
trough_click = com.jidesoft.grid.DefaultProperty();
trough_click.setName('Step size for trough click in %');
trough_click.setType(javaclass('int32'));
step = get(S.h_slider,'sliderstep');
trough_click.setValue(step(2)*100);
trough_click.setCategory('Values');
trough_click.setDescription('Step size for trough click. Scale from 0 % to 100 %');
list.add(trough_click);


% Integer box for scroll wheel step size
userdata = get(S.h_slider,'userdata');
if isfield(userdata,'scroll_step') == 1
    scroll = com.jidesoft.grid.DefaultProperty();
    scroll.setName('Step size for minimum scroll wheel speed');
    scroll.setType(javaclass('int32'));
    scroll_step = userdata.scroll_step;
    scroll.setValue(scroll_step);
    scroll.setCategory('Values');
    scroll.setDescription('Scroll wheel step size. Scale from 0 to inf in absolute units');
    list.add(scroll);
end

%--------------------------------------------------------------------------
% Check box for flow control
flow = com.jidesoft.grid.DefaultProperty();
flow.setName('Is flow control on?');
flow.setType(javaclass('logical'));
userdata = get(S.h_slider,'userdata');
if strcmp(userdata.flowControl,'off') == 1
    flow.setValue(false)
else
    flow.setValue(true);
end
flow.setCategory('Flow control');
flow.setDescription('Does the slider have to be touched before continuing');
flow.setEditorContext(com.jidesoft.grid.BooleanCheckBoxCellEditor.CONTEXT);
list.add(flow);

%--------------------------------------------------------------------------
% Char array for flow stop message
flow_stop = com.jidesoft.grid.DefaultProperty();
flow_stop.setName('Flow stop message');
flow_stop.setType(javaclass('char',1));
userdata = get(S.h_slider,'userdata');  % Flow stop message from userdata
flow_stop.setValue(userdata.stopMessage);
flow_stop.setCategory('Flow control');
flow_stop.setDisplayName('Flow stop message');
flow_stop.setDescription('Set the flow stop message for dialog box');
flow_stop.setEditable(true);
list.add(flow_stop);


%--------------------------------------------------------------------------
% Panel position
position = get(S.empty_panel,'position');

from_left = com.jidesoft.grid.DefaultProperty();
from_left.setName('% from left');
from_left.setType(javaclass('double'));
from_left.setValue(position(1)*100);
from_left.setCategory('Position');
from_left.setDescription('Relative position from the left border of the figure. Scale from 0 % to 100 %');
list.add(from_left);

from_bottom = com.jidesoft.grid.DefaultProperty();
from_bottom.setName('% from bottom');
from_bottom.setType(javaclass('double'));
from_bottom.setValue(position(2)*100);
from_bottom.setCategory('Position');
from_bottom.setDescription('Relative position from the bottom of the figure. Scale from 0 % to 100 %');
list.add(from_bottom);

width = com.jidesoft.grid.DefaultProperty();
width.setName('Width in %');
width.setType(javaclass('double'));
width.setValue(position(3)*100);
width.setCategory('Position');
width.setDescription('Relative width of the panel. Scale from 0 % to 100 %');
list.add(width);

height = com.jidesoft.grid.DefaultProperty();
height.setName('Height in %');
height.setType(javaclass('double'));
height.setValue(position(4)*100);
height.setCategory('Position');
height.setDescription('Relative height of the panel. Scale from 0 % to 100 %');
list.add(height);

%--------------------------------------------------------------------------
% Is contentRelatedQuestions
userdata = get(S.h_slider,'userdata');
if isfield(userdata,'contentRelatedQuestions') == 1
    % Check box for contentRelatedQuestions
    contentRelatedQuestions = com.jidesoft.grid.DefaultProperty();
    contentRelatedQuestions.setName('Is the contentRelatedQuestions on?');
    contentRelatedQuestions.setType(javaclass('logical'));
    if strcmp(userdata.contentRelatedQuestions,'false') == 1
        contentRelatedQuestions.setValue(false)
    else
        contentRelatedQuestions.setValue(true);
    end
    contentRelatedQuestions.setCategory('Measurement type');
    contentRelatedQuestions.setDescription('Is the contentRelatedQuestions on for this slider.');
    contentRelatedQuestions.setEditorContext(com.jidesoft.grid.BooleanCheckBoxCellEditor.CONTEXT);
    list.add(contentRelatedQuestions);
end

%--------------------------------------------------------------------------
% Is plotting selected
userdata = get(S.h_slider,'userdata');
% Check box for continuous measurement
isPlotting = com.jidesoft.grid.DefaultProperty();
isPlotting.setName('Is the subject response plotted?');
isPlotting.setType(javaclass('logical'));
if strcmp(userdata.isPlotting,'false') == 1
    isPlotting.setValue(false)
else
    isPlotting.setValue(true);
end
isPlotting.setCategory('Measurement type');
isPlotting.setDescription('Is the subject response plotted.');
isPlotting.setEditorContext(com.jidesoft.grid.BooleanCheckBoxCellEditor.CONTEXT);
list.add(isPlotting);

%--------------------------------------------------------------------------
% Prepare a properties table containing the list
model = com.jidesoft.grid.PropertyTableModel(list);
model.expandAll();
grid = com.jidesoft.grid.PropertyTable(model);
pane = com.jidesoft.grid.PropertyPane(grid);
pane.setShowToolBar(false);

%--------------------------------------------------------------------------
% Display the properties pane onscreen
set(0,'DefaultFigureMenu','none', 'DefaultFigureNumberTitle', 'off');
hFig = figure;
set(hFig,'position',[50 50 400 500],...
    'name','Slider properties')
panel = uipanel(hFig);
javacomponent(pane, [0 0 400 500], panel);

% Wait for figure window to close & display the prop values
uiwait(hFig);

disp(title.getValue());
disp(min.getValue());
disp(max.getValue());
disp(min_value.getValue());
disp(max_value.getValue());
disp(starting_value.getValue());
disp(arrow_click.getValue());
disp(trough_click.getValue());

%--------------------------------------------------------------------------
% Set the values
set(S.empty_panel,'title',title.getValue());
set(S.empty_min,'string',min.getValue());
set(S.empty_max,'string',max.getValue());
set(S.h_slider,'min',min_value.getValue());
set(S.h_slider,'max',max_value.getValue());
set(S.h_slider,'value',starting_value.getValue());

step = [arrow_click.getValue() trough_click.getValue()];
set(S.h_slider,'sliderstep',step/100)

set(S.empty_panel,'position',[from_left.getValue()/100 from_bottom.getValue()/100 ...
    width.getValue()/100 height.getValue()/100]);

% Set scroll wheel step size
userdata = get(S.h_slider,'userdata');
if isfield(userdata,'scroll_step') == 1
    userdata.scroll_step = scroll.getValue();
    set(S.h_slider,'userdata',userdata)
end

% Set font sizes
set(S.empty_panel,'fontsize',title_font.getValue());
set(S.empty_min,'fontsize',min_text_font.getValue());
set(S.empty_max,'fontsize',max_text_font.getValue());

% Set random starting value
if random_start.getValue() == 1
    range = get(S.h_slider,'max') - get(S.h_slider,'min');
    if range > get(S.h_slider,'max')
        set(S.h_slider,'value',range*rand() - ...
            abs(get(S.h_slider,'min')));
    else
        set(S.h_slider,'value',range*rand())
    end
    userdata = get(S.h_slider,'userdata');
    userdata.isRandom = 'yes';
    set(S.h_slider,'userdata',userdata)
    set(S.empty_panel,'userdata',userdata)
else
    userdata = get(S.h_slider,'userdata');
    userdata.isRandom = 'no';
    set(S.h_slider,'userdata',userdata)
    set(S.empty_panel,'userdata',userdata)
end

% Set flow control on/off
userdata = get(S.h_slider,'userdata');
if flow.getValue() == 1
    userdata.flowControl = 'on';
else
    userdata.flowControl = 'off';
end
set(S.h_slider,'userdata',userdata)

% Set flow stop message
userdata = get(S.h_slider,'userdata');
userdata.stopMessage = flow_stop.getValue();
set(S.h_slider,'userdata',userdata)
set(S.empty_panel,'userdata',userdata)

% Set plotting
if strcmp(get(S.h_slider,'tag'),'continuous_slider')
    subject_response = findobj(get(S.empty_panel,'parent'),'tag',...
        'continuous_subject_response_plot_position');
    userdata = get(S.h_slider,'userdata');
    if isPlotting.getValue() == 1
        userdata.isPlotting = 'true';
        set(subject_response,'visible','on')
    else
        userdata.isPlotting = 'false';
        set(subject_response,'visible','off')
    end
else
    subject_response = findobj(get(S.empty_panel,'parent'),'tag',...
        'subject_response_plot_position');
    userdata = get(S.h_slider,'userdata');
    if isPlotting.getValue() == 1
        userdata.isPlotting = 'true';
        set(subject_response,'visible','on')
    else
        userdata.isPlotting = 'false';
        set(subject_response,'visible','off')
    end
end
set(S.h_slider,'userdata',userdata)
set(S.empty_panel,'userdata',userdata)


% Set content related questions
userdata = get(S.h_slider,'userdata');
if isfield(userdata,'contentRelatedQuestions') == 1
    if contentRelatedQuestions.getValue() == 1
        userdata.contentRelatedQuestions = 'true';
        set(S.empty_panel,'title','contentRelatedQuestions');
    else
        userdata.contentRelatedQuestions = 'false';
    end
    
    set(S.h_slider,'userdata',userdata)
    set(S.empty_panel,'userdata',userdata)
end

end






















