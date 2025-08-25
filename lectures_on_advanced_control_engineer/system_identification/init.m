close all
clear all
clc


s=tf('s');

kp = 0.25;
ki = 18;

R=1;
L=1e-1;
w0=10*2*pi;
% G=minreal((kp+ki/s)/(s*L+R));
% G=minreal(1/(s*L+R)^2);
G=1/((s/w0)^2 + 2/w0*s + 1);
filter = 1/(s/(2*pi*20)+1);

% figure;
% margin(G);
% grid on


Tcontrol = 5e-3;
z=tf('z',Tcontrol);

sysIc = G
sysId = c2d(sysIc,Tcontrol)*z^-1
filterd = c2d(filter,Tcontrol)

figure; 
bode(sysIc,sysId)
grid on

[B,A] = tfdata(sysId,'v')
b1=B(1)
b2=B(2)
b3=B(3)
b4=B(4)
a1=A(1)
a2=A(2)
a3=A(3)
a4=A(4)

lambda = 1;
Ts = 1e-6;
alpha = 1e5;
iniP11 = alpha;
iniP12 = 0;
iniP13 = 0;
iniP14 = 0;
iniP21 = 0;
iniP22 = alpha;
iniP23 = 0;
iniP24 = 0;
iniP31 = 0;
iniP32 = 0;
iniP33 = alpha;
iniP34 = 0;
iniP41 = 0;
iniP42 = 0;
iniP43 = 0;
iniP44 = alpha;

%% Simulation data sampling time
simlength=1;
Tc=Ts;
t_misura=1;
Nc=ceil(t_misura/Tc);

% % sysR = (0.12*z^-2-0.052*z^-3)/(1 - 0.58*z^-1 - 0.37*z^-2);
% sysR = (-0.0444*z^-2 + 0.0225*z^-3)/(1 - 2.39*z^-1 + 1.375*z^-2);
% % sysR = (0.48*z^-2 - 0.55*z^-3)/(1 - 2.2*z^-1 + 1.1*z^-2);
% % DCgain = (0.48-0.55)/(1-2.2+1.13)
% % sysR = (4.68e-3*z^-2 + 4.6e-3*z^-3)/(1 - 1.8108*z^-1 + 0.82*z^-2);
% figure;
% bode(sysR,sysIc);
% grid on

