%Let's calculate channels
PL=zeros(4,4);
%rows correspond to UEs and columns correspond to APs
d=[707,1585,2121,1585;1585,707,1585,2121;2121,1585,707,1585;1585,2121,1585,707];
noise=randn(4,4);
noise=10*log10(noise);
f=1.8;
PL=(10*3.3*log10(d))+17.6+(10*2*log10(1.8))+noise;
%above is in db
PL=PL/10;
PL=10^PL;
channel_h=sqrt(PL);
%disp(channel_h);
channel_h=transpose(channel_h);
%now rows correspond to 1 AP and columns correspond to 1 UE
%disp(channel_h);
%Let's start EE calculations
variance_ue=ones(1,4);
power_avg=10*ones(1,4);
alpha=zeros(1,4);
beta=zeros(4,4);
B=180000;
ineff_UE=zeros(1,4);
ineff_UE(1,1)=4;
ineff_UE(1,2)=4;
ineff_UE(1,3)=4;
ineff_UE(1,4)=4;
pow_stat=ones(1,4);
%B is communication bandwidth
EE=zeros(1,4);
Base=[1,2,3,4];
%Calculate alpha
for i=1:4
    alpha(1,i)=abs(channel_h(Base(i),i))*abs(channel_h(Base(i),i));
    alpha(1,i)=alpha(1,i)/variance_ue(1,i);
end
%Calculate beta
herm_channel=ctranspose(channel_h);
for i=1:4
    for j=1:4
        beta(i,j)=abs((herm_channel(Base(i),i))*(channel_h(Base(i),j)));
        beta(i,j)=beta(i,j)*beta(i,j);
        beta(i,j)=beta(i,j)/variance_ue(1,i);
        beta(i,j)=beta(i,j)/(abs(channel_h(Base(i),i))*abs(channel_h(Base(i),i)));
    end
end
%Calculate EE
for i=1:4
    Y=0;
    X=alpha(1,i)*power_avg(1,i);
    for j=1:4
        if(i~=j)
            Y=Y+(beta(i,j)*power_avg(1,j));
        end
    end
    Y=Y+1;
    t=X/Y;
    t=B*log10(t+1);
    denom=ineff_UE(1,i)*power_avg(1,i);
    denom=denom+pow_stat(1,i); 
    EE(1,i)=t/(denom);
end
disp(EE);