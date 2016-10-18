function popup_prop_editor(S)
% Open the property editor window for popup components in the QBU
%
% Argument S is the handle to the particular popup component
% S must also include userdata-field with the following structure:
%   userdata.question = 'Component related question';
%   userdata.flowControl = 'on or off';
%   userdata.isTouched = 'true or false';
%   userdata.stopMessage = 'stop message';
%
% NOTICE: Written with Java-syntax using JIDE component library

% Initialize JIDE's usage within Matlab
com.mathworks.mwswing.MJUtilities.initJIDE;

% Prepare the properties list:
list = java.util.ArrayList();

%--------------------------------------------------------------------------
texts = com.jidesoft.grid.DefaultProperty();
texts.setName('Options');
texts.setType(javaclass('cellstr',1));
texts.setValue(get(S,'string'));
texts.setCategory('Strings');
texts.setDisplayName('Options');
texts.setDescription(strcat('Set the multiple choice strings. First string',...
' is the question. First character of the question must not be a number!'));
texts.setEditable(true);
list.add(texts);

%--------------------------------------------------------------------------
% Integer boxes for fontsizes
% Title font size
question_font = com.jidesoft.grid.DefaultProperty();
question_font.setName('Question font size');
question_font.setType(javaclass('int32'));
question_font.setValue(get(S,'fontsize'));
question_font.setCategory('Strings');
question_font.setDescription('Set font size for the question text');
list.add(question_font);

%--------------------------------------------------------------------------
% Panel position
position = get(S,'position');

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
userdata = get(S,'userdata');
if strcmp(userdata.flowControl,'off') == 1
    flow.setValue(false)
else
    flow.setValue(true);
end
flow.setCategory('Flow control');
flow.setDescription('Does the popup have to be touched before continuing');
flow.setEditorContext(com.jidesoft.grid.BooleanCheckBoxCellEditor.CONTEXT);
list.add(flow);

%--------------------------------------------------------------------------
% Char array for flow stop message
flow_stop = com.jidesoft.grid.DefaultProperty();
flow_stop.setName('Flow stop message');
flow_stop.setType(javaclass('char',1));
userdata = get(S,'userdata');
flow_stop.setValue(userdata.stopMessage);
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
    'name','Multiple choice properties')
panel = uipanel(hFig);
javacomponent(pane, [0 0 400 500], panel);

% Wait for figure window to close & display the prop values
uiwait(hFig);
disp(texts.getValue());

% Set the new values
values = texts.getValue();
for i = 1 : length(values)
    strings{i} = char(values(i));
end

% Set font sizes
set(S,'fontsize',question_font.getValue());

% Set question string
set(S,'string',strings);

% Set position
set(S,'position',[from_left.getValue()/100 from_bottom.getValue()/100 ...
    width.getValue()/100 height.getValue()/100]);

% Set flow control on/off
userdata = get(S,'userdata');
if flow.getValue() == 1
    userdata.flowControl = 'on';
else
    userdata.flowControl = 'off';
end
set(S,'userdata',userdata)

% Set flow stop message
userdata = get(S,'userdata');
userdata.stopMessage = flow_stop.getValue();
set(S,'userdata',userdata)

disp(userdata)

end

















