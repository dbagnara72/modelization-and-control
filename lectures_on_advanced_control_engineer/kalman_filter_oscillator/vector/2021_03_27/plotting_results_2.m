close all
clc


figure(1); 
subplot 211
plot(t,psi_alpha_sim,'k-','LineWidth',0.75);
hold on
plot(t,psi_alpha_hat_sim,'-','LineWidth',2,'Color',[0.6 0.6 0.6]);
hold off
title('Kalman Observer Estimator - $\psi_\alpha$','Interpreter','latex');
legend('$\psi_{\alpha}$','$\hat{\psi}_{\alpha}$','Interpreter','latex','Location','best');
set(gca,'xlim',[14,24]);
xlabel('t/s','Interpreter','latex');
ylabel({'$Vs$'},'Interpreter','latex','Rotation',90);
grid on
h = get(gca,'Children');
set(gca,'Children',[h(2) h(1)])
subplot 212
plot(t,psi_m_sim,'k-','LineWidth',2);
title('Magnet flux behavior','Interpreter','latex');
legend('$\psi^{M}$','Interpreter','latex','Location','best');
set(gca,'ylim',[0,0.5]);
set(gca,'xlim',[14,24]);
xlabel('t/s','Interpreter','latex');
ylabel({'$Vs$'},'Interpreter','latex','Rotation',90);
grid on
print -deps2 observerPSIa

figure(2); 
subplot 211
plot(t,psi_beta_sim,'k-','LineWidth',0.75);
hold on
plot(t,psi_beta_hat_sim,'-','LineWidth',2,'Color',[0.6 0.6 0.6]);
hold off
title('Kalman Observer Estimator - $\psi_\alpha$','Interpreter','latex');
legend('$\psi_{\beta}$','$\hat{\psi}_{\beta}$','Interpreter','latex','Location','best');
set(gca,'xlim',[14,24]);
xlabel('t/s','Interpreter','latex');
ylabel({'$Vs$'},'Interpreter','latex','Rotation',90);
grid on
h = get(gca,'Children');
set(gca,'Children',[h(2) h(1)])
subplot 212
plot(t,psi_m_sim,'k-','LineWidth',2);
title('Magnet flux behavior','Interpreter','latex');
legend('$\psi^{M}$','Interpreter','latex','Location','best');
set(gca,'ylim',[0,0.5]);
set(gca,'xlim',[14,24]);
xlabel('t/s','Interpreter','latex');
ylabel({'$Vs$'},'Interpreter','latex','Rotation',90);
grid on
print -deps2 observerPSIb

figure(3); 
plot(t,i_alpha_sim,'-k','LineWidth',0.75);
hold on
plot(t,i_alpha_hat_sim,'-k','LineWidth',2,'Color',[0.6 0.6 0.6]);
hold off
title('Kalman Observer Estimator - $i_\alpha$ current','Interpreter','latex');
legend('$i_{\alpha}$','$\hat{i}_{\alpha}$','Interpreter','latex','Location','best');
set(gca,'xlim',[14,24]);
xlabel('t/s','Interpreter','latex');
ylabel({'$A$'},'Interpreter','latex','Rotation',90);
grid on
h = get(gca,'Children');
set(gca,'Children',[h(2) h(1)])
print -deps2 observerIa

tau_nom = psi_m*3/2*p/2*Inom

figure(4); 
plot(t,omega_ref_sim,'-k','LineWidth',0.75);
hold on
plot(t,omega_hat_sim,'-k','LineWidth',2,'Color',[0.6 0.6 0.6]);
hold on 
plot(t,tau_l_sim./tau_nom,'-k','LineWidth',2);
hold off
title('Speed tracking in per unit','Interpreter','latex');
legend('$\omega^{ref}$','$\hat{\omega}$','$\tau^{l}$','Interpreter','latex','Location','best');
set(gca,'xlim',[t(1),t(end)]);
set(gca,'ylim',[-1,1]);
xlabel('t/s','Interpreter','latex');
ylabel({'$p.u.$'},'Interpreter','latex','Rotation',90);
grid on
h = get(gca,'Children');
set(gca,'Children',[h(2) h(1) h(3)])
print -deps2 SpeedTracking


