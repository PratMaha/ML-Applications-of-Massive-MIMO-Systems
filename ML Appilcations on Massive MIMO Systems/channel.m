clear all;
close all;
clc;
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
disp(channel_h);