clear all
close all
clc

s=tf('s');
ts = 1e-3;
sim_length = 600;

%% hydraulic pumps and motors data
omega_m_nom_rpm = 4000;
omega_p_nom_rpm = 2000;
Vm_nom = 280;
Vp_nom = 210;
Jm = 0.05;
Jp = 0.05;
bm = 0.02;
bp = 0.02;

% hydrostatic leakage 
kleak = 1e-6;

% effciciencies
eta_v_p = 0.97; 
eta_v_m = 0.98;
eta_m_p = 0.97; 
eta_m_m = 0.98;
%% hydro bulk
bulk = 8.36e9; 

%% additional tunable parameters
engine_speed_ref_rpm = 1940;
omega_m_ref = 3200;
tstep = 20; %s
max_domega_m_dt = omega_m_nom_rpm/4;

%% load parameters
kdrag = 0.01;
kdrag_model = 0.01;


%% generic schaft data
b1 = 5e-2;
b2 = b1;
b_theta = 1;
J1 = 0.05;
J2 = J1;
k_theta = 1e5;

%% travel gear
bd = 5e-2;
bf = 0.1;
b_theta_tg = 1;
Jd = 0.05;
Jf = J1;
k_theta_tg = 1e5;
ntg = 1;

%% engine data D9512
liebherr_engine_D9512;
kp_engine = 2.5e-2;
ki_engine = 2.5e-1;
available_torque = torque_base + torque_friction_base;

%% nonlinear observer of dp
P0 = eye(4);
q11 = 10;
q22 = 10;
q33 = 10;
q44 = 2e3;
Q = [q11 0 0 0; 0 q22 0 0; 0 0 q33 0; 0 0 0 q44];
