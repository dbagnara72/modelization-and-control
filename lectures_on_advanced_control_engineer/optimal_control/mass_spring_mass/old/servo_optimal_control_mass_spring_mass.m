clear all
close all
clc

ts = 1e-3;
N = 5e3;
z = tf('z',ts);
t=[0:ts:(N-1)*ts];

options = bodeoptions;
options.FreqUnits = 'Hz';

J1 = 0.025;
J2 = 0.025;
b = 0.002;
b_theta = b;
k_theta = 1;

A = [-(b+b_theta)/J1 b_theta/J1 -1/J1; b_theta/J2 -(b+b_theta)/J2 1/J2;...
    k_theta -k_theta 0];
B = [1/J1 0 0]';
C = [1 0 0];
% detA = det(A)
% rank(A)
% rank([A,B])
% rank(obsv(A,C))
% rank(ctrb(A,B))

% Ad = eye(3)+A*ts+A^2*ts^2/2+A^3*ts^3/6;
% Bd = B*ts + A*B*ts^2/2 + A^2*B*ts^3/6;

Ad = eye(3)+A*ts;
Bd = B*ts;

x_0 = [0 0 0]';
v_0 = 0;
Ae = [1 -C*Ad; zeros(3,1) Ad];
Be = [-C*Bd; Bd];

r = 5;
Se = r*[1 0 0 0; 0 0 0 0; 0 0 0 0; 0 0 0 0];
Qe = [1e-3 0 0 0; 0 1 0 0; 0 0 1e2 0; 0 0 0 0];
R = 1;
Pe(:,:,N) = Se;
x(:,:,1) = x_0;
v(:,:,1) = v_0;
z = [v(:,:,1); x(:,:,1)];

for n = 1:N-1
    Ke(:,:,N-n) = (R + Be'*Pe(:,:,N-n+1)*Be)\(Be'*Pe(:,:,N-n+1)*Ae);
    Pe(:,:,N-n) = Ae'*Pe(:,:,N-n+1)*(Ae-Be*Ke(:,:,N-n))+Qe;
end

ki=Ke(1,1,1)
k1=Ke(1,2,1)
k2=Ke(1,3,1)
k3=Ke(1,4,1)

for n = 1:N-1
    Ke1(n) = Ke(1,1,n);
end
for n = 1:N-1
    Ke2(n) = Ke(1,2,n);
end
for n = 1:N-1
    Ke3(n) = Ke(1,3,n);
end
for n = 1:N-1
    Ke4(n) = Ke(1,4,n);
end

figure(2); 
plot(t(1:N-1),Ke1,'-k','LineWidth',2);
hold on
plot(t(1:N-1),Ke3,'-k','LineWidth',1);
hold on
plot(t(1:N-1),Ke4,'--k','LineWidth',2);
hold off
title('$L_x$ gain for LQI control of a mass-spring-mass','Interpreter','latex');
legend('$k_{x1}(k)$','$k_{x2}(k)$','$k_{x3}(k)$','Interpreter','latex','Location','northwest'); 
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
print -deps2 Kservo


% N=2e3;
% t=[0:ts:(N-1)*ts];

for n = 1:N-1
    u(:,n) = -[ki,k1,k2,k3]*z(:,:,n);
    z(:,:,n+1) = Ae*z(:,:,n)+Be*u(:,n)+[1;zeros(3,1)]*r;
end

u(:,N) = 0;

figure(1); 
plot(t,z(2,:),'-k','LineWidth',2);
hold on
plot(t,z(3,:),'--k','LineWidth',2);
hold on
plot(t,z(4,:),'-k','LineWidth',0.75);
hold off
title('LQI control of a mass-spring-mass','Interpreter','latex');
legend('$\omega_1(k)$','$\omega_2(k)$','$\tau_{\theta}(k)$','Interpreter','latex'); 
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
print -deps2 state_servo


figure(3); 
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
print -deps2 u_servo


























