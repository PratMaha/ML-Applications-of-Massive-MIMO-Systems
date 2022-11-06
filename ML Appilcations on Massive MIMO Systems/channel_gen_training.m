clear all;
close all;
clc;
pos=2000*rand(4,2,2000);
dist=zeros(4,4,2000);
Base=zeros(4,2000);
variance_ue=ones(2000,4);
P_max=4*ones(2000,4);
%first 4 corresponds to UEs and second to APs
for i =1:2000
    for j=1:4
        dist(j,1,i)=sqrt((pos(j,1,i)*pos(j,1,i))+(pos(j,2,i)*pos(j,2,i)));
        dist(j,2,i)=sqrt(((2000-pos(j,1,i))*(2000-pos(j,1,i)))+(pos(j,2,i)*pos(j,2,i)));
        dist(j,3,i)=sqrt(((2000-pos(j,1,i))*(2000-pos(j,1,i)))+((2000-pos(j,2,i))*(2000-pos(j,2,i))));
        dist(j,4,i)=sqrt(((2000-pos(j,2,i))*(2000-pos(j,2,i)))+(pos(j,1,i)*pos(j,1,i)));
        Base(j,i)=min(dist(j,:,i));
        for k=1:4
            if(Base(j,i)==dist(j,k,i))
                Base(j,i)=k;
            end
        end
    end
end
noise=randn(4,4,2000);
noise=10*log10(noise);
f=1.8;
PL=(10*3.3*log10(dist))+17.6+(10*2*log10(1.8))+noise;
PL=PL/10;
for i=1:2000
    PL(:,:,i)=10^(PL(:,:,i));
end
channel_h=sqrt(PL);
for i=1:2000
    channel_h(:,:,i)=transpose(channel_h(:,:,i));
end
%writematrix(channel_h,'channel.txt');
%now first dimension of size corresponds to 1 AP and other corresponds to 1 UE
%Calculate alpha
for j=1:2000
    for i=1:4
        alpha(j,i)=abs(channel_h(Base(i),i,j))*abs(channel_h(Base(i),i,j));
        alpha(j,i)=alpha(j,i)/variance_ue(j,i);
    end
end
writematrix(alpha,'alpha_data.txt')
%above line writes alpha values into file 'alpha_data.txt'
for i=1:2000
    herm_channel(:,:,i)=ctranspose(channel_h(:,:,i));
end
for k=1:2000
    for i=1:4
        for j=1:4
            beta(k,(4*(i-1)+j))=abs((herm_channel(Base(i),i,k))*(channel_h(Base(i),j,k)));
            beta(k,(4*(i-1)+j))=beta(k,(4*(i-1)+j))*beta(k,(4*(i-1)+j));
            beta(k,(4*(i-1)+j))=beta(k,(4*(i-1)+j))/variance_ue(k,i);
            beta(k,(4*(i-1)+j))=beta(k,(4*(i-1)+j))/(abs(channel_h(Base(i),i,k))*abs(channel_h(Base(i),i,k)));
        end
    end
end
%Calculate outputs
pow_stat=1*rand(2000,4)+0.5;
ineff_UE=4;
X=alpha.*pow_stat/ineff_UE;
X=X-1;
Y=X/exp(1);
W=lambertw(0,Y);
X=X./W;
p_avg=(X-1)./alpha;
%Create data file
data=[alpha,beta,P_max,p_avg];
%Write the data into a file
writematrix(data,'final_data.txt');