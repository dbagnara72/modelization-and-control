clear all
close all
clc


F = [1 1; 2 1; 1 1];
y = [1 0 0]';

x_hat = inv(F'*F)*F'*y
y_hat = F*x_hat
e = y - y_hat
orthogonality = e'*F