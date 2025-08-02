
clear all
close all
clc


Ts = 1e-3;
N = 2e3;
z = tf('z',Ts);
t=[0:Ts:(N-1)*Ts];

options = bodeoptions;
options.FreqUnits = 'Hz';

J1 = 0.025;
J2 = 0.025;
b = 0.02;
b_theta = b;
k_theta = 1;

A = [-(b+b_theta)/J1 b_theta/J1 -1/J1; ...
    b_theta/J2 -(b+b_theta)/J2 1/J2;...
    k_theta -k_theta 0];
B = [1/J1 0 0]';
C = [1 0 0];

Ad = eye(3)+A*Ts;
Bd = B*Ts;

x_0 = [0 0 -2]';

S = [1 0 0; 0 1 0; 0 0 1];
Q = [1 0 0; 0 1 0; 0 0 1];
R = 1e-3;

P(:,:,N) = S;
x(:,:,1) = x_0;

xa(:,:,1) = x_0;
x_lqr(:,:,1) = x_0;

[Klqr] = lqr(A,B,Q,R)
% [Klqr] = dlqr(Ad,Bd,Q,R)


% Optimal control problem
for n = 1:N-1
    K(:,:,N-n) = (R + Bd'*P(:,:,N-n+1)*Bd)\(Bd'*P(:,:,N-n+1)*Ad);
    P(:,:,N-n) = Ad'*P(:,:,N-n+1)*(Ad-Bd*K(:,:,N-n))+Q;
end
for n = 1:N-1
    u(:,n) = -K(:,:,n)*x(:,:,n);
    x(:,:,n+1) = Ad*x(:,:,n)+Bd*u(:,n);
end





% steady state optimal control problem
for n = 1:N-1
    u_lqr(:,n) = -Klqr*x_lqr(:,:,n);
    x_lqr(:,:,n+1) = Ad*x_lqr(:,:,n)+Bd*u_lqr(:,n);
end

% autonomous system
for n = 1:N-1
    xa(:,:,n+1) = Ad*xa(:,:,n);
end


for C = 1:N-1
    K1(C) = K(1,1,C);
end
for C = 1:N-1
    K2(C) = K(1,2,C);
end
for C = 1:N-1
    K3(C) = K(1,3,C);
end

u(:,N) = 0;
% t=[0:Ts:(N-1)*Ts];

% figure
% subplot 311
% plot(t,xa(1,:),t,x(1,:));
% grid on
% subplot 312
% plot(t,xa(2,:),t,x(2,:));
% grid on
% subplot 313
% plot(t,xa(3,:),t,x(3,:));
% grid on

