clear all
close all
clc

%% utility
options = bodeoptions;
options.FreqUnits = 'Hz';
Ts = 1/20e3;
Tc = 1e-5;
% simlength = 30;
simlength = 10;
t_measure = simlength;
Nc = floor(t_measure/Tc);
s=tf('s');
z=tf('z',Ts);
mod = 2*pi;

f = 250;
w = 2*pi*f;

A = [0 w; -w 0];
C = [1 0];
Ad = [cos(w*Ts) sin(w*Ts); -sin(w*Ts) cos(w*Ts)];

qkalman = Ts;
Qkalman = [qkalman 0; 0 qkalman];
Rkalman = 0.1/qkalman;

flt_dq = 2/(s/w + 1)^2;
flt_dq_d = c2d(flt_dq,Ts);

Af = [0 1; -w^2 -2*w];
Bf = [0 1]';
Cf = [2*w^2 0];

Afd = eye(2) + Af*Ts
Bfd = Bf*Ts

Afd = [exp(-Ts*w)*(1+Ts*w) exp(-Ts*w)*Ts; -exp(-Ts*w)*Ts*w^2 exp(-Ts*w)*(1-Ts*w)]
Bfd = [(1-exp(-Ts*w)*(1+Ts*w))/w^2 exp(-Ts*w)*Ts]'


% figure; bode(flt_dq_d,options); grid on
% [num den]=tfdata(flt_dq_d,'v');

pll_i1 = 2*pi/w;
pll_p = 2*pi/w;














