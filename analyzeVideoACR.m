function analyzeStillACR()

% Function that analyzes the subject input data (video ACR) and shows
% means with confidence intervals (95%)
%
% Global variables needed:
%   - setup: data about the test and subject is read from here

global setup

disp('Video ACR selected');

% Microsoft Excel file path
File = [pwd filesep 'setups' filesep setup.name filesep setup.name ...
        '_data.xls']
    
% Reads data from the 'Test data' worksheet of file named 'File' and
% returns the numeric data in array ndata, text fields in cell array text
% and unprocessed data (numbers and text) in cell array alldata
[ndata text alldata] = xlsread(File,'Test data');
% Reads subject data from the 'Subject data' worksheet
subject_data = xlsread(File,'Subject data');

% Random ordered data is sorted in order of file names and subject number
subject_column_nr=find(strcmp(text(1,:),'Subject number'),1);
videoFile_column_nr=find(strcmp(text(1,:),'video_file'),1);
content_column_nr=find(strcmp(text(1,:),'CV 1'),1)
image_column_nr=find(strcmp(text(1,:),'CV 2'),1)


[ndata_sorted b] = sortrows(ndata,[content_column_nr image_column_nr]);
for i=1:size(b);
    text_sorted(i,:)=text(b(i)+1,:);
end
%text_sorted(:,15)

% file_vector includes file_names; data_matrix includes numeric data and
% text_vector includes variables
file_vector(:,1)=text_sorted(:,videoFile_column_nr);
data_matrix(:,1)=ndata_sorted(:,subject_column_nr);
text_vector = text(1,subject_column_nr);


names =  load([pwd filesep 'setups' filesep setup.name filesep 'names.mat']);
for i=1:size(names.components,2)
    row=find(strcmp(text(1,:),names.components{i}),1);
    data_matrix = [data_matrix  ndata_sorted(:,row)];
    text_vector = [text_vector text(1,row)];
end
if (size(text_vector)<10)
    for i=size(text_vector)+1:10
        text_vector = [text_vector '  '];
    end
end

scoreType=2;
visualizationType=1

% computes means and standard deviations for scale values 
for i=1:size(data_matrix,1)/size(subject_data,1);
    data_matrix_mean(i,:)=mean(data_matrix(1+(i-1)*size(subject_data,1):i*size(subject_data,1),:));
    data_matrix_std(i,:)=std(data_matrix(1+(i-1)*size(subject_data,1):i*size(subject_data,1),:));
end

 
   %  Create and then hide the GUI as it is being constructed.
   f = figure('Visible','off','Position',[360,500,750,385]);
   %  Construct the components.
   htext1 = uicontrol('Style','text','String','Select Data',...
          'Position',[500,340,160,15]);
   hpopup1 = uicontrol('Style','popupmenu',...
          'String',{text_vector{2},text_vector{3},text_vector{4},text_vector{5},text_vector{6},text_vector{7},text_vector{8},text_vector{9},text_vector{10}},...
          'Position',[500,310,160,25],...
          'Callback',{@popup1_menu_Callback});
   hpopup2 = uicontrol('Style','popupmenu',...
          'String',{'All','Scenes'},...
          'Position',[500,280,160,25],...
          'Callback',{@popup2_menu_Callback});
   htext2 = uicontrol('Style','text','String','Plot data',...
          'Position',[500,240,160,15]);
   hhist = uicontrol('Style','pushbutton','String','Histogram',...
          'Position',[500,210,170,25],...
          'Callback',{@histbutton_Callback});
   hmean = uicontrol('Style','pushbutton','String','Mean values and CI95%',...
          'Position',[500,180,170,25],...
          'Callback',{@meanbutton_Callback});
   hstdev1 = uicontrol('Style','pushbutton',...
          'String','STDEV as a function of means',...
          'Position',[500,150,170,25],...
          'Callback',{@stdev1button_Callback});
   hstdev2 = uicontrol('Style','pushbutton',...
          'String','STDEV as a function of the #subjects',...
          'Position',[500,120,170,25],...
          'Callback',{@stdev2button_Callback}); 
   htext3 = uicontrol('Style','text','String','Save data',...
          'Position',[500,80,160,15]);
   hsaveMean = uicontrol('Style','pushbutton','String','Mean values and CI95%',...
          'Position',[500,50,170,25],...
          'Callback',{@savebutton_Callback});
      
   ha = axes('Units','Pixels','Position',[55,45,400,310]); 
   align([hhist,hmean,hstdev1,hstdev2,htext1,hpopup1,hpopup2,hsaveMean,htext2,htext3],'Center','None');

   
   set([hhist,hmean,hstdev1,hstdev2,htext1,hpopup1,hpopup2,hsaveMean,htext2,htext3],...
   'Units','normalized');
   current_data = data_matrix(:,scoreType);
    
   set(f,'Name','ACR data analysis')
   movegui(f,'center')
   set(f,'Visible','on');
 
  
