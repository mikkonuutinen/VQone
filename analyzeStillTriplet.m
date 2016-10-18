function analyzeStillTriplet()

% Function that analyzes the subject input data (still triplet) and shows
% probability values
%
% Global variables needed:
%   - setup: data about the test and subject is read from here

global setup
global prob_data_sort
global pipes_count
visualizationType=1;

disp('still triplet selected');

% Microsoft Excel file path
File = [pwd filesep 'setups' filesep setup.name filesep setup.name ...
        '_data.xls']

% Reads subject data from the 'Subject data' worksheet
subject_data = xlsread(File,'Subject data');

contents_count=setup.cv1;
pipes_count=setup.cv2;


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% computes how many times one image is selected better than other
% (cumulative frequency)

for i=1:contents_count;
    [mdata(:,:,i) mtext malldata] = xlsread(File,['Content ' num2str(i) ' matrices']);
    matrix_data(:,:,i)=mdata(size(mdata,1)-pipes_count+1:size(mdata,1),2:pipes_count+1,i);
end

% computes the probability p for cumulatibe frequency n (p=(N+n)/2N where N = number of observers)  
N=size(subject_data,1);
for i=1:contents_count;
    for k=1:size(matrix_data,1);
        for l=1:size(matrix_data,2);
            matrix_prob(k,l,i)=(N+matrix_data(k,l,i))/(2*N);
        end
    end
end
matrix_prob(:,:,1)

% computes how many times one image is selected better than other

for i=1:contents_count;
    count_data(:,i)=mean(matrix_prob(:,:,i),2);
end
%count_data(:,1)


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Greate GUI

text_vector=[];
for ii=1:contents_count;
    text_vector{ii} = ['Scene ',num2str(ii)];
end
if (size(text_vector)<10)
    for i=size(text_vector)+1:10
        text_vector = [text_vector '  '];
    end
end


%  Create and then hide the GUI as it is being constructed.
   f = figure('Visible','off','Position',[360,500,750,385]);
   %  Construct the components.
   htext1 = uicontrol('Style','text','String','Select Scene',...
          'Position',[500,340,160,15]);
   hpopup1 = uicontrol('Style','popupmenu',...
          'String',{text_vector{1},text_vector{2},text_vector{3},text_vector{4},text_vector{5},text_vector{6},text_vector{7},text_vector{8},text_vector{9},text_vector{10}},...
          'Position',[500,310,160,25],...
          'Callback',{@popup1_menu_Callback});

   ha = axes('Units','Pixels','Position',[55,45,400,310]); 
   align([htext1,hpopup1],'Center','None');

      
   set(f,'Name','Triplet data analysis')
   movegui(f,'center')
   set(f,'Visible','on');
      
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% computes probability that one image is better than the other images

%prob_data(1:pipes_count,2:size(count_data,2)+1)=count_data/((pipes_count-1)*size(subject_data,1));
prob_data(1:pipes_count,2:size(count_data,2)+1)=count_data;

%data_matrix=zeros(pipes_count,pipes_count,contents_count);
for i=1:pipes_count;
    prob_data(i,1)=i;
end
[a b]=sort(prob_data);
for k=2:contents_count+1;
    for i=1:pipes_count;
        prob_data_sort(i,k)=prob_data(b(i,k),k);
    end    
end
    set(f,'Visible','on');
    plot(1:pipes_count,prob_data_sort(:,visualizationType+1),'*')
    title(['Scene ' num2str(visualizationType)])
    ylabel('Probability')
    for i=1:pipes_count;
        %image=num2str(b(i,k))
        text(i,prob_data_sort(i,visualizationType+1),num2str(b(i,visualizationType+1)))
    end

    
function popup1_menu_Callback(source,eventdata) 
    
    visualizationType = get(source,'Value')
    
    if (visualizationType<contents_count+1)
        %figure;plot(1:pipes_count,prob_data_sort(:,visualizationType),'*')
        set(f,'Visible','on');
        plot(1:pipes_count,prob_data_sort(:,visualizationType+1),'*')
        %plot(1:pipes_count,prob_data_sort(:,visualizationType),'*')
        title(['Scene ' num2str(visualizationType)])
        ylabel('Probability')
        for i=1:pipes_count;
            %image=num2str(b(i,k));
            text(i,prob_data_sort(i,visualizationType+1),num2str(b(i,visualizationType+1)))
        end
    end
    
end




end
