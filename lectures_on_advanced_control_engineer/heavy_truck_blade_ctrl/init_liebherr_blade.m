clear all
close all
clc


%% model data
tsample = 1e-3;
simulation_length = 140;
Nsample = floor(simulation_length/tsample);

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

%% piston with hydraulic chambers
bulk = 1.2e9;
rho = 850;
D1 = 0.1;
D2 = 0.1;
Lp = 1;
mp = 25;
kp = 20e3;
bp = 200;

%% Engine control PI
kp_engine = 1e-2;
ki_engine = 1e-1;

tsample = 1e-3;

s=tf('s');
wn=2*pi*2;
k = 0.12;
modelest = (k/s^2);

%% continuous time domain
A = [0 1; 0 0];
B = [0 1]';
C = [k 0];

poles = [-1 -2 ];
pole_so = [poles]*10;
iscontrollable = (det(ctrb(A,B)))
isobservable = (det(obsv(A,C)))
L = acker(A',C',pole_so)'

%% state feedback
K = acker(A,B,poles)
N = -1/(C*inv(A-B*K)*B)

%% discretization
pole_sod = exp(pole_so*tsample);
pole_sfd = exp(poles*tsample);

Ad = eye(2)+A*tsample
Bd = B*tsample

Kd = acker(Ad,Bd,pole_sfd)
Ld = acker(Ad',C',pole_sod)'



























































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








