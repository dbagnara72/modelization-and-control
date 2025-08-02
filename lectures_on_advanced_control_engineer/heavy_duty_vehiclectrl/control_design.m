    clear all
close all
clc

s=tf('s');
options = bodeoptions;
options.FreqUnits = 'Hz';

%% model data
tsample = 1e-3;
simulation_length = 45;
Nsample = floor(simulation_length/tsample);

%% flexible shaft 
b1 = 0.05;
b2 = b1;
b_theta = 0.05;
J1 = 0.05;
J2 = J1;
k_theta = 1e5;



%% pm actuator
Bm = 1;
mv = 0.05;
Lc = 10e-3;
Rc = 10;
bv = 2e3;
h = 0.05;
xv_max = 2.75e-3;
n = 1000;
uc_max = 25; 

%% servo pump and motor control
kp_pump = 0.75;
k1_pump = 10;
kp_motor = 0.75;
k1_motor = 20;

H_ctrl_pump = kp_pump*k1_pump/(kp_pump*k1_pump + s);
H_ctrl_motor = kp_motor*k1_motor/(kp_motor*k1_motor + s);
% figure; bode(H_ctrl_pump,H_ctrl_motor,options); grid on

%% normalization
Vm_nom = 252.8;
Vp_nom = 147.2;

eta_v_p = 0.959; 
eta_v_m = 0.943;
eta_m_p = 0.909; 
eta_m_m = 0.939;

% eta_v_p = 1; 
% eta_v_m = 1;
% eta_m_p = 1; 
% eta_m_m = 1;

eta_v = eta_v_m*eta_v_p
eta_m = eta_m_p*eta_m_m
R_tg = 0.44056;
n_tg = 41.4;
v_vehicle_max = 11; % km/h

omega_l_max = v_vehicle_max/3.6/R_tg;
omega_l_max_rpm = omega_l_max/(2*pi)*60

omega_m_max = omega_l_max*n_tg;
omega_m_max_rpm = omega_m_max/(2*pi)*60

omega_e_rpm_ref = 1940;

v_track1_ref = 8; %km/h;
v_track2_ref = 8; %km/h;

omega_l_1_ref_rpm = v_track1_ref/3.6/R_tg/(2*pi)*60
omega_l_2_ref_rpm = v_track2_ref/3.6/R_tg/(2*pi)*60

omega_m_1_ref_rpm = omega_l_1_ref_rpm*n_tg
omega_m_2_ref_rpm = omega_l_2_ref_rpm*n_tg

d1_ff_temp = Vm_nom/Vp_nom/eta_v*omega_l_1_ref_rpm/omega_e_rpm_ref*n_tg
d2_ff_temp = Vm_nom/Vp_nom/eta_v*omega_l_2_ref_rpm/omega_e_rpm_ref*n_tg
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

%% max load per driveline
tau_load_max = 1600*41.4; %Nm

%% scenario 0
% track_friction_1 = 1e3;
% track_friction_2 = 1e3;
% tau_load = 1650*41.4;

%% scenario 1
% track_friction_1 = 50e3;
% track_friction_2 = 20e3;
% tau_load = 0;

%% scenario 2
% track_friction_1 = 35e3;
% track_friction_2 = 35e3;
% tau_load = 120;

%% scenario 3
track_friction_1 = 0e3;
track_friction_2 = 0e3;
tau_load = -1200*41.4; %% negative load means slope-down condition

%% scenario 4 - max load
% tau_load = tau_load_max;

%% speed control
% n1=5;
% n2=5;
n1=1;
n2=1;
kp_ctrl_sum_speed = 0.25/n1;
ki_ctrl_sum_speed = 4/n1;
kp_ctrl_diff_speed = 0.25/n2;
ki_ctrl_diff_speed = 4/n2;

%% Engine control PI
kp_engine = 1e-2;
ki_engine = 1e-1;

k = 10;
modelest = (k/s^2);

%% continuous time domain
A = [0 1; 0 0];
B = [0 1]';
C = [k 0];

poles = [-8 -12.5];
%% state feedback
K = acker(A,B,poles)
N = -1/(C*inv(A-B*K)*B)

k = 20;
modelest = (k/s^2);

%% continuous time domain
A = [0 1; 0 0];
B = [0 1]';
C = [k 0];

poles = [-8 -12.5];
%% state feedback
K = acker(A,B,poles)
N = -1/(C*inv(A-B*K)*B)


%% engine stall
available_torque = [-660.07, -796.01, -907.96, -1019.98, -1070.98, -1123.89,...
    -1175.99, -1224.03, -1254.98, -1250.99, -1250.98, -1250.98, -1050.04,...
    -934.05, -780.06, -650, -450, -350, 350, 450, 650, 780.06, 934.05,...
    1050.04, 1250.98, 1250.98, 1250.99, 1254.98, 1224.03, 1175.99,...
    1123.89, 1070.98, 1019.98, 907.96, 796.01, 660.07];

fricion = [174.38, 168.37, 159.09, 150.09, 141.86, 133.97, ...
        126.78, 120.25, 114.8, 109.53, 105.29, 101.43, 96.75, 92.76, 89.6, 86.76, ...
        84.8, 10, -10, -84.8, -86.76, -89.6 -92.76, -96.75, -101.43, -105.29, ...
        -109.53,-114.8, -120.25, -126.78, -133.97, -141.86, -150.09, ...
        -159.09, -168.37,-171.38];
    
rpm = [-2140, -2100, -2000, -1900, -1800, -1700, -1600, -1500, -1400, ...
        -1300, -1200, -1100, -1000, -900, -800, -700, -600, -5, 5, 600, ...
        700, 800, 900, 1000, 1100, 1200, 1300, 1400, 1500, 1600, 1700, 1800,...
        1900, 2000, 2100, 2140];

























































%% full implementation



% A1 = D1^2/4*pi;
% A2 = D2^2/4*pi;
% V0 = A1*5*Lp;
% 
% Alin = [0 1 0 0 0 0 0; ...
%         0 -bv/mv Bm*h*n/mv 0 0 0 0; ...
%         0 -Bm*n*h/Lc -Rc/Lc 0 0 0 0; ...
%         bulk/V0*xv_max*sqrt(2/rho) 0 0 0 0 -bulk*A1/V0 0; ...
%         -bulk/V0*xv_max*sqrt(2/rho) 0 0 0 0 0 bulk*A2/V0; ...
%         0 0 0 A1/mp -A2/mp -bp/mp -kp/mp; ...
%         0 0 0 0 0 1 0];
%     
% Blin = [0 0 1/Lc 0 0 0 0]';
% Clin = [0 0 0 0 0 0 1];
% 
% iscontrollable = (det(ctrb(Alin,Blin)))
% isobservable = (det(obsv(Alin,Clin)))








