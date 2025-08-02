clear all
close all
clc

im_param_calc


%% utility
options = bodeoptions;
options.FreqUnits = 'Hz';
Ts = 1/8e3;
Tc = 1e-6;
simlength = 0.6;
start_load = 0.1;
Nc = floor(simlength/Tc);
s=tf('s');
z=tf('z',Ts);

%% IM SS model
w0 = 2*pi*50;
Vdc = 450;

mu = 3/2*cp*Lm/J/Lr;
alpha = Rr/Lr;
sigma = Ls*(1-Lm^2/Lr/Ls);
beta = Lm/sigma/Lr;
gamma = Rs/sigma + beta*alpha*Lm;
A_tilde = [-gamma 0 beta*alpha beta*w0; ...
          0 -gamma -beta*w0 beta*alpha; ...
          alpha*Lm 0 -alpha -w0; ...
          0 alpha*Lm w0 -alpha];
B_tilde = [1/sigma 0; 0 1/sigma; 0 0; 0 0];
C = [1 0 0 0; 0 1 0 0];

Ad = eye(4)+A_tilde*Ts;
Bd = B_tilde*Ts;

%% DQ PI control
ki_inv_q = 18;
kp_inv_q = 0.5;
ki_inv_d = 18;
kp_inv_d = 0.5;
CTRPIFF_CLIP_RELEASE = 0.05;

%% Kalman init
Qkalman = [1 0 0 0; 0 1 0 0; 0 0 1e-4 0; 0 0 0 1e-4];
Rkalman = eye(2)*100;





