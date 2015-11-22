d=load('data1d.txt')
lps=d(:,3:6)';
pos=d(:,[1,2])';
M=lps'\pos'

% this makes a lot of sense for 1d and then things started breaking down
% for 2d
%result=
%        [0    1.1967;
%         0    0.7101;
%         0   -0.7071;
%         0   -1.2589]

error=pos-M'*lps;
plot(error(1,:))
hold on;plot(error(2,:)); hold off
