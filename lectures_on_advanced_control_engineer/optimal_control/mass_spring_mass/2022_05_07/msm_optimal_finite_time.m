clear all
close all
clc


ts = 1e-4;
N = 5e4;
t = 0:ts:(N-1)*ts;

J1 = 0.025;
J2 = 0.025;
b = 0;
b_theta = 0;
k_theta = 1;

Atilde = [-(b+b_theta)/J1 b_theta/J1 -1/J1; ...
    b_theta/J2 -(b+b_theta)/J2 1/J2; ...
    k_theta -k_theta 0];
Btilde = [1/J1 0 0]';
C = [1 0 0];

A = eye(3) + Atilde*ts;
B = Btilde*ts;

x0 = [0 0 10]';

S = [1 0 0; 0 1 0; 0 0 1];
Q = [1 0 0; 0 1 0; 0 0 1];
R = 100;

P(:,:,N) = S;
x(:,:,1) = x0; % state of the optimal control problem
xa(:,:,1) = x0; % state of the automous system
x_lqr(:,:,1) = x0; % state of the steady state optimal control problem

%% optimal control problem
u(:,N) = 0;
for n = 1:N-1
    K(:,:,N-n) = (R+B'*P(:,:,N-n+1)*B)\(B'*P(:,:,N-n+1)*A);
    P(:,:,N-n) = A'*P(:,:,N-n+1)*(A-B*K(:,:,N-n))+Q;
end
for n = 1:N-1
    u(:,n) = -K(:,:,n)*x(:,:,n);
    x(:,:,n+1) = A*x(:,:,n)+B*u(:,n);
end

%% steady state optimal control problem
[Klqr] = dlqr(A,B,Q,R);

u_lqr(:,N) = 0;

for n = 1:N-1
    u_lqr(:,n) = -Klqr*x_lqr(:,:,n);
    x_lqr(:,:,n+1) = A*x_lqr(:,:,n)+B*u_lqr(:,n);
end

%% autonomous case (u=0)
for n = 1:N-1
    xa(:,:,n+1) = A*xa(:,:,n);
end

%% ploting results
for n = 1:N-1
    K1(n) = K(1,1,n);
end
for n = 1:N-1
    K2(n) = K(1,2,n);
end
for n = 1:N-1
    K3(n) = K(1,3,n);
end


figure;
plot(t,x(1,:),'--k','LineWidth',2);
hold on
plot(t,x_lqr(1,:),'-k','LineWidth',0.75);
hold on
plot(t,xa(1,:),'-k','LineWidth',2);
hold off
title('Comparison between optimal state feedback and free evolution','Interpreter','latex');
legend('$\omega_1(k)$','$\omega_1^0(k)$','$\omega_1^a(k)$','Interpreter','latex','fontsize', 20); 
grid on

figure; 
plot(t(1:N-1),K1,'-k','LineWidth',2);
hold on
plot(t(1:N-1),K2,'-k','LineWidth',1);
hold on
plot(t(1:N-1),K3,'--k','LineWidth',2);
hold off
title('Evolution of the optimal state feedback','Interpreter','latex');
legend('$k_1(k)$','$k_2(k)$','$k_3(k)$','Interpreter','latex','Location','northwest','fontsize', 14); 
set(gca,'xlim',[t(1) t(end)]);
% set(gca,'ylim',[-1 4]);
xlabel('t/s','Interpreter','latex');
ylabel('','Interpreter','latex');
grid on;











































































































