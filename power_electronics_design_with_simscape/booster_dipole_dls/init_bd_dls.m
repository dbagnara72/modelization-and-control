clear all
close all
clc
beep off
pm_addunit('percent', 0.01, '1');
options = bodeoptions;
options.FreqUnits = 'Hz';


s = tf('s');
omega0 = 2*pi *5;

num1 = [1 0];
den1 = [1 0 omega0^2];

Hc1 = tf(num1,den1);
figure;
bode(Hc1,options);
grid on
[A1, B1, C1, d1] = tf2ss(num1,den1);
