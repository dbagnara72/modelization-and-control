clear all
close all
clc
beep off


%% utility data for simulation
options = bodeoptions;
options.FreqUnits = 'Hz';
tsample = 1e-3;
simulation_length = 245;
simlength = simulation_length;
t_measure = simlength;
Tc = tsample;
Nc = floor(t_measure/Tc);
s = tf('s');
z = tf('z',tsample);
modulo_2pi = 2*pi;

load_blade_enable = 0;

%% unit definition for fuel consumption
% pm_addunit('kWhr', 3600, 'kJ')

%% travel (driver) gear 
b1 = 5e-2;
b2 = b1;
b_theta = 1;
J1 = 0.05;
J2 = J1;
k_theta = 1e5;

%% blade actuator
valve_mmorifice_max = 2.75; %mm
btheta_shaft = 2e2;
ktheta_shaft = 2e6;
load_blade_enable = 0;

%% vehicle antistall system

% volumetric displacements
Vm_nom = 280;
Vp_nom = 210;

% effciiencies
eta_v_p = 0.97; 
eta_v_m = 0.98;
eta_m_p = 0.97; 
eta_m_m = 0.98;
% eta_v_p = 1; 
% eta_v_m = 1;
% eta_m_p = 1; 
% eta_m_m = 1;

eta_v = eta_v_m*eta_v_p
eta_m = eta_m_p*eta_m_m

% travel gear
R_tg = 1.16/2;
n_tg = 54.31;

v_vehicle_max = 11; % km/h

omega_l_max = v_vehicle_max/3.6/R_tg;
omega_l_max_rpm = omega_l_max/(2*pi)*60

omega_m_max = omega_l_max*n_tg;
omega_m_max_rpm = omega_m_max/(2*pi)*60

% omega_e_rpm_ref = 1940;
% omega_e_rpm_ref = 1900;
% omega_e_rpm_ref = 1940;
omega_e_rpm_ref = 1700;

%% speed track set point for simulation
v_track1_ref = 8; %km/h;
v_track2_ref = 8; %km/h;

% v_track1_ref = 5; %km/h;
% v_track2_ref = 5; %km/h;

% v_track1_ref = 4; %km/h;
% v_track2_ref = 4; %km/h;

%% feedforward
omega_l_1_ref_rpm = v_track1_ref/3.6/R_tg/(2*pi)*60
omega_l_2_ref_rpm = v_track2_ref/3.6/R_tg/(2*pi)*60

omega_m_1_ref_rpm = omega_l_1_ref_rpm*n_tg
omega_m_2_ref_rpm = omega_l_2_ref_rpm*n_tg

d1_ff_temp = abs(Vm_nom/Vp_nom/eta_v*omega_l_1_ref_rpm/omega_e_rpm_ref*n_tg)
d2_ff_temp = abs(Vm_nom/Vp_nom/eta_v*omega_l_2_ref_rpm/omega_e_rpm_ref*n_tg)

if d1_ff_temp >= 1
    d1_ff = 2 - 1/d1_ff_temp;
else
    d1_ff = d1_ff_temp;
end

if d2_ff_temp >= 1
    d2_ff = 2 - 1/d2_ff_temp;
else
    d2_ff = d2_ff_temp;
end

% max load per driveline
tau_load_max = 1600*41.4; %Nm

% scenario 0
% track_friction_1 = 0e3;
% track_friction_2 = 0e3;
% tau_load = 1650*41.4/2;

%% scenario 1
% track_friction_1 = 0e3;
% track_friction_2 = 0e3;
% tau_load = 0;

%% scenario 2
track_friction_1 = 3.5e3;
track_friction_2 = 3.5e3;
tau_load = 75e3;

%% scenario 3
% track_friction_1 = 0.15e3;
% track_friction_2 = 0.15e3;
% tau_load = -250*41.4; %% negative load means slope-down condition


% %% scenario 4 - max load
% track_friction_1 = 0.5e3;
% track_friction_2 = 0.5e3;
% tau_load = tau_load_max*0.75;

%% scenario 4b 
% track_friction_1 = 1.35e3*1.5;
% track_friction_2 = 1.35e3;
% tau_load = tau_load_max*0.25;

% % scenario 4c
% track_friction_1 = 1.35e3*20;
% track_friction_2 = 1.35e3*0;
% tau_load = tau_load_max*0.025;


%% scenario 5
% track_friction_1 = 8.5e3;
% track_friction_2 = 0e3;
% tau_load = 0e3;

