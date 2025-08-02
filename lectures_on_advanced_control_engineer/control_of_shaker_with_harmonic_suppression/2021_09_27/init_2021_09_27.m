clear all
close all
clc

%% utility
options = bodeoptions;
options.FreqUnits = 'Hz';
Ts = 1/20e3;
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

% q1kalman = Ts/10;
% q2kalman = Ts/10;
% Qkalman = [q1kalman 0; 0 q2kalman];
% Rkalman = 0.1/q1kalman;

q1kalman = Ts*10;
q2kalman = Ts*10;
Qkalman = [q1kalman 0; 0 q2kalman];
Rkalman = 1e-2/q1kalman;


%% 90 deg shift
flt_dq = 2/(s/w + 1)^2;
flt_dq_d = c2d(flt_dq,Ts);

Af = [0 1; -w^2 -2*w];
Bf = [0 1]';
Cf = [2*w^2 0];
Afd = [exp(-Ts*w)*(1+Ts*w) exp(-Ts*w)*Ts; -exp(-Ts*w)*Ts*w^2 exp(-Ts*w)*(1-Ts*w)];
Bfd = [(1-exp(-Ts*w)*(1+Ts*w))/w^2 exp(-Ts*w)*Ts]';

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


%% Harmonic compensation
%% pll

wres = 197*2*pi;
Ares = 1;

pll_i1 = 2*pi/wres;
pll_p = 2*pi/wres;

kp_comp = 1e-1;
ki_comp = 2e-1;

q1kalman_res = Ts;
q2kalman_res = Ts;
Qkalman_res = [q1kalman_res 0; 0 q2kalman_res];
Rkalman_res = 1/Ts;

%% 90 deg shift resonance
flt_dq_res = 2/(s/wres + 1)^2;
flt_dq_d_res = c2d(flt_dq_res,Ts);

Af_res = [0 1; -wres^2 -2*wres];
Bf_res = [0 1]';
Cf_res = [2*wres^2 0];

Afd_res = [exp(-Ts*wres)*(1+Ts*wres) exp(-Ts*wres)*Ts; -exp(-Ts*wres)*Ts*wres^2 exp(-Ts*wres)*(1-Ts*wres)];
Bfd_res = [(1-exp(-Ts*wres)*(1+Ts*wres))/wres^2 exp(-Ts*wres)*Ts]';











