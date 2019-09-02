destination = [-1.0;-8.0];
avel_final = 4.0;

rotation = zeros(2,2);

% spacing factor for tolerance
% space_factor = distance travelled at max acceleration/velocity in 1 tick
space_factor = 0.01;

TICK = 0.005;
aa_max = 4.0;
V_MAX = 2.0;
A_MAX = 0.5;
MAX_V_STEP = A_MAX*TICK;

global_x_vals = zeros(2000, 1);
global_y_vals = zeros(2000, 1);
global_angles = zeros(2000, 1);

global_pos = [0;0];
global_angle = 0;

global_v = [0;0];
avel = 0;

global_a = [0;0];
aa = 0;

local_v = [0;0];
local_accel = [0;0];

for i = 1:2000
    % Tick each value
    global_angle = mod((global_angle + (avel * TICK)), 2*pi);
    avel = avel + (aa * TICK);
    if global_v(1) > V_MAX
        global_v(1) = V_MAX;
    end
    if global_v(2) > V_MAX
        global_v(2) = V_MAX;
    end
    global_pos(1) = global_pos(1) + (global_v(1) * TICK);
    global_pos(2) = global_pos(2) + (global_v(2) * TICK);
    global_v(1) = global_v(1) + (global_a(1) * TICK);
    if global_v(1) > V_MAX
        global_v(1) = V_MAX;
    end
    if global_v(2) > V_MAX
        global_v(2) = V_MAX;
    end
    global_v(2) = global_v(2) + (global_a(2) * TICK);
    
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    % This section is done by the robot
    % calculate the rotation matrix
    rotation = [cos(global_angle) sin(global_angle); 
        -sin(global_angle) cos(global_angle)];
    % find the global (x,y) accelerations required
    if abs(global_pos(1)) < abs(destination(1)/2)
        local_accel(1) = (V_MAX^2-global_v(1)^2)/(2*((destination(1)/2) - global_pos(1)));
    elseif (abs(destination(1)/2) <= abs(global_pos(1))) && (abs(global_pos(1)) < abs(destination(1)))
        local_accel(1) = (-global_v(1)^2)/(2*(destination(1)-global_pos(1)+space_factor));
    elseif abs(global_pos(1)) > abs(destination(1))
        if abs(global_v(1)) > MAX_V_STEP
            if global_v(1) > 0
                local_accel(1) = -A_MAX;
            else
                local_accel(1) = A_MAX;
            end
        else
            local_accel(1) = 0;
        end
    else
        local_accel(1) = 0;
    end
    
    if abs(global_pos(2)) < abs(destination(2)/2)
        local_accel(2) = (V_MAX^2-global_v(2)^2)/(2*((destination(2)/2) - global_pos(2)));
    elseif (abs(destination(1)/2) <= abs(global_pos(2))) && (abs(global_pos(2)) < abs(destination(2)))
        local_accel(2) = (-global_v(2)^2)/(2*(destination(2)-global_pos(2)+space_factor));
    elseif abs(global_pos(2)) > abs(destination(2))
        if abs(global_v(2)) > MAX_V_STEP
            if global_v(2) > 0
                local_accel(2) = -A_MAX;
            else
                local_accel(2) = A_MAX;
            end
        else
            local_accel(2) = 0;
        end
    else
        local_accel(2) = 0;
    end 
    
    if local_accel(1) > A_MAX
        local_accel(1) = A_MAX;
    end
    if local_accel(1) < -A_MAX
        local_accel(1) = -A_MAX;
    end
    if local_accel(2) > A_MAX
        local_accel(2) = A_MAX;
    end
    if local_accel(2) < -A_MAX
        local_accel(2) = -A_MAX;
    end
    
    % rotate the local accelerations to get the correct values to give to
    % the robot
    
    local_accel = rotation*local_accel;
    
    % calculate the angular acceleration required
    
    if avel < avel_final
        aa = aa_max;
    else
        aa = 0;
    end        
    
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

    rotation = [cos(-global_angle) sin(-global_angle); 
        -sin(-global_angle) cos(-global_angle)];

    global_a = rotation*local_accel;
    
    global_x_vals(i) = global_pos(1);
    global_y_vals(i) = global_pos(2);
    global_angles(i) = global_angle;
    
end

t = 1:2000;

figure;
subplot(2,2,1);
plot(t, global_angles);
title('Angle vs t');
subplot(2,2,2);
plot(t, global_x_vals);
title('x vs t');
subplot(2,2,3);
plot(t, global_y_vals);
title('y vs t');