clear
I_s = 1.2e-12;
C = 220e-9;
Vt=25e-3;
dt = 1e-8;
sim_time = 1/68e3;
iters = round(sim_time/dt);
V1_list = zeros(iters,1);
V2_list = zeros(iters,1);
I = zeros(iters,1);

V1_list(1) = 15;
V2_list(1) = 0;
I(1) = 0;

for j=2:iters
I(j) = I_s*(exp((V1_list(j-1)-V2_list(j-1))/Vt)-1);
if(I(j) < 0)
    I(j)=0;
end
dV1 = -I(j)/C;
dV2 = I(j)/C;

V1_list(j) = V1_list(j-1) + dV1*dt;
V2_list(j) = V2_list(j-1) + dV2*dt;

end