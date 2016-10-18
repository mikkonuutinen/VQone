function plotSubjectResponse(y,min,max)
global setup

% setup.cv1 = 6;
% setup.cv2 = 2;
% y = [100 50 34 56 87 23 45 22 66 88 11 22 11];
% min = 0;
% max = 100;
% setup.subject_response_plot_position = [0 0 0.5 1];

if strcmp(setup.standard,'Still PC') || strcmp(setup.standard,'Video PC')
    total_evaluations = round(setup.cv1 * setup.cv2 / 2);
elseif strcmp(setup.standard,'Still triplet')
    total_evaluations = round(setup.cv1 * setup.cv2 / 3);
else
    total_evaluations = setup.cv1 * setup.cv2;
end

if isempty(y)
    y = [100];
end

size_y = size(y);
x = 1:size_y(2);
plot( y, x, '.k', y, x, '-k', 'MarkerSize',15, 'LineWidth', 1)

hold on

% center line
y(1:total_evaluations) = (max - abs(min)) / 2;
x = 1:total_evaluations;
plot(y, x, '-k', 'LineWidth', 2)

no_of_contents = setup.cv1;
no_of_pipes = setup.cv2;

for content_number = 1:no_of_contents
    y = min:max-1;
    x(1:(abs(min)+abs(max))) = no_of_pipes*content_number;
    plot(y, x, '-k', 'LineWidth', 1)
end
axis([min max 1 total_evaluations])
set(gca,'position',setup.subject_response_plot_position,...
    'color',[1 1 1],...
    'ticklength',[0 0],...
    'fontsize',0.5);
axis ij

hold off

%axis off

end