figure(1); 
plot(t,x(1,:),'--k','LineWidth',2);
hold on
plot(t,x_lqr(1,:),'-k','LineWidth',0.75);
hold on
plot(t,xa(1,:),'-k','LineWidth',2);
hold off
title('Comparison between optimal state feedback and free evolution','Interpreter','latex');
legend('$\omega_1(k)$','$\omega_1^0(k)$','$\omega_1^a(k)$','Interpreter','latex'); 
set(gca,'xlim',[t(1) t(end)]);
% set(gca,'ylim',[-1 1]);
xlabel('t/s','Interpreter','latex');
ylabel('','Interpreter','latex');
grid on;
% grid minor;
% ax = gca;
% ax.GridLineStyle = '-';
% ax.MinorGridLineStyle = '--';
% ax.GridAlpha = 0.6;
% ax.MinorGridAlpha = 0.2;
% ax.XScale = 'linear';
% ax.YScale = 'linear';
print -deps2 state12
figure(2); 
plot(t,x(2,:),'--k','LineWidth',2);
hold on
plot(t,x_lqr(2,:),'-k','LineWidth',0.75);
hold on
plot(t,xa(2,:),'-k','LineWidth',2);
hold off
title('Comparison between optimal state feedback and free evolution','Interpreter','latex');
legend('$\omega_2(k)$','$\omega_2^0(k)$','$\omega_2^a(k)$','Interpreter','latex'); 
set(gca,'xlim',[t(1) t(end)]);
% set(gca,'ylim',[-1 1]);
xlabel('t/s','Interpreter','latex');
ylabel('','Interpreter','latex');
grid on;
% grid minor;
% ax = gca;
% ax.GridLineStyle = '-';
% ax.MinorGridLineStyle = '--';
% ax.GridAlpha = 0.6;
% ax.MinorGridAlpha = 0.2;
% ax.XScale = 'linear';
% ax.YScale = 'linear';
print -deps2 state22
figure(3); 
plot(t,x(3,:),'--k','LineWidth',2);
hold on
plot(t,x_lqr(3,:),'-k','LineWidth',0.75);
hold on
plot(t,xa(3,:),'-k','LineWidth',2);
hold off
title('Comparison between optimal state feedback and free evolution','Interpreter','latex');
legend('$\tau_{\theta}(k)$','$\tau_{\theta}^0(k)$','$\tau_{\theta}^a(k)$','Interpreter','latex'); 
set(gca,'xlim',[t(1) t(end)]);
% set(gca,'ylim',[-1 1]);
xlabel('t/s','Interpreter','latex');
ylabel('','Interpreter','latex');
grid on;
% grid minor;
% ax = gca;
% ax.GridLineStyle = '-';
% ax.MinorGridLineStyle = '--';
% ax.GridAlpha = 0.6;
% ax.MinorGridAlpha = 0.2;
% ax.XScale = 'linear';
% ax.YScale = 'linear';
print -deps2 state32

figure(4); 
plot(t(1:N-1),K1,'-k','LineWidth',2);
hold on
plot(t(1:N-1),K2,'-k','LineWidth',1);
hold on
plot(t(1:N-1),K3,'--k','LineWidth',2);
hold off
title('Evolution of the optimal state feedback','Interpreter','latex');
legend('$k_1(k)$','$k_2(k)$','$k_3(k)$','Interpreter','latex','Location','northwest'); 
set(gca,'xlim',[t(1) t(end)]);
% set(gca,'ylim',[-1 4]);
xlabel('t/s','Interpreter','latex');
ylabel('','Interpreter','latex');
grid on;
% grid minor;
% ax = gca;
% ax.GridLineStyle = '-';
% ax.MinorGridLineStyle = '--';
% ax.GridAlpha = 0.6;
% ax.MinorGridAlpha = 0.2;
% ax.XScale = 'linear';
% ax.YScale = 'linear';
print -deps2 feedback_m2

figure(5); 
plot(t,u,'-k','LineWidth',2);
title('Control input $u(k)$','Interpreter','latex');
legend('$u(k)$','Interpreter','latex'); 
set(gca,'xlim',[t(1) t(end)]);
% set(gca,'ylim',[-1 4]);
xlabel('t/s','Interpreter','latex');
ylabel('','Interpreter','latex');
grid on;
% grid minor;
% ax = gca;
% ax.GridLineStyle = '-';
% ax.MinorGridLineStyle = '--';
% ax.GridAlpha = 0.6;
% ax.MinorGridAlpha = 0.2;
% ax.XScale = 'linear';
% ax.YScale = 'linear';
print -deps2 control_input2

return

figure
plot(t(1:N-1),K1,t(1:N-1),K2,t(1:N-1),K3);
grid on

figure
plot(t,u);
grid on

% k1=K(1,1,1)
% k2=K(1,2,1)
% k3=K(1,3,1)
% 
% 
% % N=10e3;
% % t=[0:Ts:(N-1)*Ts];
% for n = 1:N-1
%     u(:,n) = -[k1,k2,k3]*x(:,:,n);
%     x(:,:,n+1) = Ad*x(:,:,n)+Bd*u(:,n);
% end
% 
% 
% figure
% subplot 311
% plot(t,x(1,:));
% grid on
% subplot 312
% plot(t,x(2,:));
% grid on
% subplot 313
% plot(t,x(3,:));
% grid on
% 
% 
% 
% 

























