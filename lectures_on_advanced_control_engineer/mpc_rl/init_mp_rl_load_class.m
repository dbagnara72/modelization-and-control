clearvars
close all
clc

ts = 1e-5;
udc = 250; %Volt
R = 1; % 1 Ohm
L = 1e-3; % 1mH

Atilde = -R/L;
Btilde = 1/L;
C = 1;

A = 1 + Atilde*ts;
B = Btilde*ts;

i_ref_amp = 50;
i_ref_omega = 2*pi*50;

rho = 0.0001 ;

udc_min = i_ref_amp*(sqrt(R^2+(i_ref_omega*L)^2))


