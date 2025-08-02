clear all
close all
clc

Ts = 1/1e3;
s=tf('s');
z=tf('z',Ts);

b = 20e-3;
h = 200e-3;
m = 30e-3;
Bm = 1;
L = 1e-3;
R = 0.1;
g = 9.81;

A = [0 1 0; ...
    0 -b/m Bm*h/m; ...
    0 -Bm*h/L -R/L];
B = [0 0 1/L]';
E = [0 -1/m 0]';
C = [1 0 0; 0 0 1];

Ad = eye(3) + A*Ts+ A^2*Ts^2/2;
Bd = B*Ts + A*B*Ts^2/2 + A^2*B*Ts^3/factorial(3);

rank(obsv(A,C))
rank(ctrb(A,B))
rank(obsv(Ad,C))
rank(ctrb(Ad,Bd))

poles_so = [-45,-50,-100]*2*pi;
poles_sf = poles_so/10;
poles_sod = exp(Ts*poles_so);
Ld = place(Ad',C',poles_sod)'
poles_sfd = exp(Ts*poles_sf);
Kd = place(Ad,Bd,poles_sfd)

poles_sfe = [poles_sf -2.5*2*pi];
poles_sfed = exp(Ts*poles_sfe);

Ade = [Ad Bd; [0 0 0] 0];
Bde = [[0 0 0]';1];
Ke_hat = acker(Ade,Bde,poles_sfed)
Ked = (Ke_hat+[0 0 0 1])/([Ad-eye(3) Bd; C(1,:)*Ad C(1,:)*Bd])

Tc=1e-5;
simlength = 2;
Nc=floor(simlength/Tc);


