clear all
close all
clc

ts = 1e-3;
simulation_length = 2;
Tc = 1e-5;
Nc = floor(simulation_length/Tc);
omega_bez = 2*pi*50;

%% flywheel model with load
J=1;
A = [0 1; 0 0];
B = [0 1/J]';
E = [0 -1/J]';
C = [1 0];

%% state with load observer
Ae = [0 1 0; 0 0 -1/J; 0 0 0];
Be = [0 1/J 0]';
Aed = eye(3)+Ae*ts;
Bed = Be*ts;
Ce = [1 0 0];

poles = [-omega_bez -omega_bez*5 -omega_bez*15];
polesd = exp(poles*ts);
Le = (acker(Ae',Ce',poles))'
Led = (acker(Aed',Ce',polesd))'

%% PI control
kp = 0.1*omega_bez;
ki = 1*omega_bez;



