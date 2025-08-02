clear all
close all
clc


load data_engine_D934.mat

figure; 
plot(time, speed,time,torque,time,torque_sp);
grid on

tsample = 1e-3;