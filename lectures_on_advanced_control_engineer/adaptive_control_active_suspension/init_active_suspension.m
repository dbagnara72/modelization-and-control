clear all
close all
clc

s = tf('s');
g = 9.81;


%% model reference
km_ref = 15000; %N/m
bm_ref = 3000; %N/m/s
m_ref = 360; %kg

Am = [0 1; -km_ref/m_ref -bm_ref/m_ref];
Bm = [0; -bm_ref/m_ref];
Em = [0; -1];
Cm = [1 0; 0 1];
x0 = 0.35;
%% model
kp = km_ref/2;
bp = bm_ref/2;
mp = m_ref*2;
% kp = km_ref;
% bp = bm_ref;
% mp = m_ref;

%% ctrl parameter
% n_1 = 0.05;
% m_1 = 1e3;
n_1 = 1e-2;
m_1 = 1e6;

%% speed bump
spd_b = 2; 
time_spd_b_on = 1;
time_spd_b_off = 1.2;

%% speed bump flt
wn = 2*pi*10;
spd_bump_flt = wn^2/(s^2+2*wn*s+wn^2);
[num, den] = tfdata(spd_bump_flt,'v');
[A,B,C,D] = tf2ss(num, den);
spd_bump_flt_ss = ss(A,B,C,D);
spd_bump_flt_init = [0,0];

Tc = 1e-5;
simlength = 3;
Nc = floor(simlength/Tc);
Aobs = [0 1; 0 0];
% Aobs = [0 1; -pi^2/16 0];
Cobs = [1 0];
L = acker(Aobs',Cobs',[-100, -200]);
L = L';

Ts=1e-3;
A2obs = [0 1 0; 0 0 1; 0 -(2*pi)^2 0];
% A2obs = [0 1 0; -(2*pi)^2 0 0; 0 -(2*pi)^2 0];
A2obsd = eye(3)+A2obs*Ts
A2obsd = expm(A2obs*Ts)
C2obs = [0 0 1];
obsv(A2obs,C2obs)
rank(obsv(A2obs,C2obs))
% Qkalman = [Ts^2 0 0; 0 Ts 0; 0 0 0.1];
% Rkalman = 1;
Qkalman = [Ts 0 0; 0 Ts 0; 0 0 1];
Rkalman = 1;















