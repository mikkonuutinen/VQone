function radio_prop_editor(S)
% Open the property editor window for radio button components in the QBU
%
% Argument S is the handle to the particular radio button component
% S must also include userdata-field with the following structure:
%   userdata.question = 'Component related question';
%   userdata.flowControl = 'on or off';
%   userdata.isTouched = 'true or false';
%
% NOTICE: Written with Java-syntax using JIDE component library

% Initialize JIDE's usage within Matlab
com.mathworks.mwswing.MJUtilities.initJIDE;

% Prepare the properties list:
list = java.util.ArrayList();

%--------------------------------------------------------------------------
texts = com.jidesoft.grid.DefaultProperty();
texts.setName('Question');
texts.setType(javaclass('cellstr',1));
texts.setValue(get(S.panel,'title'));
texts.setCategory('Strings');
texts.setDisplayName('Question');
texts.setDescription('Set the open question string');
texts.setEditable(true);
list.add(texts);

% Char array for left string
left = com.jidesoft.grid.DefaultProperty();
left.setName('Left value text');
left.setType(javaclass('char',1));
left.setValue(get(S.button(1),'string'));
left.setCategory('Strings');
left.setDisplayName('Left value text');
left.setDescription('Set the text for left value, empty box means no text');
left.setEditable(true);
list.add(left);

% Char array for right string
right = com.jidesoft.grid.DefaultProperty();
right.setName('Right value text');
right.setType(javaclass('char',1));
right.setValue(get(S.button(2),'string'));
right.setCategory('Strings');
right.setDisplayName('Right value text');
right.setDescription('Set the text for right value, empty box means no text');
right.setEditable(true);
list.add(right);

%--------------------------------------------------------------------------
% Integer boxes for fontsizes
% Title font size
title_font = com.jidesoft.grid.DefaultProperty();
title_font.setName('Title font size');
title_font.setType(javaclass('int32'));
title_font.setValue(get(S.panel,'fontsize'));
title_font.setCategory('Font sizes');
title_font.setDescription('Set font size for the question text');
list.add(title_font);
% Min text font size
left_text_font = com.jidesoft.grid.DefaultProperty();
left_text_font.setName('Title font size');
left_text_font.setType(javaclass('int32'));
left_text_font.setValue(get(S.button(1),'fontsize'));
left_text_font.setCategory('Font sizes');
left_text_font.setDescription('Set font size for the left text');
list.add(left_text_font);
% Max text font size
right_text_font = com.jidesoft.grid.DefaultProperty();
right_text_font.setName('Title font size');
right_text_font.setType(javaclass('int32'));
right_text_font.setValue(get(S.button(2),'fontsize'));
right_text_font.setCategory('Font sizes');
right_text_font.setDescription('Set font size for the right text');
list.add(right_text_font);

%--------------------------------------------------------------------------
% Panel position
position = get(S.panel,'position');

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
% Check box for flow control
flow = com.jidesoft.grid.DefaultProperty();
flow.setName('Is flow control on?');
flow.setType(javaclass('logical'));
userdata = get(S.panel,'userdata');
if strcmp(userdata.flowControl,'off') == 1
    flow.setValue(false)
else
    flow.setValue(true);
end
flow.setCategory('Flow control');
flow.setDescription('Does the text box have to be filled before continuing');
flow.setEditorContext(com.jidesoft.grid.BooleanCheckBoxCellEditor.CONTEXT);
list.add(flow);

%--------------------------------------------------------------------------
% Char array for flow stop message
flow_stop = com.jidesoft.grid.DefaultProperty();
flow_stop.setName('Flow stop message');
flow_stop.setType(javaclass('char',1));
flow_stop.setValue('Et vastannut kaikkiin kysymyksiin');
flow_stop.setCategory('Flow control');
flow_stop.setDisplayName('Flow stop message');
flow_stop.setDescription('Set the flow stop message for dialog box');
flow_stop.setEditable(true);
list.add(flow_stop);

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
    'name','Open question properties')
panel = uipanel(hFig);
javacomponent(pane, [0 0 400 500], panel);

% Wait for figure window to close & display the prop values
uiwait(hFig);
disp(texts.getValue());

% Set font sizes
set(S.panel,'fontsize',title_font.getValue());
set(S.button(1),'fontsize',left_text_font.getValue());
set(S.button(2),'fontsize',right_text_font.getValue());

% Set strings
set(S.panel,'title',char(texts.getValue()));
set(S.button(1),'string',char(left.getValue()));
set(S.button(2),'string',char(right.getValue()));

%Set position
set(S.panel,'position',[from_left.getValue()/100 from_bottom.getValue()/100 ...
    width.getValue()/100 height.getValue()/100]);

% Set flow control on/off
userdata = get(S.panel,'userdata');
if flow.getValue() == 1
    userdata.flowControl = 'on';
else
    userdata.flowControl = 'off';
end
set(S.panel,'userdata',userdata)
set(S.button(1),'userdata',userdata)
set(S.button(2),'userdata',userdata)

% Set flow stop message
userdata = get(S.panel,'userdata');
userdata.stopMessage = flow_stop.getValue();
set(S.panel,'userdata',userdata)
set(S.button(1),'userdata',userdata)
set(S.button(2),'userdata',userdata)
disp(userdata)

end