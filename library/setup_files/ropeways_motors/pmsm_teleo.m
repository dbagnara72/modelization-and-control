clc

%% PMSM paramerters full electrification

%% inverter
Vdc_bez = 1070;
Vdc = Vdc_bez;
Vdc_max = Vdc_bez*1.25;
udc_bez = Vdc_bez;

%% PMSM paramerters
number_poles = 80;
pp = number_poles/2;
rpm_nom = 31.48;
omega_m_bez = rpm_nom/60*2*pi; %rpm
omega_bez = omega_m_bez*pp;
ibez = 480.8; %A
eta_inv = 0.98;
ubez = 481.73;
psi_m = ubez/omega_bez
Ld = 3.2e-3;
Lq = 4.3e-3;
Ls = Lq;
Lalpha = (Ld+Lq)/2;
Lbeta = Lalpha;
La = 1/3*(Lq+Ld);
Lb = 1/3*(Lq-Ld);
Rs = 16.8e-3;
Lmu = 5e-6;
Jm = 1; %kgm^2
tau_bez = 3/2*pp*ibez*psi_m;
pbez = tau_bez*omega_m_bez

%% per-unit model
Xbez=ubez/ibez;
Lbez=Xbez/omega_bez;
Rs_norm = Rs/Xbez;
Ld_norm = Ld/Lbez;
Lq_norm = Lq/Lbez;
Ls_norm = Ls/Lbez;
Lalpha_norm = Lalpha/Lbez;
Lbeta_norm = Lbeta/Lbez;
La_norm = La/Lbez;
Lb_norm = Lb/Lbez;
psi_bez = ubez/omega_bez;
psi_m_norm = psi_m/psi_bez;
Jm_norm = 1/2*Jm*omega_bez/pp/tau_bez;

%% double check parameter motor and dclink voltage
omega_e = omega_bez
omega_m = omega_e/(number_poles/2)
psi = psi_m;
id = 0;
iq = ibez;
torque = 3/2*number_poles/2*psi*iq
power_shaft = torque*omega_m
vg_dclink = sqrt(3)*sqrt((omega_e*psi+omega_e*Ld*id+Rs*iq)^2+(omega_e*Lq*iq)^2)
vg_phph_rms = sqrt(3/2)*sqrt((omega_e*psi+omega_e*Ld*id+Rs*iq)^2+(omega_e*Lq*iq)^2)

%% load parameters
b = 250e3/omega_m_bez^2;
Jplant = 0.1;
krope = 10e3;
