clear all
close all
clc


w0 = 2*pi*50;
w = 2*w0;

Ts = 1e-4;
s = tf('s');
z = tf('z',Ts);

R1 = 1e-1;
L1 = 250e-6;
C1 = 200e-6;
RC1 = 250e-3;
R2 = 1e-1;
L2 = 60e-6;

kp = 1;
ki = 35;
Aresd = [cos(w0*Ts) sin(w0*Ts)/w0; -w0*sin(w0*Ts) cos(w0*Ts)];
Bresd = [(1-cos(w0*Ts))/w0^2 sin(w0*Ts)/w0]';
Cres = [0 1];

A = [-(R1+RC1)/L1 RC1/L1 -1/L1; ...
    RC1/L2 -(RC1+R2)/L2 1/L2; ...
    1/C1 -1/C1 0];
B = [1/L1 0 0]';
E = [0 -1/L2 0]';
C = [1 0 0; 0 0 1];

Ae = [-(R1+RC1)/L1  RC1/L1  -1/L1 0 0; ...
    RC1/L2  -(RC1+R2)/L2  1/L2  -1/L2  0; ...
    1/C1 -1/C1 0 0 0; ...
    0 0 0 0 1; ... 
    0 0 0 -w^2 0];

Be = [1/L1 0 0 0 0]';

Ce = [1 0 0 0 0; 0 0 1 0 0];

Aed = eye(5) + Ae*Ts;
Bed = Be*Ts;

% Aed = eye(5) + Ae*Ts + Ae^2*Ts^2/2 + Ae^3*Ts^3/factorial(3)+ Ae^3*Ts^4/factorial(4);
% Bed = Be*Ts + Ae*Be*Ts^2/2 + Ae^2*Be*Ts^3/factorial(3) + Ae^3*Be*Ts^4/factorial(4)...
%     + Ae^4*Be*Ts^5/factorial(5);

rank(obsv(Ae,Ce))
poles2place = -Ts*[50 55 60 140 165]*2*pi*3
% poles2place = -Ts*[50 55 60 200 250]*2*pi
zp=exp(poles2place);
Led = place(Aed',Ce',zp)'
d = 5;


Tc=1e-5;
simlength = 1;
Nc=floor(simlength/Tc);








