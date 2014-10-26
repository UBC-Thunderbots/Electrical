% this files implement Hadamard transform adapted to lps

i=[0:3]'*ones(1,16);
n=ones(4,1)*[0:15];
trans=(-1).^(floor(n./(2.^i))+1)
input1=mod([0:15],2)';
input2=floor(mod([0:15],4)/2)';
input3=floor(mod([0:15],8)/4)';
input4=floor(mod([0:15],16)/8)';
result1=trans*input1
result2=trans*input2
result3=trans*input3
result4=trans*input4