%% speed control
n1=1;
n2=1;
kp_ctrl_sum_speed = 0.25/n1;
ki_ctrl_sum_speed = 4/n1;
kp_ctrl_diff_speed = 0.25/n2;
ki_ctrl_diff_speed = 4/n2;

%% engine data
ic_engine_data;
rpm_base;
torque_base;
torque_friction_base;
available_torque = torque_base+torque_friction_base;

rpm_consumption;
torque_consumption;
consumption;

%% anti stall
dp_lim = 400;
te_lim = max(torque_base);
kp_te_comp = 1/te_lim;
ki_te_comp = 2/te_lim;
kp_dp_comp = 0.5/dp_lim;
ki_dp_comp = 1/dp_lim;



%% permanent magnet valve actuator
Bm = 1;
mv = 0.05;
Lc = 10e-3;
Rc = 10;
bv = 2e3;
h = 0.05;
xv_max = 1; %mm
n = 1000;
uc_max = 25; 

%% servo pump actuator
bulk = 1.2e9;
rho = 850;
A = 0.0029235; % m^2
B = A;
D1 = sqrt(4*A/pi);
D2 = sqrt(4*B/pi);
Lp = 0.02;
mp = 1;
kp = 41e3;
bp = 1e3;

%% servo motor actuator
S_Am = 0.00008; % m^2
S_Bm = 0.0000425; % m^2
Dh = sqrt(4*S_Am/pi);
Dr = sqrt(4*S_Bm/pi);
Lpm = 0.08;
mp_m = 1;
kp_m = 2e3;
bp_m = 2e3;
xv_m_max = 1.2; %mm
kp_ctrl_m = 1;

%% Engine control PI
kp_engine = 1e-2;
ki_engine = 1e-1;


%% pump servo model and control
k = 5.5e-3;
modelest = (k/s^2);
Apump = [0 1; 0 0];
Bpump = [0 1]';
Cpump = [k 0];

poles = [-1 -2 ]*5;
pole_so = [poles]*25;
iscontrollable = (det(ctrb(Apump,Bpump)))
isobservable = (det(obsv(Apump,Cpump)))
Lpump = acker(Apump',Cpump',pole_so)'

Kpump = acker(Apump,Bpump,poles)
Npump = -1/(Cpump*inv(Apump-Bpump*Kpump)*Bpump)

%% motor servo model and control
Amotor = 1;
Bmotor = 1;
Cmotor = 25e-5;

poles_motor = -100;
pole_so_motor = poles_motor;
% iscontrollable = (det(ctrb(Amotor,Bmotor)))
% isobservable = (det(obsv(Amotor,Cmotor)))
Lmotor = acker(Amotor',Cmotor',pole_so_motor)'

Kmotor = acker(Amotor,Bmotor,poles_motor)
Nmotor = -1/(Cmotor*inv(Amotor-Bmotor*Kmotor)*Bmotor)


%% filter ref
w0 = 2*2*pi;
filter_ref = w0^2/(s^2+2*w0*s+w0^2);
filterd_ref = c2d(filter_ref,tsample);

Ron = 3e-3;
Rsnubber = 1e6;
Csnubber = 1e-12;

%% Lithium Ion Battery
soc_init = 0.8;

R = 8.3143;
F = 96487;
T = 273.15+40;
Qhr = 400; %A*hr
Ncell = 185;
R0 = 0.015; %Ohm
R1 = 0.015; %Ohm
C1 = 10; %F
M = 125; %V
alpha = 35;
E_1 = -1.031;
E0 = 3.685;
E1 = 0.2156;
E2 = 0;
E3 = 0;
Elog = -0.05;


Vdc_nom = 720;
Pnom = 180e3;
Idc_nom = Pnom/Vdc_nom;
Rmax = Vdc_nom^2/(Pnom*0.1);
Rmin = Vdc_nom^2/(Pnom);



q1Kalman = tsample^2*1e-2;
q2Kalman = tsample^1*1e-1;
q3Kalman = 0;
rKalman = 1;

Zmodel = (0:1e-3:1);
ocv_model = E_1*exp(-Zmodel*alpha) + E0 + E1*Zmodel + E2*Zmodel.^2 +...
    E3*Zmodel.^3 + Elog*log(1-Zmodel+tsample);

% figure; 
% plot(Zmodel,ocv_model,'LineWidth',2);
% xlabel('$z(t)/p.u.$','Interpreter','latex')
% ylabel('$OCV(z)/V$','Interpreter','latex')
% title('\textbf{Cell open circuit voltage as function of the state of charge}','Interpreter','latex');
% grid on
% print -deps ocv
 










