close all
clear all
clc

%% pwm
fPWM_AFE=4e3; % AFE PWM frequency 
fPWM_INV=3e3; % INVERTER PWM frequency
tPWM_INV = 1/fPWM_INV;
tPWM_AFE = 1/fPWM_AFE;
%delayAFE_modA=0;
%delayINV_modA=0;

%% sampling time
s=tf('s');
Tcontrol_AFE=1/fPWM_AFE/2; % Sampling time of the control AFE as well as INVERTER
Tcontrol_INV=1/fPWM_INV/2; % Sampling time of the control AFE as well as INVERTER
z_inv=tf('z',Tcontrol_INV);
z_afe=tf('z',Tcontrol_AFE);
Tintcom = 100e-3;

Imax_adc=1049.835;
CurrentQuantization = Imax_adc/2^11;
CTRPIFF_CLIP_RELEASE = 0.05;

%% Main Parameter for Simulation
% Vdc_ref=1070; % DClink voltage reference
% Vdc_ref=650; % DClink voltage reference
% Vdc_ref=689; % DClink voltage reference
Vdc_ref=720; % DClink voltage reference
%dead_time=0; %6e-6; % IGBT dead-time (or blanking time)
%Rprecharge=1; % Resistance of the DClink pre-charge circuit
% simlength=15;
simlength=6;
% simlength=6.2;
% simlength=8;

%% grid data for simulation
start_torque_control = 0;
% external_load_P = 1e6*number_ld;
% external_load_cos_phi = 1;
% external_load_Q = external_load_P*tan(acos(external_load_cos_phi));
start_load = 0.25;

VoltageSag_start = 4;

%Topen = 4e3; %1.75
%fault_time = 1e3;
%Rbrake = 2.5;
Vgrid_fluctation = 1;

% vh_fifth_grid = 15;
% vh_fourth_grid = 8.5;
% vh_sixth_grid = 8.5;
% vh_fifth_grid = 0;
% vh_fourth_grid = 0;
% vh_sixth_grid = 0;
% vh_seventh_grid = 0;
% dc_bias_offset = 0; %A
% dc_bias_igbt_modA = 0.25;
% dc_bias_igbt_line = 0.75;

%% Simulation data sampling time
Tc=1e-5;
Ts=Tc;
Tsamp=Tc;
t_misura=simlength;
Nc=ceil(t_misura/Tc);

%% errors thresholds 
udc_min = 0.85;
% udc_min = 0.75;
uxi_min = 0.8; %PLL
settle_time = 0.1;
%% motor side inductance
LFi_d=80e-6;
RLFi_d=157*0.08*LFi_d;
LFi_0=LFi_d/10;
RLFi_0=RLFi_d/3;

%% Power cable impedance
% r_cu=0.0178;
% L=80; % lenght in m
% S=90; % section in mm2
% Rcable=r_cu/S*L;
% Lcable=40e-6; % 1m of power cable means 0.5uH of inductance

%% data generator and plant
LD9_29rpm38;
plant_data;
% Omega_sim = wm_motor;
Omega_sim = wm_motor*plant_motor_ratio;
sign_speed = 1;
wref = Omega_sim;
tref = 2; % ramp for speed
% timeRamp=tref*1; % ramp for load
% timeRamp=tref; % ramp for load

%% DClink capacitor dimensioning
C_DCLink = 900e-6*8;
R_DCLink = 1.4e-2/12;
R_DCLink_Blider = 1e3;

%% MV/LV transformer
Ptrafo = 1600e3;
I0 = 1.4; %no load current
Vcc_perc = 5; %cc voltage percente
VlineMV = 20e3; % primary voltage
VlineLV = 400; % secondary voltage
VphaseMV=VlineMV/sqrt(3);
VphaseLV=VlineLV/sqrt(3);
f_grid=50;
w_grid = f_grid*2*pi;
Inom_trafo=Ptrafo/VlineLV/sqrt(3);
Ld2_trafo= VphaseLV/(100/Vcc_perc)/Inom_trafo/(w_grid); %leakage inductace
Rd2_trafo = 0.02*Ptrafo/3/Inom_trafo^2; 
Lmu2_trafo= VphaseLV/I0/(w_grid); %magentization inductance
% Piron = 1.4e3;
% Rm2_trafo = VphaseLV^2/(Piron/3);
% phi_trafo = Lmu2_trafo*I0*sqrt(2);

%% grid filter dimensioning
LFu1_AFE=0.33e-3;
RLFu1_AFE=157*0.05*LFu1_AFE;
LFu1_AFE_0=LFu1_AFE;
RLFu1_AFE_0=RLFu1_AFE/3;
CFu=185e-6*2;
RCFu=50e-3;

