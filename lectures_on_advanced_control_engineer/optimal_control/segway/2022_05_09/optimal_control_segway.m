
clearvars
close all
clc


ts = 1e-4;
N = 40e4;
t=0:ts:(N-1)*ts;

options = bodeoptions;
options.FreqUnits = 'Hz';

%% modello nel dominio del tempo continuo
m1 = 100; %m
m2 = 25; %m
J1 = 0.25; 
J2 = 25; 
r1 = 0.35;
r2 = 1.75;
b1 = 0;
b2 = 0;
g = 9.8;

D = (-m2^2*r1^2*r2^2 + ...
 2*J1*(J2 + m2*r2^2) + r1^2*(2*J2*(m1 + m2) + m2*(2*m1 + m2)*r2^2));
a11 = 0; 
a12 = 1; 
a13 = 0; 
a14 = 0;

a21 = 0;

a22 = (2*b2*m2*r1*r2 - 2*(b1 + b2)*(J2 + m2*r2^2))/D;

a23 = (2*g*m2^2*r1*r2^2)/D;

a24 = (2*(b2*m2*r1*r2 - b2*(J2 + m2*r2^2)))/D;

a31 = 0; 
a32 = 0; 
a33 = 0; 
a34 = 1;

a41 = 0;

a42 = (-2*b2*(J1 + (m1 + m2)*r1^2) + 2*(b1 + b2)*m2*r1*r2)/D;

a43 = -((2*g*m2*(J1 + (m1 + m2)*r1^2)*r2)/D);

a44 = -((2*(b2*(J1 + (m1 + m2)*r1^2) - b2*m2*r1*r2))/D);
 
 
Atilde = [a11 a12 a13 a14; a21 a22 a23 a24; ...
    a31 a32 a33 a34; a41 a42 a43 a44];

b2 = (2*(J2 + m2*r1*r2 + m2*r2^2))/(-m2^2*r1^2*r2^2 + 2*J1*(J2 + m2*r2^2) + ...
  r1^2*(2*J2*(m1 + m2) + m2*(2*m1 + m2)*r2^2));

b4 = -(2*(J1 + (m1 + m2)*r1^2 + m2*r1*r2))/(-m2^2*r1^2*r2^2 + ...
 2*J1*(J2 + m2*r2^2) + r1^2*(2*J2*(m1 + m2) + m2*(2*m1 + m2)*r2^2));
 
Btilde = [0 b2 0 b4]';

% C = [1 0 0 0; 0 0 1 0];
% C1 = [1 0 0 0];
% C2 = [0 0 1 0];

A = eye(4) + Atilde*ts;
B = Btilde*ts;

% x_0 = [0.2 0.2 0.5 1]';
x_0 = [0 20 0.2 -20]';

% S = [1 0 0 0; 0 1 0 0; 0 0 1 0; 0 0 0 1];
% Q = [1 0 0 0; 0 1 0 0; 0 0 100 0; 0 0 0 1];
% R = 0.001;

S = [1 0 0 0; 0 1 0 0; 0 0 1/ts 0; 0 0 0 1/ts];
Q = [1 0 0 0; 0 1 0 0; 0 0 1/ts 0; 0 0 0 1/ts];
R = 1;

P(:,:,N) = S;
x(:,:,1) = x_0;


%% Optimal control problem
u(:,N) = 0;
for n = 1:N-1
    K(:,:,N-n) = (R + B'*P(:,:,N-n+1)*B)\(B'*P(:,:,N-n+1)*A);
    P(:,:,N-n) = A'*P(:,:,N-n+1)*(A-B*K(:,:,N-n))+Q;
end
for n = 1:N-1
    u(:,n) = -K(:,:,n)*x(:,:,n);
    x(:,:,n+1) = A*x(:,:,n)+B*u(:,n);
end

for n = 1:N-1
    K1(n) = K(1,1,n);
end
for n = 1:N-1
    K2(n) = K(1,2,n);
