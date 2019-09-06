function Result=PowerConv(Params,Power)
if(Power==0)
    Result=1;
else
    Result=Params;

    for i=1:(Power-1)
        Result=conv(Result,Params);
    end;
end;
end