function triplet_prop_editor(S)
% Open the property editor window for the triplet slider component in the QBU
%
% Argument S is the handle to the triplet slider component including 
% three individual sliders.
%
% S must also include userdata-field with the following structure for the
% three sliders:
%   userdata.isRandom = 'yes or no';
%   userdata.flowControl = 'on or off';
%   userdata.stopMessage = 'message for preventing continuing';
%   userdata.isTouched = 'true or false';
%   userdata.question = 'slider's question';
%
% NOTICE: Written with Java-syntax using JIDE component library


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
title.setDescription('Set the title of the slider group, empty box means no title');
title.setEditable(true);
list.add(title);

%--------------------------------------------------------------------------
% Integer boxes for fontsizes
% Title font size
question_font = com.jidesoft.grid.DefaultProperty();
question_font.setName('Question font size');
question_font.setType(javaclass('int32'));
question_font.setValue(get(S.empty_panel,'fontsize'));
question_font.setCategory('Strings');
question_font.setDescription('Set font size for the question text');
list.add(question_font);

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

%--------------------------------------------------------------------------
% Set the values
set(S.empty_panel,'title',title.getValue());

% Set font sizes
set(S.empty_panel,'fontsize',question_font.getValue());

% Set position
set(S.empty_panel,'position',[from_left.getValue()/100 from_bottom.getValue()/100 ...
    width.getValue()/100 height.getValue()/100]);

end




