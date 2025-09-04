clear all
close all
clc

options = bodeoptions;
options.FreqUnits = 'Hz';

J1 = 1;
J2 = 0.68;
J3 = 1;
b1 = 0.0;
b2 = 0.0;
b3 = 0.0;
b_theta = 0;
k_theta = 1e3;

f0_msm = 1/2/pi*sqrt(k_theta*(J1+J2)/(J1*J2))

f0_msmsm = 1/2/pi/sqrt(2)/J1/J2/J3*sqrt(-J1^2*J2^2*J3*k_theta - 2*J1^2*J2*J3^2*k_theta ...
    -J1*J2^2*J3^2*k_theta - J1*J2*J3*sqrt(J1^2*J2^2-2*J1*J2^2*J3+4*J1^2*J3^2+J2^2*J3^2)*k_theta)

f1_msmsm = 1/2/pi/sqrt(2)/J1/J2/J3*sqrt(-J1^2*J2^2*J3*k_theta - 2*J1^2*J2*J3^2*k_theta ...
    -J1*J2^2*J3^2*k_theta + J1*J2*J3*sqrt(J1^2*J2^2-2*J1*J2^2*J3+4*J1^2*J3^2+J2^2*J3^2)*k_theta)

Ts = 1/1e3;
Tcontrol=Ts;
Tc = Ts;
simlength = 100;
Nc=floor(simlength/Tc);
load_torque = 10;

s=tf('s');
z=tf('z',Ts);

A = [-(b1+b_theta)/J1 b_theta/J1 -1/J1; b_theta/J2 -(b2+b_theta)/J2 1/J2;...
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
Ale = [-(b1+b_theta)/J1 b_theta/J1 -1/J1 0; ...
       b_theta/J2 -(b2+b_theta)/J2 1/J2 1/J2;...
       k_theta -k_theta 0 0;
       0 0 0 0];
Ble = [1/J1 0 0 0]';
Cle = [1 0 0 0];
Aled = eye(4) + Ale*Ts;
Bled = Ble*Ts;

Q=[Ts 0 0 0; 0 1 0 0; 0 0 1 0; 0 0 0 1000];
R=1;
Lled = (dlqr(Aled',Cle',Q, R))';

