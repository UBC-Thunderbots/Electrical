clear
f = fopen('/tmp/thunderbots_lps_pipe','r');
past = [];
max=100;
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
        if(size(current_data,1)<max)
            plot(current_data(:,1))
        else
            plot(current_data(end-max+1:end,1))
        end
        pause(.001);
    end
end

