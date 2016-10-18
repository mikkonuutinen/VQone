function roadBlock(monitor)

global setup

% Main figure %--------------------------------------------------------
%
h_fig = figure('position', monitor,...
    'name','Continue options', ...
    'tag','roadblock'); %[449 -763 1024 742]

h_panel = uipanel(h_fig, ...
    'units','normalized', ...
    'Position',[0.05 0.05 0.9 0.9],...
    'title','',...
    'fontsize',12);

if setup.referencing_enabled
    uicontrol(h_panel,...
        'style','pushbutton', ...
        'Units', 'Normalized', ...
        'position',[0.35 0.55 0.3 0.1],...
        'CallBack',@watch_references_again,...
        'tag','preview_randomizing', ...
        'string','Katso referenssit uudestaan', ...
        'FontSize', 14);
end

uicontrol(h_panel,...
    'style','pushbutton', ...
    'Units', 'Normalized', ...
    'position',[0.35 0.35 0.3 0.1],...
    'CallBack',@continue_to_questions,...
    'tag','preview_randomizing', ...
    'string','Siirry arviointiin', ...
    'FontSize', 14);

uiwait;


end
%%% CALLBACKS %%%----------------------------------------------------------

function watch_references_again(~,~)
global action
action = 1;
close;
return
end

function continue_to_questions(~,~)
global action
action = 2;
close;
return
end













