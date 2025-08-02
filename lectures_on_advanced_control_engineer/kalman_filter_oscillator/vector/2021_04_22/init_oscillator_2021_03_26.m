clear all
close all
clc

%% utility
options = bodeoptions;
options.FreqUnits = 'Hz';
Ts = 1/10e3;
Tc = 1e-5;
% simlength = 30;
simlength = 50;
t_measure = simlength;
Nc = floor(t_measure/Tc);
s=tf('s');
z=tf('z',Ts);
mod = 2*pi;

f = 50;
w = 2*pi*f;

A = [0 w; -w 0];
C = [1 0];
Ad = [cos(w*Ts) sin(w*Ts); -sin(w*Ts) cos(w*Ts)];

q1kalman = Ts/10;
q2kalman = Ts/10;
Qkalman = [q1kalman 0; 0 q2kalman];
Rkalman = 0.1/q1kalman;


%% 90 deg shift
flt_dq = 2/(s/w + 1)^2;
flt_dq_d = c2d(flt_dq,Ts);

Af = [0 1; -w^2 -2*w];
Bf = [0 1]';
Cf = [2*w^2 0];

% Afd = eye(2) + Af*Ts
% Bfd = Bf*Ts

Afd = [exp(-Ts*w)*(1+Ts*w) exp(-Ts*w)*Ts; -exp(-Ts*w)*Ts*w^2 exp(-Ts*w)*(1-Ts*w)]
Bfd = [(1-exp(-Ts*w)*(1+Ts*w))/w^2 exp(-Ts*w)*Ts]'


% figure; bode(flt_dq_d,options); grid on
% [num den]=tfdata(flt_dq_d,'v');

%% plant
wp = 2*pi*4e2;
plant = wp^2/(s^2+2*wp*s+wp^2);
%% pi control
kp = 1;
ki = 2;
pi_ctrl = kp+ki/s;
G = minreal(pi_ctrl*plant)
% figure; margin(G); grid on
% set(cstprefs.tbxprefs,'FrequencyUnits','Hz');
% figure; bode(plant); grid on
% set(findall(gcf,'type','line'),'linewidth',3,'Color',[0 0 0]);
% title('Plant Bode Diagram','Interpreter','latex');
% print -depsc plant_bode_diagram

%% pll
pll_i1 = 2*pi/w;
pll_p = 2*pi/w;













