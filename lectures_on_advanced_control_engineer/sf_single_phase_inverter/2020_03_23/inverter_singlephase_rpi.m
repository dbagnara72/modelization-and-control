clear all
close all
clc


w0=2*pi*50;
w=5*w0;

Ts=1e-4;
s=tf('s');
z=tf('z',Ts);

R1=1e-1;
L1=250e-6;
C1=400e-6;
R2=1e-1;
L2=60e-6;

kp = 1;
ki = 35;
Aresd = [cos(w0*Ts) sin(w0*Ts)/w0; -w0*sin(w0*Ts) cos(w0*Ts)];
Bresd = [(1-cos(w0*Ts))/w0^2 sin(w0*Ts)/w0]';
Cres = [0 1];

A = [-R1/L1 0 -1/L1; ...
    0 -R2/L2 1/L2; ...
    1/C1 -1/C1 0];
B = [1/L1 0 0]';
E = [0 -1/L2 0]';
C = [1 0 0; 0 0 1];

Ae = [-R1/L1 0 -1/L1 0 0; ...
    0 -R2/L2 1/L2 -1/L2 0; ...
    1/C1 -1/C1 0 0 0;
    0 0 0 0 1;
    0 0 0 -w^2 0];

Be = [1/L1 0 0 0 0]';

Ce = [1 0 0 0 0; 0 0 1 0 0];

Aed = eye(5) + Ae*Ts + Ae^2*Ts^2/2 + Ae^3*Ts^3/factorial(3)+ Ae^3*Ts^4/factorial(4);
Bed = Be*Ts + Ae*Be*Ts^2/2 + Ae^2*Be*Ts^3/factorial(3) + Ae^3*Be*Ts^4/factorial(4)...
    + Ae^4*Be*Ts^5/factorial(5);

rank(obsv(Ae,Ce))

p1 = -250*2*pi;
p2 = p1*1.1;
p3 = p2*1.1;
p4 = p3*1.1;
p5 = p4*1.1;
zp=exp([p1*Ts,p2*Ts,p3*Ts,p4*Ts,p5*Ts]);
Led = place(Aed',Ce',zp)'
d = 3.5e-1;


Tc=1e-5;
simlength = 0.1;
Nc=floor(simlength/Tc);








