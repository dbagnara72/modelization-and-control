clc

%% PMSM paramerters
number_poles = 36;
pp = number_poles/2;
omega_m_bez = 510; %rpm
omega_bez = omega_m_bez/60*2*pi*pp;

tau_bez = 28.1;
ibez = 3.4*sqrt(2);

psi_m = 480*sqrt(2/3)/(1000/60*number_poles/2*2*pi);
ubez = omega_bez*psi_m % ph peak nominal back EMF

imax = ibez; %A
La = 28e-3;
Lb = 5e-6;
Ld = 3/2*(La-Lb);
Lq = 3/2*(La+Lb);
Ls = Lq;
Lalpha = (Ld+Lq)/2;
Lbeta = Lalpha;
Rs = 0.93;
Lmu = 5e-6;
Jm = 0.225; %kgm^2

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

torque_load_bearing = 0.5; %N*m
b = torque_load_bearing/(omega_m_bez/60*2*pi);
b_square = torque_load_bearing/(omega_m_bez/60*2*pi)^2;


%% check parameter motor and dclink voltage
omega_e = omega_bez;
omega_m = omega_e/(number_poles/2);
psi = psi_m;
id = 0;
iq = ibez;
torque = 3/2*number_poles/2*psi*iq
power_shaft = torque*omega_m;
vg = sqrt((omega_e*psi+omega_e*Ld*id+Rs*iq)^2+(omega_e*Lq*iq)^2)
udc_min = sqrt(3)*sqrt((omega_e*psi+omega_e*Ld*id+Rs*iq)^2+(omega_e*Lq*iq)^2)
u_motor_rms = sqrt(3/2)*sqrt((omega_e*psi+omega_e*Ld*id+Rs*iq)^2+(omega_e*Lq*iq)^2)
RPM_V = omega_m_bez/u_motor_rms;


