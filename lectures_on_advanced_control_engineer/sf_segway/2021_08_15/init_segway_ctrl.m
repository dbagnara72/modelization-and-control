close all
clear all
clc

ts = 1e-3;
simlength = 20;

%% modello nel dominio del tempo continuo
m1 = 100; %m
m2 = 25; %m
J1 = 1; %rad/s
J2 = 1; %rad/s
r1 = 0.35;
r2 = 1.45;
b1 = 10;
b2 = 0;
g = 9.8;

a11 = 0; 
a12 = 1; 
a13 = 0; 
a14 = 0;

a21 = 0;

a22 = (2*b2*m2*r1*r2 - 2*(b1 + b2)*(J2 + m2*r2^2))/(-m2^2*r1^2*r2^2 + ...
 2*J1*(J2 + m2*r2^2) + r1^2*(2*J2*(m1 + m2) + m2*(2*m1 + m2)*r2^2));

a23 = (2*g*m2^2*r1*r2^2)/(-m2^2*r1^2*r2^2 + 2*J1*(J2 + m2*r2^2) + ...
 r1^2*(2*J2*(m1 + m2) + m2*(2*m1 + m2)*r2^2));

a24 = (2*(b2*m2*r1*r2 - b2*(J2 + m2*r2^2)))/(-m2^2*r1^2*r2^2 + ...
 2*J1*(J2 + m2*r2^2) + r1^2*(2*J2*(m1 + m2) + m2*(2*m1 + m2)*r2^2));

a31 = 0; 
a32 = 0; 
a33 = 0; 
a34 = 1;

a41 = 0;

a42 = (-2*b2*(J1 + (m1 + m2)*r1^2) + 2*(b1 + b2)*m2*r1*r2)/...
    (-m2^2*r1^2*r2^2 + 2*J1*(J2 + m2*r2^2) + ...
 r1^2*(2*J2*(m1 + m2) + m2*(2*m1 + m2)*r2^2));

a43 = -((2*g*m2*(J1 + (m1 + m2)*r1^2)*r2)/(-m2^2*r1^2*r2^2 + ... 
  2*J1*(J2 + m2*r2^2) + r1^2*(2*J2*(m1 + m2) + m2*(2*m1 + m2)*r2^2)));

a44 = -((2*(b2*(J1 + (m1 + m2)*r1^2) - b2*m2*r1*r2))/(-m2^2*r1^2*r2^2 + ...
  2*J1*(J2 + m2*r2^2) + r1^2*(2*J2*(m1 + m2) + m2*(2*m1 + m2)*r2^2)));
 
 
A = [a11 a12 a13 a14; a21 a22 a23 a24; a31 a32 a33 a34; a41 a42 a43 a44];

% b2 = (2*(J2 - m2*r1*r2 + m2*r2^2))/(-m2^2*r1^2*r2^2 + 2*J1*(J2 + m2*r2^2) + ...
%   r1^2*(2*J2*(m1 + m2) + m2*(2*m1 + m2)*r2^2));
% 
% b4 = (2*(J1 + (m1 + m2)*r1^2 - m2*r1*r2))/(-m2^2*r1^2*r2^2 + ...
%  2*J1*(J2 + m2*r2^2) + r1^2*(2*J2*(m1 + m2) + m2*(2*m1 + m2)*r2^2));

b2 = (2*(J2 + m2*r1*r2 + m2*r2^2))/(-m2^2*r1^2*r2^2 + 2*J1*(J2 + m2*r2^2) + ...
  r1^2*(2*J2*(m1 + m2) + m2*(2*m1 + m2)*r2^2));

b4 = -(2*(J1 + (m1 + m2)*r1^2 + m2*r1*r2))/(-m2^2*r1^2*r2^2 + ...
 2*J1*(J2 + m2*r2^2) + r1^2*(2*J2*(m1 + m2) + m2*(2*m1 + m2)*r2^2));
 
B = [0 b2 0 b4]';

C = [1 0 0 0; 0 0 1 0];
Cintegral = [1 0 0 0];
cntrl = ctrb(A,B);
rank(cntrl)
oss = obsv(A,C);
rank(oss)

%% controllo integrale nel dominio del tempo continuo
omega_1_ref = 8;

Ae = [A [0 0 0 0]'; -Cintegral 0];
Be = [B; 0];
cntrle = ctrb(Ae,Be);
rank(cntrle)
 
f1 = 4; f2 = 5; f3 = 0.1; f4 = 2; f5 = 1;
poles_sf = [-f1*2*pi, -f2*2*pi, -f3*2*pi, -f4*2*pi, -f5*2*pi]*1e-2*10*5*2;
Ke = acker(Ae,Be,poles_sf)

%% osservatore nel dominio del tempo continuo
poles_obs = [-f1*2*pi, -f2*2*pi, -f3*2*pi, -f4*2*pi]*5e-2*10*5*2;
L = (place(A',C',poles_obs))'

% %% modello nel dominio del tempo discreto
% Ad = eye(4) + A*ts;
% Bd = B*ts;
% 
% %% state feedback con integratore nel dominio del tempo discreto
% Ade = [Ad Bd; [0 0 0 0] 0];
% Bde = [[0 0 0 0]';1];
% poles_sfd = exp(poles_sf*ts);
% K_hat = acker(Ade,Bde,poles_sfd)
% Ked = (K_hat+[0 0 0 0 1])/([Ad-eye(4) Bd; Cintegral*Ad Cintegral*Bd])
% 
% poles_obsd = exp(poles_obs*ts);
% Ld = (place(Ad',C',poles_obsd))'
% 



