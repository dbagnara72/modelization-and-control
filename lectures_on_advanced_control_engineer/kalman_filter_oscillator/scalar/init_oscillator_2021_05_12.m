clearvars
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

%% kalman oscillator
function [h_hat,l1,l2]   = KFO(y,w,Ts,q1,q2,r)

    persistent   x1_po x2_po p11_po p12_po p21_po p22_po

    if isempty(x1_po)
        x1_po = 0;
        x2_po = 0;
        p11_po = 0;
        p12_po = 0;
        p21_po = 0;
        p22_po = 0;        
    end
    
    a11 = cos(w*Ts);
    a12 = sin(w*Ts);
    a21 = -sin(w*Ts);
    a22 = cos(w*Ts);

    x1_pr = a11*x1_po + a12*x2_po;
    x2_pr = a21*x1_po + a22*x2_po;
    
    p11_pr = q1 + a11*(a11*p11_po+a12*p21_po) + a12*(a11*p12_po+a12*p22_po);
    p12_pr = a21*(a11*p11_po+a12*p21_po) + a22*(a11*p12_po+a12*p22_po);
    p21_pr = a11*(a21*p11_po+a22*p21_po) + a12*(a21*p12_po+a22*p22_po);
    p22_pr = q2 + a21*(a21*p11_po+a22*p21_po) + a22*(a21*p12_po+a22*p22_po);
    
    l1 = p11_pr/(p11_pr + r);
    l2 = p21_pr/(p11_pr + r);
    
    x1_po = x1_pr + l1*(y-x1_pr);
    x2_po = x2_pr + l2*(y-x1_pr);
    
    p11_po = (1-l1)*p11_pr;
    p12_po = (1-l1)*p12_pr;
    p21_po = p21_pr-l2*p11_pr;
    p22_po = p22_pr-l2*p12_pr;
    
    h_hat = x1_pr;
end

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
figure; bode(flt_dq_d,options); grid on
[num den]=tfdata(flt_dq_d,'v');

%% plant
wp = 2*pi*1e2;
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