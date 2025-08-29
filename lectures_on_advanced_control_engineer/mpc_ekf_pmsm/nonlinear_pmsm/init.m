clear all
close all
clc

%% utility
fPWM_INV = 3.333333e3*6;
dead_time = 0;
delayINV_modA = 0;

simlength = 60;
options = bodeoptions;
options.FreqUnits = 'Hz';
tcontrol = 1/fPWM_INV;
ts = tcontrol/50;

t_measure = 1;
Nc = floor(t_measure/ts);
s=tf('s');
z=tf('z',tcontrol);
Tavg_flt = 20e-3;

pmsm_7000Nm1200rpm;
nonlinear_kalman_pmsm;


%% rotor speed control
kp_w = 2;
ki_w = 1;

%% filter ref
w0 = 2*2*pi;
filter_ref = w0^2/(s^2+2*w0*s+w0^2);
filterd_ref = c2d(filter_ref,tcontrol);

Ron = 3e-3;
Rsnubber = 1e6;
Csnubber = 1e-12;

open_system("motore_sincrono_mpc_nonlinear_ekf.slx");