end
for n = 1:N-1
    K3(n) = K(1,3,n);
end
for n = 1:N-1
    K4(n) = K(1,4,n);
end

figure; 
plot(t,x(3,:),'-k','LineWidth',2);
title('segway','Interpreter','latex');
legend('$\vartheta(t)$','Interpreter','latex','fontsize',14); 
set(gca,'xlim',[t(1) t(end)]);
% set(gca,'ylim',[-1 1]);
xlabel('t/s','Interpreter','latex');
ylabel('$rad$','Interpreter','latex');
grid on;
print -djpeg vartheta

figure; 
plot(t(1:N-1),K1,'-k','LineWidth',2);
hold on
plot(t(1:N-1),K2,'-k','LineWidth',1);
hold on
plot(t(1:N-1),K3,'--k','LineWidth',2);
hold on
plot(t(1:N-1),K4,'--k','LineWidth',1);
hold off
title('Evolution of the optimal state feedback','Interpreter','latex');
legend('$k_1(k)$','$k_2(k)$','$k_3(k)$','$k_4(k)$','Interpreter','latex',...
    'Location','best','fontsize',14); 
set(gca,'xlim',[t(1) t(end)]);
% set(gca,'ylim',[-1 4]);
xlabel('t/s','Interpreter','latex');
ylabel('','Interpreter','latex');
grid on;
print -djpeg kgains


figure; 
plot(x(3,:),x(4,:),'-k','LineWidth',2);
title('Phase portrait for $\vartheta-\dot{\vartheta}$','Interpreter','latex');
xlabel('$\vartheta$','Interpreter','latex');
ylabel('$\dot{\vartheta}$','Interpreter','latex','rotation',0);
grid on;
print -djpeg theta_phase_portrait

figure; 
plot(x(1,:),x(2,:),'-k','LineWidth',2);
title('Phase portrait for $\alpha-\dot{\alpha}$','Interpreter','latex');
xlabel('$\alpha$','Interpreter','latex');
ylabel('$\dot{\alpha}$','Interpreter','latex','rotation',0);
grid on;
print -djpeg alpha_phase_portrait

figure; 
plot(t,x(1,:),'-k','LineWidth',2);
title('segway','Interpreter','latex');
legend('$\alpha(t)$','Interpreter','latex','fontsize',14); 
set(gca,'xlim',[t(1) t(end)]);
% set(gca,'ylim',[-1 1]);
xlabel('t/s','Interpreter','latex');
ylabel('$rad$','Interpreter','latex');
grid on;
print -djpeg alpha

figure; 
plot(t,x(2,:),'-k','LineWidth',2);
title('segway','Interpreter','latex');
legend('$\dot{\alpha}(t)$','Interpreter','latex','fontsize',14); 
set(gca,'xlim',[t(1) t(end)]);
% set(gca,'ylim',[-1 1]);
xlabel('t/s','Interpreter','latex');
ylabel('$rad/s$','Interpreter','latex');
grid on;
print -djpeg alpha_dot


figure; 
plot(t,x(4,:),'-k','LineWidth',2);
title('segway','Interpreter','latex');
legend('$\dot{\vartheta}(t)$','Interpreter','latex','fontsize',14); 
set(gca,'xlim',[t(1) t(end)]);
% set(gca,'ylim',[-1 1]);
xlabel('t/s','Interpreter','latex');
ylabel('$rad/s$','Interpreter','latex');
grid on;
print -djpeg vartheta_dot

figure; 
plot(t,u,'-k','LineWidth',2);
title('Control input $u(t)$','Interpreter','latex');
legend('$\tau_m(t)$','Interpreter','latex','fontsize',14); 
set(gca,'xlim',[t(1) t(end)]);
% set(gca,'ylim',[-1 4]);
xlabel('t/s','Interpreter','latex');
ylabel('$Nm$','Interpreter','latex');
grid on;
print -djpeg tau_m


