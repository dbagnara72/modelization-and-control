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
RES = s/(s^2+w0^2);
RPI = kp + ki * RES;
PI = kp + ki * 1/s;

A = [-R1/L1 0 -1/L1; ...
    0 -R2/L2 1/L2; ...
    1/C1 -1/C1 0]
B = [1/L1 0 0]';
E = [0 -1/L2 0]';
C = [1 0 0; 0 0 1];
% sys_ss = ss(A,B,C(1,:),0);
% sys = minreal(tf(sys_ss))
% figure; rlocus(sys); grid on
Ae = [-R1/L1 0 -1/L1 0 0; ...
    0 -R2/L2 1/L2 -1/L2 0; ...
    1/C1 -1/C1 0 0 0;
    0 0 0 0 1;
    0 0 0 -w^2 0]
Be = [1/L1 0 0 0 0]';
Ce = [1 0 0 0 0; 0 0 1 0 0];
Aed = eye(4) + A*Ts+ A^2*Ts^2/2 + A^3*Ts^3/factorial(3)+ A^3*Ts^4/factorial(4);
Bed = B*Ts + A*B*Ts^2/2 + A^2*B*Ts^3/factorial(3) + A^3*B*Ts^4/factorial(4)...
    + A^4*B*Ts^5/factorial(5);

rank(obsv(Ae,Ce))
rank(ctrb(Ae,Be))
p1 = -250*2*pi;
p2 = p1*1.05;
p3 = p2*1.05;
p4 = p3*1.05;
p5 = p4*1.05;
Le = place(Ae',Ce',[p1,p2,p3,p4,p5])'
Le1 = acker(Ae',Ce(1,:)',[p1,p2,p3,p4,p5])'
Le2 = acker(Ae',Ce(2,:)',[p1,p2,p3,p4,p5])'
Ler = [Le1 Le2]
K = place(A,B,[-150*2*pi,-120*2*pi,-140*2*pi])
N = -inv(C(1,:)*(A-B*K)^-1*B)

d = 3.5e-1;

As = [A [0 0 0]'; -C(1,:) 0]
Bs = [B; 0]
% Ks = acker(As,Bs,[-5*2*pi,-6*2*pi,-7*2*pi,-10*2*pi])
Ks = acker(As,Bs,[-(10+i*10)*2*pi,-(10-i*10)*2*pi,...
    -(15+i*10)*2*pi,-(15-i*10)*2*pi])

simlength = 0.1;








