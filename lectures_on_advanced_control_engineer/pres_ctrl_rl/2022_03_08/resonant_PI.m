clear all
close all
clc


w = 2*pi*50;
Ts = 1e-4;
s = tf('s');
z = tf('z',Ts)

L = 1e-3;
R = 1e-2;

kp = 0.1;
ki = 8;
RES = s/(s^2+w^2);
RPI = kp + ki * RES;
Plant = 1/(s*L+R);

% figure; bode(RPI*Plant); grid on
RPId = c2d(RPI,Ts)
rebuild = (1-exp(-s*Ts))/s/Ts


A = [0 1; -w^2 0];
B = [0 1]';
C = [0 1];
D = 0;


RESd1 = c2d(RES,Ts)
RESd2 = Ts*(z^2-z)/((1+Ts^2*w^2)*z^2-2*z+1)
% pre = w/(tan(w*Ts/2))*(z-1)/(z+1)
% RESd3 = minreal(pre/(pre^2+w^2))
k_t = w/(tan(w*Ts/2))
RESd3 = k_t*(z^2-1)/((k_t^2+w^2)*z^2-2*(k_t^2-w^2)*z+k_t^2+w^2)

Ad = [cos(w*Ts) sin(w*Ts)/w; -w*sin(w*Ts) cos(w*Ts)];
Bd = [(1-cos(w*Ts))/w^2 sin(w*Ts)/w]'
RESssd1 = ss(Ad,Bd,C,D,Ts)
RESssd2 = minreal(C*inv(z*eye(2)-Ad)*Bd)

% figure(1); bode(RES,RESssd1); grid on
% figure(2); bode(RES,RESssd2); grid on
% figure(3); bode(RES,RESd1); grid on
% figure(4); bode(RES,RESd2); grid on
figure(5); bode(RES,RESd3); grid on

%% data simulation
Tc = Ts/10;
simlegth = 2;
Nc = floor(simlegth/Tc);

