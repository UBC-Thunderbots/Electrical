%% Input Parameters %%
%% The x_vel required (forward is positive, m/s)
x_vel = 50/1000;
%% The y position changed required (left is positive, in m)
y_pos = 300/1000;
%% The required theta position to rotate (left is positive, in radians)
theta = 30*(pi/180);
%% Simulation Length (number of steps)
sim_length = 400;

%% Robot Parameters %%
%% The robot's x position, in dr coordinates (m)
%% The robot's y position, in dr coordinates (m)
%% The robot's theta coordinate, in dr coordinates (radians)
%% Measures how far the robot has rotated its own coordinate system 
%% to the left relative to its initial position
dr_pos = [0, 0, 0];

%% The robot's x velocity, in dr coordinates (m/s)
%% The robot's y velocity, in dr coordinates (m/s)
%% The robot's angular velocity (rad/s)
dr_vel = [0, 0, 0];

%% The robot's x acceleration, in local coordinates (m/s^2)
%% The robot's y acceleration, in local coordinates (m/s^2)
%% The robot's angular acceleration, in local coordinates (rad/s^2)
acc = [0, 0, 0];

%% Constants %%
time_step = 1/200;%s
x_vel_max = 2;%m/s
y_vel_max = 1;%m/s
avel_max = 1;%rad/s
x_acc_max = 3;%m/s^2
y_acc_max = 3;%m/s^2
max_vy_step = y_acc_max*time_step;
aacc_max = 20;%rad/s^2
space_factor = 0.01;

time = 0;
path = zeros(3, sim_length);
for i = 1:sim_length
  %% Record Path (in terms of final axis)
  path(1,i) = dr_pos(1)*cos(theta)+dr_pos(2)*sin(theta);
  path(2,i) = dr_pos(1)*-sin(theta)+dr_pos(2)*cos(theta);
  path(3,i) = dr_pos(3);
  %% Step each value
  dr_pos(1) = dr_pos(1) + dr_vel(1) * time_step;
  dr_pos(2) = dr_pos(2) + dr_vel(2) * time_step;

  dr_vel(1) = dr_vel(1) + (acc(1)*cos(dr_pos(3))-acc(2)*sin(dr_pos(3))) * time_step;
  dr_vel(2) = dr_vel(2) + (acc(1)*sin(dr_pos(3))+acc(2)*cos(dr_pos(3))) * time_step;

  dr_pos(3) = dr_pos(3) + dr_vel(3) * time_step;
  dr_vel(3) = dr_vel(3) + acc(3) * time_step;

  %% Calculate new required acceleration values
  %% x_velocity
  %% convert dr velocity into final velocity axis
  x_vel_f = dr_vel(1)*cos(theta) + dr_vel(2)*sin(theta);

  %% calculate applied accel on final velocity axis

  x_vel_diff = x_vel - x_vel_f;
  x_vel_abs = abs(x_vel);
  if (x_vel_diff > x_vel_abs/2)
    x_acc_f = x_acc_max;
  elseif (x_vel_diff > 0.02)
    x_acc_f = x_acc_max/10;
  elseif (x_vel_diff < -x_vel_abs/2)
    x_acc_f = -x_acc_max;
  elseif (x_vel_diff < -0.02)
    x_acc_f = -x_acc_max/10;
  else
    x_acc_f = 0;
  end;

  %% apply final-axis accel on the local axis
  temp_acc = [0 0 0];
  temp_acc(1) = x_acc_f*cos(theta-dr_pos(3));
  temp_acc(2) = x_acc_f*sin(theta-dr_pos(3)); 
  
  %% y_position
  %% convert dr position into final position axis
  y_pos_f = dr_pos(1)*-sin(dr_pos(3)) + dr_pos(2)*cos(dr_pos(3));
  y_vel_f = dr_vel(1)*-sin(dr_pos(3)) + dr_vel(2)*cos(dr_pos(3));
  if abs(y_pos_f) < abs(y_pos/2)
    y_acc_f = (y_vel_max^2-y_vel_f^2)/(2*(y_pos/2)-y_pos_f);
  elseif abs(y_pos_f) < abs(y_pos)
    y_acc_f = (-y_vel_f^2)/(2*(y_pos-y_pos_f+space_factor));
  elseif abs(y_pos_f) > abs(y_pos)
    if abs(y_pos_f) > max_vy_step
      if y_pos_f > 0
        y_acc_f = -y_acc_max;
      else
        y_acc_f = y_acc_max;
      end;
    else
      y_acc_f = 0;
    end;
  end;

  %% cap y_acceleration
  if y_acc_f > y_acc_max
    y_acc_f = y_acc_max;
  elseif y_acc_f < -y_acc_max
    y_acc_f = -y_acc_max;
  end;

  %% add y final-axis acceleration to local axis
  temp_acc(1) = temp_acc(1) - y_acc_f*sin(theta-dr_pos(3));
  temp_acc(2) = temp_acc(2) + y_acc_f*cos(theta-dr_pos(3));

  %% angular position
  if abs(dr_pos(3)) < abs(theta/2)
    aacc = (avel_max^2-dr_vel(3)^2)/(2*(theta/2-dr_pos(3)));
  elseif abs(dr_pos(3)) < abs(theta)
    aacc = (-dr_vel(3)^2)/(2*(theta-dr_pos(3)));
  else
    aacc = 0;
  end;

  %% cap angular acceleration
  if aacc > aacc_max
    aacc = aacc_max;
  elseif aacc < -aacc_max
    aacc = -aacc_max;
  end;

  temp_acc(3) = aacc;
  acc = temp_acc; 

end;

subplot(3,1,1);
plot(1:sim_length, path(1,:));
subplot(3,1,2);
plot(1:sim_length, path(2,:));
subplot(3,1,3);
plot(1:sim_length, path(3,:));
