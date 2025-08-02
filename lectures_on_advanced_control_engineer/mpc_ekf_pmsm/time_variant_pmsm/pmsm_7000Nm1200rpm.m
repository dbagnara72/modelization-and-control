clc

%% inverter
Vdc = 1100;
Vdc_bez = 1100;
Vdc_max = 1100;
udc_bez = Vdc_bez;

%% PMSM paramerters
number_poles = 4;
p = number_poles/2;
omega_m_bez = 1200; %rpm
omega_bez = omega_m_bez/60*2*pi*number_poles/2; % rad/s
tau_bez = 7000;
ibez = 777*sqrt(2); %A
imax = 1.5*777*sqrt(2); %A
psi_m = tau_bez/(3/2*number_poles/2*ibez);
ubez = psi_m*omega_bez; % voltage at no current flowing

La = 100e-6;
Lb = 0e-6;
Lalpha = 3/2*(La + Lb);
Lbeta = 3/2*(La - Lb);
Lq = 3/2*(La + Lb);
Ld = 3/2*(La - Lb);
Ls = Lalpha;
Rs = 11e-3;

Jm = 5; %kgm^2
omega_m_sim = 1200;
%% load definition via 
Pload_sim = 1760e3*0.85/2;
tau_load_sim = Pload_sim/(omega_m_sim/60*2*pi); %N*m
b_brake = tau_load_sim/(omega_m_sim/60*2*pi)
b = 2;




















