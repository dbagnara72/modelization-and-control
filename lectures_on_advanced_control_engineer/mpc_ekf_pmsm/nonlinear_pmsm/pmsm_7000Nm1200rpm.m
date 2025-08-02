clc

%% PMSM paramerters full electrification

%% inverter
Vdc = 1100;
Vdc_bez = 1100;
Vdc_max = 1100;
udc_bez = Vdc_bez;

%% PMSM paramerters
deflux = 1;
number_poles = 4;
p = number_poles/2;
omega_m_bez = 1200; %rpm
omega_bez = omega_m_bez/60*2*pi*number_poles/2;
tau_bez = 7000;
ibez = 777*sqrt(2)/deflux; %A
imax = 1.5*777*sqrt(2); %A
% psi_m = tau_bez/(3/2*number_poles/2*ibez)*deflux;
psi_m = 2;
ubez = psi_m*omega_bez;
cos_phi = 0.909;
% Ls = ubez*0.052/(omega_m_bez/60*2*pi*2*ibez);
Ls = 100e-6;
Lb = 0e-6;
Lalpha = 3/2*(Ls + Lb);
Lbeta = 3/2*(Ls - Lb);
Lq = (Ls + Lb);
Ld = (Ls - Lb);
Rs = 11e-3;
Vdc_min = sqrt((ubez+Rs*imax-(omega_bez*0.35*imax*Ld))^2+(omega_bez*imax*Lq)^2)*sqrt(3);

Jm = 5; %kgm^2
omega_m_sim = 1200;
Pload_sim = 1760e3*0.85;
tau_load_sim = Pload_sim/(omega_m_sim/60*2*pi)/2; %N*m
% tau_load_sim = 7000; %N*m
b_brake = tau_load_sim/(omega_m_sim/60*2*pi)
b = 0;




















