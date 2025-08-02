
clear all
close all
clc


ts = 1e-3;
N = 35e3;
t=0:ts:(N-1)*ts;

options = bodeoptions;
options.FreqUnits = 'Hz';

%% modello nel dominio del tempo continuo
m0 = 20; %m
m1 = 1; %m
J1 = 0.1; %rad/s
s1 = 1;
b0 = 0.35;
b1 = 0.35;
g = 9.8;

den = (-m1^2*s1^2 + (m0+m1)*(J1+m1*s1^2));

Atilde = [0 1 0 0; ...
    0 -b0*(J1+m1*s1^2)/den  -g*m1^2*s1^2/den b1*m1*s1/den; ...
    0 0 0 1; ...
    0 b0*m1*s1/den g*m1*(m0+m1)*s1/den -b1*(m0+m1)/den];

Btilde = [0 (J1+m1*s1^2)/den 0 -m1*s1/den]';

A = eye(4)+Atilde*ts;
B = Btilde*ts;

x_0 = [0 0 1 2]';

S = [1 0 0 0; 0 1 0 0; 0 0 1 0; 0 0 0 1];
Q = [1 0 0 0; 0 1 0 0; 0 0 1 0; 0 0 0 1];
R = 0.1;

P(:,:,N) = S;
x(:,:,1) = x_0;

xa(:,:,1) = x_0;
x_lqr(:,:,1) = x_0;

% [Klqr] = lqr(A,B,Q,R)
[Klqr] = dlqr(A,B,Q,R);

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

%% steady state optimal control problem
for n = 1:N-1
    u_lqr(:,n) = -Klqr*x_lqr(:,:,n);
    x_lqr(:,:,n+1) = A*x_lqr(:,:,n)+B*u_lqr(:,n);
end
u_lqr(:,N) = 0;

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

figure(1); 
plot(t,x(1,:),'--k','LineWidth',2);
hold on
plot(t,x_lqr(1,:),'-k','LineWidth',0.75);
hold off
title('Comparison between optimal state feedback and asymptotic optimal state feedback','Interpreter','latex');
legend('$x(k)$','$x^{lqr}(k)$','Interpreter','latex'); 
set(gca,'xlim',[t(1) t(end)]);
% set(gca,'ylim',[-1 1]);
xlabel('t/s','Interpreter','latex');
ylabel('','Interpreter','latex');
grid on;
print -deps2 state_element_1

figure(2); 
plot(t,x(2,:),'--k','LineWidth',2);
hold on
plot(t,x_lqr(2,:),'-k','LineWidth',0.75);
hold off
title('Comparison between optimal state feedback and asymptotic optimal state feedback','Interpreter','latex');
legend('$v(k)$','$v^{lqr}(k)$','Interpreter','latex'); 
set(gca,'xlim',[t(1) t(end)]);
% set(gca,'ylim',[-1 1]);
xlabel('t/s','Interpreter','latex');
ylabel('','Interpreter','latex');
grid on;
print -deps2 state_element_2

figure(3); 
plot(t,x(3,:),'--k','LineWidth',2);
hold on
plot(t,x_lqr(3,:),'-k','LineWidth',0.75);
hold off
title('Comparison between optimal state feedback and free evolution','Interpreter','latex');
legend('$\vartheta(k)$','$\vartheta^{lqr}(k)$','Interpreter','latex'); 
set(gca,'xlim',[t(1) t(end)]);
% set(gca,'ylim',[-1 1]);
xlabel('t/s','Interpreter','latex');
ylabel('','Interpreter','latex');
grid on;
print -deps2 state_element_3

figure(4); 
plot(t,x(4,:),'--k','LineWidth',2);
hold on
plot(t,x_lqr(4,:),'-k','LineWidth',0.75);
hold off
title('Comparison between optimal state feedback and free evolution','Interpreter','latex');
legend('$\omega(k)$','$\omega^{lqr}(k)$','Interpreter','latex'); 
set(gca,'xlim',[t(1) t(end)]);
% set(gca,'ylim',[-1 1]);
xlabel('t/s','Interpreter','latex');
ylabel('','Interpreter','latex');
grid on;
print -deps2 state_element_4

figure(5); 
plot(t(1:N-1),K1,'-k','LineWidth',2);
hold on
plot(t(1:N-1),K2,'-k','LineWidth',1);
hold on
plot(t(1:N-1),K3,'--k','LineWidth',2);
hold on
plot(t(1:N-1),K4,'--k','LineWidth',2);
hold off
title('Evolution of the optimal state feedback','Interpreter','latex');
legend('$k_1(k)$','$k_2(k)$','$k_3(k)$','$k_4(k)$','Interpreter','latex','Location','northwest'); 
set(gca,'xlim',[t(1) t(end)]);
% set(gca,'ylim',[-1 4]);
xlabel('t/s','Interpreter','latex');
ylabel('','Interpreter','latex');
grid on;
print -deps2 sfb_gains

figure(6); 
plot(t,u,'-k','LineWidth',1);
hold on
plot(t,u_lqr,'--k','LineWidth',2);
hold off
title('Control input $u(k)$','Interpreter','latex');
legend('$u(k)$','$u_{lqr}(k)$','Interpreter','latex'); 
set(gca,'xlim',[t(1) t(end)]);
% set(gca,'ylim',[-1 4]);
xlabel('t/s','Interpreter','latex');
ylabel('','Interpreter','latex');
grid on;
print -deps2 input_u





















