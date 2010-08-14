load data.csv
plot(data(:,end),data(:,1:(end-1)))
legend('displacement','velocity','force','voltage','current','flux');