function modifyToolbar(h_fig,toolbar)

% Prepare the new icons----------------------------------------------------
% Load the Redo icon
icon = [matlabroot filesep 'toolbox' filesep 'matlab' filesep 'icons' ...
    filesep 'greenarrowicon.gif'];
[cdata,map] = imread(icon);

% Convert white pixels into a transparent background
map(map(:,1)+map(:,2)+map(:,3)==3) = NaN;

% Convert into 3D RGB-space
cdataRedo = ind2rgb(cdata,map);
cdataUndo = cdataRedo(:,16:-1:1,:);
%--------------------------------------------------------------------------

% Add the icon (and its mirror image = undo) to the latest toolbar
% Add also move-tool and docking tools

old_buttons = findall(toolbar);
delete(old_buttons([14:17 4 : 12]))

% Undo-button
uipushtool(toolbar,...
    'cdata', cdataUndo, ...
    'tooltip','undo', ...
    'ClickedCallback','uiundo(gcbf,''execUndo'')',...
    'Separator','on',...
    'tag','undo');

% Redo-button
uipushtool(toolbar,...
    'cdata',cdataRedo, ...
    'tooltip','redo', ...
    'ClickedCallback','uiundo(gcbf,''execRedo'')',...
    'tag','redo');

end
























