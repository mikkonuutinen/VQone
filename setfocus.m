function setfocus(h)
%
%
%  setfocus forces a mouseclick in the upper left corner of the
%  object with the handle h.
%  

% $Revision: 1.3 $
% $Date: 2002/06/27 12:41:01 $
% $Author: weber $
%
% Update: 2010/10/05 Rummukainen
% Use java.awt.Robot class to emulate mouse clicks
%

if nargin<1
    error('No input handle defined!')
end

if ~ishandle(h) 
    error('Input must be a handle!');
end


callback='';

% Create robot object to emulate mouse clicks
robot = java.awt.Robot; 

% When the object is a 'uicontrol' the function of the object would be 
% executed. Therefore I have to set it to '', and set it back after the mouseclick

if strcmp(get(h, 'Type'), 'uicontrol')
    callback=get(h, 'Callback');
    set(h, 'Callback', '');
    drawnow; % Update the figure data
end


figh=get(h, 'Parent');
% Check if the object's parent is a uipanel and get the real fig
if strcmp(get(figh,'type'),'uipanel')
    figh = get(figh,'parent');
end
unit_root=get(0, 'Unit');
unit_fig=get(figh, 'Unit');
unit_obj=get(h, 'Unit');
set(0, 'Units', 'pixels');
set(figh, 'Units', 'pixels');
set(h, 'Units', 'pixels');
drawnow;

% get the current mouse pointer coordinates 
mouse_coord=get(0, 'PointerLocation');
fig_pos=get(figh, 'Position');
obj_pos=get(h, 'Position');

act_pos=fig_pos+obj_pos;
act_pos=act_pos(1:2);
act_pos(1)=act_pos(1)+10;
act_pos(2)=act_pos(2)+obj_pos(4)-15;

% set the mouse pointer to the upper left corner of the object
% (I did this for listboxes, to highlight the first entry)

set(0, 'PointerLocation', act_pos);

% Use the robot to emulate mouse click
robot.mousePress  (java.awt.event.InputEvent.BUTTON1_MASK);
robot.mouseRelease(java.awt.event.InputEvent.BUTTON1_MASK);

%mouseclick; %simulate the mouseclick


%-----------------------------------------------------------------------------
% set all parameters that were changed back to the starting values

%set(0, 'PointerLocation', mouse_coord);

if strcmp(get(h, 'Type'), 'uicontrol')
    drawnow;   % When there is no 'drawnow', the original Callback- String
               % will be executed, even the Callback String is set to '';
    set(h, 'Callback', callback);
end

set(0, 'Unit', unit_root);
set(figh, 'Unit', unit_fig);
set(h, 'Unit', unit_obj);
drawnow;
