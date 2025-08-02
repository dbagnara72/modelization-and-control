clear all
close all
clc

options = bodeoptions;
options.FreqUnits = 'Hz';
options.xlim = [1 1e3];

w = 2*pi*50;
ts = 1e-3;
s = tf('s');
z = tf('z',ts);

L = 1e-3;
R = 1e-2;

% controller = ki*(s*kp/ki+1)/s
% plant = 1/(R*(s*L/R+1))
% kp/ki = L/R --> kp = L/R*ki

omega_p = R/L;
omega_c = 4*omega_p;
ki = 18;
kp = ki/omega_c;


RES = s/(s^2+w^2);
PI = kp + ki/s;
RPI = kp + ki * RES;
Plant = 1/(s*L+R);

figure; margin(PI*Plant,options); grid on
Fh = gcf;                                                   % Handle To Current Figure
Kids = Fh.Children;                                         % Children
AxAll = findobj(Kids,'Type','Axes');                        % Handles To Axes
Ax1 = AxAll(1);                                             % First Set Of Axes
LinesAx1 = findobj(Ax1,'Type','Line');                      % Handle To Lines
LinesAx1(2).LineWidth = 2;                                  % Set ‘LineWidth’
LinesAx1(2).Color = 'k';                                  % Set color
Ax2 = AxAll(2);                                             % Second Set Of Axes
LinesAx2 = findobj(Ax2,'Type','Line');                      % Handle To Lines
LinesAx2(2).LineWidth = 2;  
LinesAx2(2).Color = 'k';                                  % Set color
print -depsc PIdesign

figure; bode(RPI*Plant,options); grid on
Fh = gcf;                                                   % Handle To Current Figure
Kids = Fh.Children;                                         % Children
AxAll = findobj(Kids,'Type','Axes');                        % Handles To Axes
Ax1 = AxAll(1);                                             % First Set Of Axes
LinesAx1 = findobj(Ax1,'Type','Line');                      % Handle To Lines
LinesAx1(2).LineWidth = 2;                                  % Set ‘LineWidth’
LinesAx1(2).Color = 'k';                                  % Set color
Ax2 = AxAll(2);                                             % Second Set Of Axes
LinesAx2 = findobj(Ax2,'Type','Line');                      % Handle To Lines
LinesAx2(2).LineWidth = 2; 
LinesAx2(2).Color = 'k';                                  % Set color
print -depsc PRdesign


rebuild = (1-exp(-s*ts))/s/ts;

A = [0 1; -w^2 0];
B = [0 1]';
C = [0 1];
D = 0;

Ad = [cos(w*ts) sin(w*ts)/w; -w*sin(w*ts) cos(w*ts)];
Bd = [(1-cos(w*ts))/w^2 sin(w*ts)/w]';

%% data simulation
Tc = ts/20;
simlegth = 0.3;
Nc = floor(simlegth/Tc);

