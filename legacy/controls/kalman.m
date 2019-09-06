%standard deviation of the acceleration "noise"
astd = sqrt(0.3);

%stanard deviation of the measurement "noise"
mstd = sqrt(0.05);


%length of time per step
timestep = 1/15;

%number of steps per simulation
steps = 1000;


%the state vector over time, both the kalman estimation and the real value
%x(1,:) - positions
%x(2,:) - velocities
xreal=zeros(2,steps);
xguess=zeros(2,steps);

%estimate covariance (or at least proportional too)
P=eye(2);


%something to keep track of time
t=zeros(1,steps);

%the state update matrix (get next state given current one
A=[1 timestep;0 1];

%the acceleration to state vector (given an acceleration, what is the state
%update)
G=[timestep.^2/2; timestep];

%The amount of uncertainty gained per step
Q=G*G'*astd^2;

%the state measurement operator
H=[1 0];

for i=2:steps
    
    t(i) = t(i-1)+timestep;
    
    %actual model run to simulate this time step
    a = randn(1,1)*astd;
    xreal(:,i) = A*xreal(:,i-1) + G*a;
    
    %take a measurement (camera frame)
    measurement = xreal(1,i) + mstd*randn(1,1);
    
    
    
    %predict the current state and covariance given previous measurments
    xtemp = A*xguess(:,i-1);
    Ptemp = A*P*A' + Q;
    
    %how much does the guess differ from the measurement
    residual = measurement - H*xtemp;
    
    %The kalman update calculations
    Kalman_gain = Ptemp*H'/(H*Ptemp*H' + mstd^2);
    xguess(:,i) = xtemp + Kalman_gain*residual;
    P = (eye(2) - Kalman_gain*H)*Ptemp;
end