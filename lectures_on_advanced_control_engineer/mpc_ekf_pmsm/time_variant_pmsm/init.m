clear all
close all
clc

%% simdata
fPWM_INV = 8e3;

simlength = 60;
options = bodeoptions;
options.FreqUnits = 'Hz';
tcontrol = 1/fPWM_INV/6;
ts = tcontrol;

t_measure = 1;
Nc = floor(t_measure/ts);
s=tf('s');
z=tf('z',tcontrol);
Tavg_flt = 20e-3;

pmsm_7000Nm1200rpm;
kalman_pmsm;

%% rotor speed control
kp_w = 2;
ki_w = 1;

%% filter ref
w0 = 2*2*pi;
filter_ref = w0^2/(s^2+2*w0*s+w0^2);
filterd_ref = c2d(filter_ref,tcontrol);

open_system('pmsm_mpc_ekf');









