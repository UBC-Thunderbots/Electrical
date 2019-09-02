load test;

subplot(1,2,1);
plot(test(:,1),test(:,2));
hold on;
plot(downsample(test(:,1),13),downsample(test(:,2),13),'gx')
subplot(1,2,2);
plot(test(:,3));
hold on;
plot(downsample(1:length(test),13),downsample(test(:,3),13),'gx');