d=load('data.txt')
lps=[d(:,3:6)';abs(d(:,3:6)');(d(:,3:6)').^2];
pos=d(:,[1,2])';
M=lps'\pos'

% this makes a lot of sense for 1d and then things started breaking down
% for 2d
%result=
%        [0    1.1967;
%         0    0.7101;
%         0   -0.7071;
%         0   -1.2589]

test=load('data_confirm.txt');


error=pos-M'*lps;
lps=[test(:,3:6)';abs(test(:,3:6)');(test(:,3:6)').^2];
pos=test(:,[1,2])';
error2=pos-M'*lps;
plot(error(1,:))
hold on;plot(error(2,:)); 
plot(error2(1,:))
plot(error2(2,:)); hold off

lps_moment_x=M(1:4,1)'
lps_moment_y=M(1:4,2)'
lps_abs_x=M(5:8,1)'
lps_abs_y=M(5:8,2)'
lps_variance_x=M(9:12,1)'
lps_variance_y=M(9:12,2)'