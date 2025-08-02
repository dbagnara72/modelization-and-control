clear all
close all
clc

fPWM_INV = 8e3; % INVERTER PWM frequency
tPWM_INV = 1/fPWM_INV/2;
delayINV_modA=0;
dead_time = 0;


%% utility
simlength = 5;
options = bodeoptions;
options.FreqUnits = 'Hz';
Ts = tPWM_INV/2;
Tc = 1e-5;
t_measure = simlength;
Nc = floor(t_measure/Tc);
s=tf('s');
z=tf('z',Ts);
mod = 2*pi;

%% PMSM paramerters
number_poles = 8;
Rs = 11e-3;
Lmu = 1e-6;
% Lmu = 0;
% Ls = 1e-3;
% Lb = Ls/4;
% Lb = 0;
% Ld = 3/2*(Ls - Lb)
% Lq = 3/2*(Ls + Lb)
Ld = 2.67e-3;
Lq = 3.28e-3;
Ls = (Ld+Lq)/3
Lb = (Lq-Ld)/3
Lalpha = Ld;
Lbeta = Lq;
omega_bez = 500/60*2*pi*number_poles/2;
% psi_m = 890/sqrt(3)/(3100/60*number_poles/2*2*pi) %Wb (V*s)
% psi_m = 590/sqrt(3)/(3100/60*number_poles/2*2*pi) %Wb (V*s)
psi_m = 0.37 %Wb (V*s)
Jm = 1; %kgm^2
omega_m_sim = 3100/60*2*pi;
omega_sim = omega_m_sim*number_poles/2;
% tau_load = 85e3/omega_m_sim; %N*m
tau_load = 10; %N*m
b = 0.1;
%% inverter
Vdc = 680;
Ibez = 550;
Ubez = 230*sqrt(2);

%% PMSM paramerters

A1_tilde = [-Rs/Ld 0 0 0 0 0; 0 -Rs/Lq 0 0 0 0; ...
    0 0 0 0 0 0; 0 0 0 0 0 0; ...
    0 0 0 0 0 1; 0 0 0 0 0 0];

A2_tilde = [0 0 0 1/Ld 0 0; 0 0 -1/Lq 0 0 0; ...
    0 0 0 -1 0 0; 0 0 1 0 0 0;...
    0 0 0 0 0 0; 0 0 0 0 0 0];

A3_tilde = [0 0 0 0 0 0; 0 0 0 0 0 -1/Lq; ...
    0 0 0 0 0 0; 0 0 0 0 0 1;...
    0 0 0 0 0 0; 0 0 0 0 0 0];

A4_tilde = [0 0 0 0 0 1/Ld; 0 0 0 0 0 0; ...
    0 0 0 0 0 -1; 0 0 0 0 0 0;...
    0 0 0 0 0 0; 0 0 0 0 0 0];

B_tilde = [1/Ld 0; 0 1/Lq; 0 0; 0 0; 0 0; 0 0];

C = [1 0 0 0 0 0; 0 1 0 0 0 0];

Bd = B_tilde*Ts;

%% Kalman init
% Qkalman = eye(4);
Qkalman = [Rs/Ld*1e0 0 0 0 0 0; 0 Rs/Lq*1e0 0 0 0 0;...
    0 0 Ts 0 0 0;...
    0 0 0 Ts 0 0;...
    0 0 0 0 1e-1 0;...
    0 0 0 0 0 1e-1]*Ts*10;
Rkalman = eye(2)*1;


%% rotor speed observer
mod = 2*pi;
Aso = [1 Ts; 0 1];
Cso = [1 0];
p2place = exp([-50 -10]*Ts);
K = (acker(Aso',Cso',p2place))';
kg = K(1);
kw = K(2);

%% rotor speed control
kp_w = 1;
ki_w = 18;
%% current control
kp = 2;
ki = 18;

%% filter ref
w0 = 2*2*pi;
filter_ref = w0^2/(s^2+2*w0*s+w0^2);
filterd_ref = c2d(filter_ref,Ts);

Ron = 3e-3;
Rsnubber = 1e6;
Csnubber = 1e-12;
