clear
Vin = 14.8;
Vout_max = 240;
Vd=0.7;
Dmax = 1-Vin/Vout_max;
L=47e-6;
C=5.4e-3;
R=34e-3;
f=25e3;
T_charge = 5;
T_total = 6;
dt = 1/f;
iter=100;
Vsp = [linspace(Vin,Vout_max,T_charge/dt) linspace(Vout_max,Vout_max,(T_total-T_charge)/dt)];
Dlist = 1-Vin./Vsp;
t=linspace(0,T_total,length(Dlist));
Vout = zeros(length(Dlist),1);
I = zeros(length(Dlist),1);
Iav = zeros(length(Dlist),1);
I_temp = zeros(iter,1);
Vout(1)=Vin;
tic
for i=2:length(Dlist);
    D = Dlist(i);
    I(i) = I(i-1);
    Vout(i) = Vout(i-1);
    if(~mod(i,1000))
        time_to_here = toc;
        time_per = time_to_here / i;
        time_left = time_per * (length(Dlist) - i);
        disp(sprintf('current iteration: %d of %d; timeleft: %f seconds',i,length(Dlist),time_left));
    end
    for j=1:iter
        if((j-1)/(iter-1) < D)
            I(i) = I(i) + (Vin)/L*dt/iter;
        else
            Vout(i) = Vout(i) + I(i)/C*dt/iter;
            I(i) = I(i) + (Vin - Vout(i))/L*dt/iter;
        end
        if(I(i) < 0)
            I(i) = 0;
        end
        I_temp(j) = I(i);
        Iav(i) = mean(I_temp);
    end
    if(i==10)
        I_temp_save = I_temp;
    end
end
plot(t,[Vout I]);
