function checkbox_prop_editor(S)
% Open the property editor window for checkbox components in the QBU
%
% Argument S is the handle to the particular checkbox component
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
texts.setValue(get(S,'string'));
texts.setCategory('Strings');
texts.setDisplayName('Question');
texts.setDescription('Set the checkbox question string');
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
    'name','Checkbox properties')
panel = uipanel(hFig);
javacomponent(pane, [0 0 400 500], panel);

% Wait for figure window to close & display the prop values
uiwait(hFig);
disp(texts.getValue());

% Set font sizes
set(S,'fontsize',question_font.getValue());

% Set question string
set(S,'string',char(texts.getValue()));

% Set checkbox position
set(S,'position',[from_left.getValue()/100 from_bottom.getValue()/100 ...
    width.getValue()/100 height.getValue()/100]);

end



