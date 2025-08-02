clc
n_modules = 4;
Pn=997e3/n_modules;
In=1570/n_modules;
cp=40;
wn_motor=29.38;
% plant_rpm = wn_motor;
% plant_gear_ratio = 1;
plant_rpm = 29.38;
plant_gear_ratio = 1;
we_motor = wn_motor/60*cp*2*pi;
wm_motor = wn_motor/60*2*pi;

Rs=3.15e-3*n_modules;
Ld=0.6e-3*n_modules;
Lq=0.81e-3*n_modules;
La=1/3*(Lq+Ld);
Lb=1/3*(Lq-Ld);
Ll=5e-6;
Ls=Lq;
En = 375/sqrt(3)/26.2*wn_motor; %rms phase

Omega_bez_motor = we_motor;
Omega_bez_motor_m = wm_motor;
plant_motor_ratio = plant_rpm*plant_gear_ratio/wn_motor;
Omega_bez_plant = Omega_bez_motor * plant_motor_ratio;
Omega_bez_plant_m = Omega_bez_motor_m * plant_motor_ratio;

omega_scale = plant_motor_ratio;
load_angle= -14;
Ibez=In*sqrt(2);
Ibez_d=In*sqrt(2)* sind(load_angle);
Ibez_q=In*sqrt(2)* cosd(load_angle);
Ubez=En*sqrt(2)*Omega_bez_plant/Omega_bez_motor;
phi_bez = Ubez/(Omega_bez_motor*plant_motor_ratio);

Xbez=Ubez/Ibez;
Lbez=Xbez/Omega_bez_plant;
Rs_norm = Rs/Xbez;
Ld_norm = Ld/Lbez;
Lq_norm = Lq/Lbez;
Ls_norm = Ls/Lbez;
Tnom = 324e3/n_modules;
Jm_rotore_LD9 = 2361;

phi = Ubez/Omega_bez_plant;
phi_norm = phi/phi_bez;

k = 2;
emf_fb_p = 0.2*k;
emf_p = 0.08*k;
k = 5;
% kalman_gamma = 0.8;
% kalman_gamma = 0.1;
kalman_gamma = 1.6;
kalman_w = kalman_gamma/k;
% kalman_iq_est = 0.11;
kalman_iq_est = 0;

iq_ref_norm_lim = 1;

Tload = 0.75*Tnom;
emf_valid =0.25e3;

Vdc_nom = Vdc_ref;
motorc_m_scale = 2/3*Vdc_nom/Ubez;

spdobs_emf_q_fact = 0;
spdobs_emf_o_fact = 0;
























