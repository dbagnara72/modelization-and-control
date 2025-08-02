clear all
close all
clc

options = bodeoptions;
options.FreqUnits = 'Hz';

J1 = 0.5;
J2 = 5;
b = 0.01;
b_theta = 25;
k_theta = 10000;

% J1 = 0.5;
% J2 = 5;
% b = 0.01;
% b_theta = 0.25;
% k_theta = 100;

% J1 = 2.5;
% J2 = 25;
% b = 0.0;
% b_theta = b;
% k_theta = 100;

tcontrol = 1e-3;
ts = tcontrol;
tc = ts;
simlength = 20;
Nc=floor(simlength/tc);
load_torque = 1e3;

s=tf('s');
z=tf('z',tcontrol);

A = [-(b+b_theta)/J1 b_theta/J1 -1/J1; b_theta/J2 -(b+b_theta)/J2 1/J2;...
    k_theta -k_theta 0];
B = [1/J1 0 0]';
E = [0 1/J2 0]';
C = [1 0 0];

%% ISF + SOBS control design in d.t.d.
Ad = eye(3) + A*tcontrol;
Bd = B*tcontrol;
Ed = E*tcontrol;
Ade = [[0 0 0] 0; Bd Ad];
Bde = [1; [0 0 0]'];
Q = [tcontrol 0 0 0; 0 1 0 0; 0 0 1 0; 0 0 0 tcontrol];
R = tcontrol*50;
% Q=[tcontrol 0 0 0; 0 1 0 0; 0 0 1 0; 0 0 0 tcontrol];
% R=tcontrol;
K_hat = dlqr(Ade,Bde,Q,R);
Kd = (K_hat+[1 0 0 0])/([C*Bd C*Ad; Bd Ad-eye(3)]);


%% State Observer with load estimator
Ale = [-(b+b_theta)/J1 b_theta/J1 -1/J1 0; ...
       b_theta/J2 -(b+b_theta)/J2 1/J2 1/J2;...
       k_theta -k_theta 0 0;
       0 0 0 0];
Ble = [1/J1 0 0 0]';
Cle = [1 0 0 0];
Aled = eye(4) + Ale*tcontrol;
Bled = Ble*tcontrol;
Q = [tcontrol 0 0 0; 0 1 0 0; 0 0 1 0; 0 0 0 1/tcontrol];
R = tcontrol;
Lled = (dlqr(Aled',Cle',Q, R))';

%% mpc
Hmpc = [C*Bd 0 0; C*(Ad + eye(3))*Bd C*Bd 0; C*(Ad^2 + Ad + eye(3))*Bd ...
    C*(Ad + eye(3))*Bd C*Bd]
Qmpc = [1 0 0; 0 1e4 0; 0 0 1]; 
Rmpc = [1 0 0; 0 1 0; 0 0 1];
Gmpc = [C*Bd;  C*(Ad + eye(3))*Bd; C*(Ad^2 + Ad + eye(3))*Bd]
Fmpc = [C*Ad; C*Ad^2; C*Ad^3]
Kmpc = inv(Hmpc'*Qmpc*Hmpc+Rmpc)*Hmpc'*Qmpc






































