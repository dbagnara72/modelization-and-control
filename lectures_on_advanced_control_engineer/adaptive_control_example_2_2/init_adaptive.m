clear all
close all
clc

lambda1 = 10;
lambda2 = 25;
m = 2;
lambda = 6;
gamma = 0.5;

A = [0 1; 0 0];
B = [0 1/m]';
C = [1 0];


Am = [0 1; -lambda2 -lambda1];
Bm = [0 lambda2]';
Cm = [1 0];
s=tf('s');
Hm = Cm*inv(s*eye(2)-Am)*Bm
figure; bode(Hm); grid on

Tc = 1e-5;
simlength = 5;
Nc = floor(simlength/Tc);

w_ref = 4;
a_ref = 1;
bias = 0;

Aobs = [0 1; 0 0];
Cobs = [1 0];
L = acker(Aobs',Cobs',[-50, -100]);