%% Vdc link 
Vdc_norm_ref = 1;
Vdc_nom = Vdc_ref;
kp_vs = 5;
ki_vs = 35;

%% AFE
kp_afe=0.6;
ki_afe=5;
Igrid_phase_normalization_factor = 250e3/VphaseLV/3/0.9*sqrt(2);
Ixi_lim = 1.8;
Ieta_lim = 1.8;

%kp_dcc=0.2;
%ki_dcc=2;
% kdcc_out_alpha = -1;
% kdcc_out_beta = -1;
%kdcc_out_alpha = 0;
%kdcc_out_beta = 0;

%% PLL
Vgrid_phase_normalization_factor = VphaseLV*sqrt(2);
pll_i1 = 80;
pll_p = 1;
Vmax_ff=1.1;
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%% ZERO sequence current loop
%ki_0 = 2;
%kp_0 = 0.2;
zc_lim = 0.2;

%% Grid voltage loop - island mode
kp_vgrid = 0.15;
ki_vgrid = 10;
kv_droop = 0.35;
kp_rc_grid = 0.1;
ki_rc_grid = 2;
v_grid_ref = 230;
v_grid_ref_norm = v_grid_ref * sqrt(2) / Vgrid_phase_normalization_factor;
voltage_mes_err = 1;
omega_est_err = 1;

%% Grid frequency loop - island mode
kp_fgrid = 0.01*w_grid;
ki_fgrid = 0.1*w_grid;
kf_droop = 0.02;
f_grid_ref = 50;
w_grid_ref = 2*pi*f_grid_ref;
w_grid_ref_norm = w_grid_ref / w_grid;

%% Grid impedance calc
grid_hamp_ref = 0.0;
grid_hfreq_ref = 25;
isnld_impest_treshold = 1.25;

%% islanding detection
isnld_vout_treshold = 1.5;
isnld_ixitilde_treshold = 0.5;
isnld_omega_tolerance_treshold = 0.08;
isnld_omega_tolerance_treshold_max = 0.15;

% isnld_vout_treshold = 1.5e3;
% isnld_ixitilde_treshold = 0.5e3;
% isnld_omega_tolerance_treshold = 0.08e3;

%% FFT
Tcontrol_mond=1e-3; 
k = 1;
f2=grid_hfreq_ref;
N = 1/(f2/k)/Tcontrol_mond;


%% motor current loop - Q
id_ref_norm = 0;
% zero=(Rs_norm)/(Ld_norm+LFi_d/Lbez);
ki_inv_q=18;
kp_inv_q=2;
% ki_inv_q=10^(-20/20);
% kp_inv_q=ki_inv_q/zero;
id_lim = 0.25;
reg_inv_q=ki_inv_q/s+kp_inv_q;
regd_inv_q=c2d(reg_inv_q,Tcontrol_INV);
p_inv_q = Ubez/(s*(Lq_norm+LFi_d/Lbez)+(Rs_norm));
pd_inv_q = c2d(p_inv_q,Tcontrol_INV);
INVsys_q = minreal(pd_inv_q*regd_inv_q);
figure; margin(INVsys_q); 
set(cstprefs.tbxprefs,'FrequencyUnits','Hz');
legend('Current iq at INV stage');
grid on;

%% motor current loop - D
iq_ref_norm = 1;
zero=(Rs_norm)/(Lq_norm+LFi_d/Lbez);
ki_inv_d=18;
kp_inv_d=2;
iq_lim = 1.4;
% ki_inv_d=10^(-20/20);
% kp_inv_d=ki_inv_d/zero;
reg_inv_d=ki_inv_d/s+kp_inv_d;
regd_inv_d=c2d(reg_inv_d,Tcontrol_INV);
p_inv_d = Ubez/(s*(Ld_norm+LFi_d/Lbez)+(Rs_norm));
pd_inv_d = c2d(p_inv_d,Tcontrol_INV);
INVsys_d=minreal(pd_inv_d*regd_inv_d);
figure; margin(INVsys_d); 
set(cstprefs.tbxprefs,'FrequencyUnits','Hz');
legend('Current id at INV stage');
grid on;

%% speed loop control SPEED LOOP CONTROL
% zero = 2*pi/(tau_m*10);
% kp_w=10^(20/20)
% ki_w=kp_w/zero
% kp_w=1.4;
% ki_w=8;
kp_w = 8;
ki_w = 35;

