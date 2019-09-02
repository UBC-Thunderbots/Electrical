clear
f = fopen('/tmp/thunderbots_lps_pipe','r');
past = [];
plotting_data=[];
max=100;
samples=10;
disp_count=0;
f_hist=figure;
f_trend=figure;
while(f>0)
    s = fgetl(f);
%     if ~ischar(s), break, end
%     disp(s)
    if ischar(s)
        [A,count] = sscanf(s,'%f %f %f %f');
        past=[past;A];
        length = int32(size(past,1)/4);
        current_data=reshape(past(1:length*4),[4,length])';
        if(size(past,1)>max*4*2)
            past=past(max*4+1:end);
        end
        disp_count=disp_count+1;
    end
    if (disp_count >= samples)
        
        if(size(current_data,1)<max)
            plotting_data=current_data(:,:)
        else
            plotting_data=current_data(end-max+1:end,:);
        end
        figure(f_hist)
        for i=1:4
            subplot(2,2,i);
            hist(plotting_data(:,i));
        end
        % plot trend data
        figure(f_trend)
        % cal
        trend_data=zeros(size(plotting_data));
        % first column is total reflection
        trend_data(:,1)=sum(plotting_data,2);
        
        for i=1:4
            subplot(4,1,i);
            plot(plotting_data(:,i));
        end
        
        pause(.001);
        disp_count=0;
    end
end

