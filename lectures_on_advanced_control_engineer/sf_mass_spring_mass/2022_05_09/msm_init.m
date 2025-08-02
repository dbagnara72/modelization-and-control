clear all
close all
clc

options = bodeoptions;
options.FreqUnits = 'Hz';

J1 = 2.5;
J2 = 25;
b = 0.0;
b_theta = b;
k_theta = 100;

Ts = 1/1e4;
Tcontrol=Ts;
Tc = Ts;
simlength = 20;
Nc=floor(simlength/Tc);
load_torque = 10;

s=tf('s');
z=tf('z',Ts);

A = [-(b+b_theta)/J1 b_theta/J1 -1/J1; b_theta/J2 -(b+b_theta)/J2 1/J2;...
    k_theta -k_theta 0];
B = [1/J1 0 0]';
E = [0 1/J2 0]';
C = [1 0 0];

%% ISF + SOBS control design in d.t.d.
Ad = eye(3)+A*Ts;
Bd = B*Ts;
Ed = E*Ts;
Ade = [[0 0 0] 0; Bd Ad];
Bde = [1; [0 0 0]'];
Q=[Ts 0 0 0; 0 1 0 0; 0 0 1 0; 0 0 0 Ts];
R=Ts;
K_hat = dlqr(Ade,Bde,Q,R);
Kd = (K_hat+[1 0 0 0])/([C*Bd C*Ad; Bd Ad-eye(3)]);


%% State Observer with load estimator
Ale = [-(b+b_theta)/J1 b_theta/J1 -1/J1 0; ...
       b_theta/J2 -(b+b_theta)/J2 1/J2 1/J2;...
       k_theta -k_theta 0 0;
       0 0 0 0];
Ble = [1/J1 0 0 0]';
Cle = [1 0 0 0];
Aled = eye(4) + Ale*Ts;
Bled = Ble*Ts;

Q=[Ts 0 0 0; 0 1 0 0; 0 0 1 0; 0 0 0 1000];
R=1;
Lled = (dlqr(Aled',Cle',Q, R))';

