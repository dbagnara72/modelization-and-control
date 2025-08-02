clear all
close all
clc

s=tf('s');

R1 = 10e-3;
L1 = 250e-6;
Rc = 50e-3;
C = 400e-6;
R2 = 10e-3;
L2 = 60e-6;

A = [-(Rc+R1)/L1 Rc/L1 -1/L1; 
    Rc/L2 -(R2+Rc)/L2 1/L2;
    1/C -1/C 0];
B = [1/L1 0 0]';
E = [0 -1/L2 0]';
C1 = [1 0 0];
C2 = [0 1 0];
C3 = [Rc -Rc 1];

% H1 = minreal(C1/(s*eye(3)-A)*B)
H2 = minreal(C2/(s*eye(3)-A)*B)
% Hg = minreal(C3/(s*eye(3)-A)*B)

a2 = (L1*Rc+L2*Rc+L1*R2+L2*R1)/(L1*L2)
a1 = (L1+L2+R2*Rc*C+R1*R2*C+R1*R2*C)/(L1*L2*C)
a0 = (R1+R2)/(L1*L2*C)
b1 = Rc/(L1*L2)
b0 = 1/(L1*L2*C)






