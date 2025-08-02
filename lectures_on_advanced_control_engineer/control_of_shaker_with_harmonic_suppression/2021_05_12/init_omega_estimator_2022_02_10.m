clear all
close all
clc

%% utility
options = bodeoptions;
options.FreqUnits = 'Hz';
Ts = 1/1e3;
Tc = 1e-5;
% simlength = 30;
simlength = 1;
t_measure = simlength;
Nc = floor(t_measure/Tc);
s=tf('s');
z=tf('z',Ts);
module = 2*pi;

f = 50;
w = 2*pi*f;

A = [0 1; 0 0];
C = [1 0];
Ad = [1 0; 0 1] + A*Ts;

q1kalman = 1;
q2kalman = 100;
Qkalman = [q1kalman 0; 0 q2kalman];
Rkalman = 1;

