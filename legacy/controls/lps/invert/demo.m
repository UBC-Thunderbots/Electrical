theta=linspace(0,2*pi, 100);
sin(theta)
A=[sin(theta);cos(theta)];
M=[1,0;0,1];
B=M*A;
M
A'\B'