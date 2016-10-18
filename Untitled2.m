for i=1:2:size(data,1)
    if (data(i,3)==1)
        data1(data(i,1),data(i,2))=data1(data(i,1),data(i,2))+1;
    end
    if (data(i,3)==2)
        data2(data(i,1),data(i,2))=data2(data(i,1),data(i,2))+1;
    end
    if (data(i,3)==3)
        data3(data(i,1),data(i,2))=data3(data(i,1),data(i,2))+1;
    end
end