reg_speed=ki_w/s+kp_w;
regd_speed=c2d(reg_speed,Tcontrol_INV);
regd2_inv=minreal(kp_w+ki_w*Tcontrol_INV/(1-z_inv^-1));
plant=Tnom/(s*J);
plantd=c2d(plant,Tcontrol_INV);
INVsys=minreal(plantd*regd_speed);
figure; margin(INVsys); 
set(cstprefs.tbxprefs,'FrequencyUnits','Hz');
legend('Speed Loop');
grid on;

%% device parameters
Ron=3.5e-3;
Csnubber=0.15e-6;
Rsnubber=2.2;

%% storage
%boost2storage;

%% filters
fcut = 400;
fof = 1/(s/(2*pi*fcut)+1);
[nfof dfof] = tfdata(fof,'v');
[nfofd dfofd]=tfdata(c2d(fof,Tcontrol_AFE),'v');
fof_z = tf(nfofd,dfofd,Tcontrol_AFE,'Variable','z');
[A,B,C,D] = tf2ss(nfofd,dfofd);
vff_flt_ss = ss(A,B,C,D,Tcontrol_AFE);

fcut = 40;
fof = 1/(s/(2*pi*fcut)+1);
[nfof dfof] = tfdata(fof,'v');
[nfofd dfofd]=tfdata(c2d(fof,Tcontrol_AFE),'v');
fof_z = tf(nfofd,dfofd,Tcontrol_AFE,'Variable','z');
[A,B,C,D] = tf2ss(nfofd,dfofd);
LVRT_flt_ss = ss(A,B,C,D,Tcontrol_AFE);

fcut = 10;
fof = 1/(s/(2*pi*fcut)+1);
[nfof dfof] = tfdata(fof,'v');
[nfofd dfofd]=tfdata(c2d(fof,Tcontrol_AFE),'v');
fof_z = tf(nfofd,dfofd,Tcontrol_AFE,'Variable','z');
[A,B,C,D] = tf2ss(nfofd,dfofd);
ten_hz_flt_ss = ss(A,B,C,D,Tcontrol_AFE);

fcut = 10;
fof = 1/(s/(2*pi*fcut)+1);
[nfof dfof] = tfdata(fof,'v');
[nfofd dfofd]=tfdata(c2d(fof,Tcontrol_INV),'v');
fof1_z = tf(nfofd,dfofd,Tcontrol_INV,'Variable','z');
[A,B,C,D] = tf2ss(nfofd,dfofd);
fof1_z_ss = ss(A,B,C,D,Tcontrol_INV);
figure;
set(cstprefs.tbxprefs,'FrequencyUnits','Hz');
bode(fof,fof1_z);
grid;

apf = (s/w_grid-1)/(s/w_grid+1);
[napfd dapfd]=tfdata(c2d(apf,Tcontrol_AFE),'v');
apf_z = tf(nfofd,dfofd,Tcontrol_AFE,'Variable','z');
[A,B,C,D] = tf2ss(napfd,dapfd);
ap_flt_ss = ss(A,B,C,D,Tcontrol_AFE);

butterworth = 10;
wc = 2*pi*butterworth;
a = s/wc;
Dn = (a^2 + 0.5176*a + 1)*(a^2 + 1.4142*a + 1)*(a^2 + 1.9319*a + 1);
Hs = minreal(1/Dn);
Hz = c2d(Hs, Tcontrol_AFE);
figure;
bode(Hz); 
grid on

fcut_u_stack_flt = 161;
fof = 1/(s/(fcut_u_stack_flt*2*pi)+1);
[nfof dfof] = tfdata(fof,'v');
[nfofd dfofd]=tfdata(c2d(fof,Tcontrol_INV),'v');
fof2_z = tf(nfofd,dfofd,Tcontrol_INV,'Variable','z');
[A,B,C,D] = tf2ss(nfofd,dfofd);
fof2_z_ss = ss(A,B,C,D,Tcontrol_INV);
figure;
set(cstprefs.tbxprefs,'FrequencyUnits','Hz');
bode(fof,fof2_z);
grid;

g0 = fcut_u_stack_flt * Tcontrol_INV;
g1 = 1 - g0;

g0_afe = fcut_u_stack_flt * Tcontrol_AFE * 2*pi;
g1_afe = 1 - g0_afe;

% H_u_stack_flt = z_inv^-1 * g0/(1 - z_inv^-1 * g1);
H_u_stack_flt = g0/(1 - z_inv^-1 * g1);

figure;
set(cstprefs.tbxprefs,'FrequencyUnits','Hz');
bode(H_u_stack_flt,fof2_z);
grid;


% 
% Tload = Tload/3

%% 
close all