% Selects data set
  function popup1_menu_Callback(source,eventdata) 
    current_data=[]
    visualizationType = get(hpopup2,'Value')
    scoreType = get(source,'Value')+1;
    
    if (visualizationType==2)
        max(ndata(:,3))
        n=1;
        for k=1:max(ndata(:,3));
            for i=1:size(data_matrix,1) 
                if (ndata(i,3)==k)
                    current_data(n,k) = data_matrix(i,scoreType);
                    n=n+1;
                end
            end
            n=1;
        end
    else
        current_data = data_matrix(:,scoreType);  
    end 
  end


% Selects all data or content-specific visualization
  function popup2_menu_Callback(source,eventdata) 
    
    current_data=[]
    visualizationType = get(source,'Value')
    scoreType = get(hpopup1,'Value')+1;
    if (visualizationType==2)
        max(ndata(:,3))
        n=1;
        for k=1:max(ndata(:,3));
            for i=1:size(data_matrix,1) 
                if (ndata(i,3)==k)
                    current_data(n,k) = data_matrix(i,scoreType);
                    n=n+1;
                end
            end
            n=1;
        end
    else
        current_data = data_matrix(:,scoreType);  
    end 
  end



% Plots data histogram
  function histbutton_Callback(source,eventdata) 
      if (visualizationType==2)
            
            scrsz = get(0,'ScreenSize');
            figure('Position',[100 100 scrsz(3)/1.2 scrsz(4)/1.2])
            
            for (k=1:max(ndata(:,3)))
                floor(max(ndata(:,3))/2)
                
                if (max(ndata(:,3))>3)
                    subplot(floor(max(ndata(:,3))/2),floor(max(ndata(:,3))/2),k)
                else
                    subplot(1,3,k)
                end
                hist(current_data(:,k))
                title(['Scene: ',num2str(k)])
                xlabel(text_vector{scoreType})
                ylabel('# of occurances')
            end
            
      else
            set(f,'Visible','on');
            hist(current_data)
            title('Data histogram')
            xlabel(text_vector{scoreType})
            ylabel('# of occurances')
      end
  end



% Plots data mean and 95% CI values
  function meanbutton_Callback(source,eventdata)
      data_matrix_mean=[];
      data_matrix_std=[];
      if (visualizationType==2)
          for k=1:max(ndata(:,3));
            for i=1:size(current_data,1)/size(subject_data,1);
                data_matrix_mean(i,k)=mean(current_data(1+(i-1)*size(subject_data,1):i*size(subject_data,1),k));
                data_matrix_std(i,k)=std(current_data(1+(i-1)*size(subject_data,1):i*size(subject_data,1),k));
            end          
          end
          
          scrsz = get(0,'ScreenSize');
          figure('Position',[100 100 scrsz(3)/1.2 scrsz(4)/1.2])
            
          for (k=1:max(ndata(:,3)))
            ci(:,k)=(1.96*data_matrix_std(:,k)/sqrt(size(subject_data,1)));
                
            if (max(ndata(:,3))>3)
                    subplot(ceil(max(ndata(:,3))/2),floor(max(ndata(:,3))/2),k)
            else
                    subplot(1,3,k)
            end
            
            errorbar(data_matrix_mean(:,k),ci(:,k));
            title(['Content: ',num2str(k)])
            xlabel('Sample No')
            ylabel(text_vector{scoreType})
          end    
   
      else
            for i=1:size(current_data)/size(subject_data,1);
                data_matrix_mean(i,1)=mean(current_data(1+(i-1)*size(subject_data,1):i*size(subject_data,1),1));
                data_matrix_std(i,1)=std(current_data(1+(i-1)*size(subject_data,1):i*size(subject_data,1),1));
            end
            ci=(1.96*data_matrix_std(:,1)/sqrt(size(subject_data,1)));
            set(f,'Visible','on');
            errorbar(data_matrix_mean(:,1),ci);
            title('Mean values and confidence intervals 95 %')
            xlabel('Sample No')
            ylabel(text_vector{scoreType})
      end
  end



