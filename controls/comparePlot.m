function Est=comparePlot(K,D,Wn,Z,t,Data)
Est=tf(Wn^2*K*[Z 1],[1 2*D*Wn Wn^2]);
step(Est);
hold on;
plot(t,Data);
end