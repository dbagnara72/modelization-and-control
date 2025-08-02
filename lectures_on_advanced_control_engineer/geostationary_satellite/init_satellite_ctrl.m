close all
clear all
clc

ts = 1;
simlength = 10000;

r0 = 4.22e7; %m
omega_0 = 7.291e-5; %rad/s
vt = r0*omega_0;
ms = 250; %kg

A = [0 1 0 0; 3*omega_0^2 0 0 2*vt; 0 0 0 1; 0 -2*omega_0/r0 0 0];
B = 1/ms*[0 0; 1 0; 0 0; 0 1/r0];
C = [1 0 0 0; 0 0 1 0];

poles = [ -1e-3 -2e-3 -1e-4 -2e-4];
K = (place(A,B,poles))
L = (place(A',C',poles)*19)'
N = -inv(C*inv(A-B*K)*B)



