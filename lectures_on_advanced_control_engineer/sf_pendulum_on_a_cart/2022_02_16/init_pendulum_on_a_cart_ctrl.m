close all
clear all
clc

ts = 1e-3;
simlength = 35;
tc = 1e-3;
Nc = floor(simlength/tc);

%% modello nel dominio del tempo continuo
m0 = 20; %m
m1 = 1; %m
J1 = 0.1; %rad/s
s1 = 1;
b0 = 0.35;
b1 = 0.35;
g = 9.8;

den = (-m1^2*s1^2 + (m0+m1)*(J1+m1*s1^2));

A = [0 1 0 0; ...
    0 -b0*(J1+m1*s1^2)/den  -g*m1^2*s1^2/den b1*m1*s1/den; ...
    0 0 0 1; ...
    0 b0*m1*s1/den g*m1*(m0+m1)*s1/den -b1*(m0+m1)/den];

B = [0 (J1+m1*s1^2)/den 0 -m1*s1/den]';

C = [1 0 0 0; 0 0 1 0];
Cintegral = [1 0 0 0];
cntrl = ctrb(A,B);
rank(cntrl)
oss = obsv(A,C);
rank(oss)

%% controllo integrale nel dominio del tempo continuo
Ae = [A [0 0 0 0]'; -Cintegral 0];
Be = [B; 0];
cntrle = ctrb(Ae,Be);
rank(cntrle)

f1 = 0.5; f2 = 1; f3 = 2; f4 = 3; f5 = 0.25;
poles_sf = [-f1*2*pi, -f2*2*pi, -f3*2*pi, -f4*2*pi, -f5*2*pi];
Ke = acker(Ae,Be,poles_sf)

%% osservatore nel dominio del tempo continuo
poles_obs = [-f1*2*pi, -f2*2*pi, -f3*2*pi, -f4*2*pi]*5;
L = (place(A',C',poles_obs))';

%% modello nel dominio del tempo discreto
Ad = eye(4) + A*ts;
Bd = B*ts;

%% state feedback con integratore nel dominio del tempo discreto
Ade = [Ad Bd; [0 0 0 0] 0];
Bde = [[0 0 0 0]';1];
poles_sfd = exp(poles_sf*ts);
K_hat = acker(Ade,Bde,poles_sfd);
Ked = (K_hat+[0 0 0 0 1])/([Ad-eye(4) Bd; Cintegral*Ad Cintegral*Bd])

poles_obsd = exp(poles_obs*ts);
Ld = (place(Ad',C',poles_obsd))';

%% osservatore con stima del disturbo

Ale = [0 1 0 0 0; ...
    0 -b0*(J1+m1*s1^2)/den  -g*m1^2*s1^2/den b1*m1*s1/den (J1+m1*s1^2)/den; ...
    0 0 0 1 0; ...
    0 b0*m1*s1/den g*m1*(m0+m1)*s1/den -b1*(m0+m1)/den -m1*s1/den;...
    0 0 0 0 0];
Ble = [0 (J1+m1*s1^2)/den 0 -m1*s1/den 0]';
Cle = [1 0 0 0 0; 0 0 1 0 0];

Aled = eye(5) + Ale*ts;
Bled = Ble*ts;

f5 = 25;
poles_obs_le = [-f1*2*pi, -f2*2*pi, -f3*2*pi, -f4*2*pi, -f5*2*pi]*5;
poles_obsd_le = exp(poles_obs_le*ts);
Lled = (place(Aled',Cle',poles_obsd_le))'



















