function croped_data = crop_data(oridata,time)
index = 1;
for i = 1:size(oridata,1)
    if(oridata(i,1) < time)
        index = i;
    else
        break;
    end
end
croped_data = oridata(index:end, :);
end