% Plots data standard deviation values as a function of means
  function stdev1button_Callback(source,eventdata)
      data_matrix_mean=[];
      data_matrix_std=[];
      if (visualizationType==2)
        for k=1:max(ndata(:,3));
            for i=1:size(current_data,1)/size(subject_data,1);
                data_matrix_mean(i,k)=mean(current_data(1+(i-1)*size(subject_data,1):i*size(subject_data,1),k));
                data_matrix_std(i,k)=std(current_data(1+(i-1)*size(subject_data,1):i*size(subject_data,1),k));
            end          
        end
          scrsz = get(0,'ScreenSize');
          figure('Position',[100 100 scrsz(3)/1.2 scrsz(4)/1.2])
        for k=1:max(ndata(:,3));
            data_comp(:,1)=data_matrix_mean(:,k);
            data_comp(:,2)=data_matrix_std(:,k);
            [a b]=sort(data_comp,1);
            for i=1:size(data_comp,1);
                data_sort(i,:)=data_comp(b(i),:);
            end
            if (max(ndata(:,3))>3)
                    subplot(ceil(max(ndata(:,3))/2),floor(max(ndata(:,3))/2),k)
            else
                    subplot(1,3,k)
            end
            
            plot(data_sort(:,1),data_sort(:,2));
            title(['Content: ',num2str(k)])
            xlabel(text_vector{scoreType})
            ylabel('stdev')
            clear data_comp;
            clear data_sort;
        end
      
      else
        for i=1:size(current_data)/size(subject_data,1);
            data_matrix_mean(i,:)=mean(current_data(1+(i-1)*size(subject_data,1):i*size(subject_data,1),1));
            data_matrix_std(i,:)=std(current_data(1+(i-1)*size(subject_data,1):i*size(subject_data,1),1));
        end
        
        data_comp(:,1)=data_matrix_mean(:,1);
        data_comp(:,2)=data_matrix_std(:,1);
        [a b]=sort(data_comp,1);
        for i=1:size(data_comp,1);
            data_sort(i,:)=data_comp(b(i),:);
        end
        plot(data_sort(:,1),data_sort(:,2));
        title('Standard deviations as a function of means')
        xlabel(text_vector{scoreType})
        ylabel('stdev')
      end
  end



% Plots standard deviation values as a function of the number of subjects
  function stdev2button_Callback(source,eventdata)
      
      if (visualizationType==2)
          disp('Value available only for all data')
      else
          
          for i=1:(size(current_data)/size(subject_data,1));
        data_matrix_images(:,i)=current_data(1+(i-1)*size(subject_data,1):i*size(subject_data,1),1);
      end
    
      n=size(subject_data,1);
      products=size(current_data)/size(subject_data,1);
      
      for NoO=1:n; %NoO parametri määrittää koehenkilömäärän jota tutkitaan
          
        for k=1:products;
            for i=1:n;
                selected_numbers=[];
                rand_numbers=randperm(n);
                selected_numbers=rand_numbers(1:NoO); % valitaan satunnaiset koehenkilöt
                data_matrix_images_stdev(i,k)=std(data_matrix_images(selected_numbers,k));
            end
            ave(k)=mean(data_matrix_images_stdev(:,k));
        end
        data_matrix_images_stdev_ave(1,NoO)=mean(ave);
      end
      
      plot(1:NoO,data_matrix_images_stdev_ave(1,1:NoO)) 
      title('Standard deviation value as a function of amount of subjects')
      xlabel('Number of subjects')
      ylabel('stdev')
      end
  end

% Save mean values 
 function savebutton_Callback(source,eventdata)
      data_matrix_mean=[];
      data_matrix_std=[];
      
      current_data = data_matrix(:,scoreType);  
      
     
            for i=1:size(current_data)/size(subject_data,1);
                data_matrix_mean(i,1)=mean(current_data(1+(i-1)*size(subject_data,1):i*size(subject_data,1),1));
                data_matrix_std(i,1)=std(current_data(1+(i-1)*size(subject_data,1):i*size(subject_data,1),1));
                filenames_info(i,1) =  file_vector(i*size(subject_data,1),1);
                content_number(i,1) = ndata_sorted(i*size(subject_data,1),3);
            end
            ci=(1.96*data_matrix_std(:,1)/sqrt(size(subject_data,1)));
            
            data(:,1)=num2cell(content_number);
            data(:,2)=filenames_info;
            data(:,3)=num2cell(data_matrix_mean);
            data(:,4)=num2cell(ci);
            xlswrite('data_mean_ci.xlsx',data)

        %set(hpopup2,'Value',1)
        get(hpopup2,'Value')
        popup2_menu_Callback(hpopup2)
  end
end



