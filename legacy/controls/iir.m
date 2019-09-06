function iir(A,B,T)
func=tf(B,A);
func.Ts=T;
step(func);
end
