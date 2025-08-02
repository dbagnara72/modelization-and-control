clear all
close all
clc

w = 2*pi*50;
ts = 1e-3;
s = tf('s');
z = tf('z',ts);

L = 1e-3;
R = 1e-2;

kp = 0.5;
ki = 18;
RES = s/(s^2+w^2);
RPI = kp + ki * RES;
Plant = 1/(s*L+R);

rebuild = (1-exp(-s*ts))/s/ts;

A = [0 1; -w^2 0];
B = [0 1]';
C = [0 1];
D = 0;

Ad = [cos(w*ts) sin(w*ts)/w; -w*sin(w*ts) cos(w*ts)];
Bd = [(1-cos(w*ts))/w^2 sin(w*ts)/w]';

%% data simulation
Tc = ts/10;
simlegth = 0.3;
Nc = floor(simlegth/Tc);

