

%% PMSM paramerters

A1_tilde = [-Rs/Lalpha 0 0 0 0 0; 0 -Rs/Lbeta 0 0 0 0; ...
    0 0 0 0 0 0; 0 0 0 0 0 0; ...
    0 0 0 0 0 1; 0 0 0 0 0 -1/Jm*b];

A2_tilde = [0 0 0 1/Lalpha 0 0; 0 0 -1/Lbeta 0 0 0; ...
    0 0 0 -1 0 0; 0 0 1 0 0 0;...
    0 0 0 0 0 0; 0 0 0 0 0 0];

A3_tilde = [0 0 0 0 0 0; 0 0 0 0 0 -1/Lbeta; ...
    0 0 0 0 0 0; 0 0 0 0 0 1;...
    0 0 0 0 0 0; 0 3/2*p^2/Jm 0 0 0 0];

A4_tilde = [0 0 0 0 0 1/Lalpha; 0 0 0 0 0 0; ...
    0 0 0 0 0 -1; 0 0 0 0 0 0;...
    0 0 0 0 0 0; -3/2*p^2/Jm 0 0 0 0 0];

A5_tilde = [0 0 0 0 0 0; 0 0 0 0 0 0; ...
    0 0 0 0 0 0; 0 0 0 0 0 0;...
    0 0 0 0 0 0; 0 0 0 -3/2*p^2/Jm 0 0];

A6_tilde = [0 0 0 0 0 0; 0 0 0 0 0 0; ...
    0 0 0 0 0 0; 0 0 0 0 0 0;...
    0 0 0 0 0 0; 0 0 3/2*p^2/Jm 0 0 0];

B_tilde = [1/Lalpha 0; 0 1/Lbeta; 0 0; 0 0; 0 0; 0 0];

C = [1 0 0 0 0 0; 0 1 0 0 0 0];

Bd = B_tilde*tcontrol;

%% Kalman init
Qkalman = [Rs/Ls 0 0 0 0 0; 0 Rs/Ls 0 0 0 0; ...
    0 0 2*tcontrol 0 0 0;...
    0 0 0 2*tcontrol 0 0;...
    0 0 0 0 1 0; 0 0 0 0 0 1]*tcontrol*1;
% Qkalman = [1 0 0 0 0 0; 0 1 0 0 0 0; ...
%     0 0 1 0 0 0;...
%     0 0 0 1 0 0;...
%     0 0 0 0 1000 0; 0 0 0 0 0 1000];
Rkalman = [1 0; 0 1];

%% rotor speed observer
Arso = [0 1; 0 0];
Crso = [1 0];

omega_rso = 2*pi*50;

polesrso = [-5 -1]*2*pi*10;
Lrso = acker(Arso',Crso',polesrso)'

Adrso = eye(2) + Arso*tcontrol;
polesdrso = exp(tcontrol*polesrso);
Ldrso = acker(Adrso',Crso',polesdrso)'

%% filter ref
w0 = 2*2*pi;
filter_ref = w0^2/(s^2+2*w0*s+w0^2);
filterd_ref = c2d(filter_ref,tcontrol);

