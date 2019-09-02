function [As Bs]=TF_to_params(TransferFunction,SampleTime)
DiscreteNum=2*[1 -1];
DiscreteDen=SampleTime*[1 1];
Continuous_Num=TransferFunction.num{1};
Continuous_Den=TransferFunction.den{1};
Num_Order=length(Continuous_Num)-1;
Den_Order=length(Continuous_Den)-1;
Largest=max([Num_Order Den_Order]);
Continuous_Num=[zeros(1,Largest-Num_Order) Continuous_Num];
Continuous_Den=[zeros(1,Largest-Den_Order) Continuous_Den];
NumTF=zeros(1,Largest+1);
DenTF=zeros(1,Largest+1);
for i=0:Largest
    NumTF=NumTF+Continuous_Num(i+1)*conv(PowerConv(DiscreteNum,Largest-i),PowerConv(DiscreteDen,i));
    DenTF=DenTF+Continuous_Den(i+1)*conv(PowerConv(DiscreteNum,Largest-i),PowerConv(DiscreteDen,i));
end;

As=DenTF/DenTF(1);
Bs=NumTF/DenTF(1);

end