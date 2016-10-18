function plotContinuousSubjectResponse(y,min,max,total_length)

global setup

if isempty(y)
    y = min;
end

% Plot the answers
size_y = size(y);
x = 1:size_y(2);
plot( x, y, '.k', x, y, '-k', 'MarkerSize',15, 'LineWidth', 1)

hold on

% Draw the axes
% center line
center_line(1:total_length) = (max - abs(min)) / 2;
x = 1:total_length;
plot(x, center_line, '-k', 'LineWidth', 2)

axis([1 total_length min max])
set(gca,'position',setup.continuous_subject_response_plot_position,...
    'color',[1 1 1],...
    'ticklength',[0 0],...
    'fontsize',0.5);

hold off

end