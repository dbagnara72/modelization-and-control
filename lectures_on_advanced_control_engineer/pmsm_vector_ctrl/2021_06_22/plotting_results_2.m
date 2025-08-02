close all
clc


figure(1); 
plot(t,psi_alpha,'--k','LineWidth',1.8);
hold on
plot(t,psi_alpha_hat,'-k','LineWidth',1.8);
hold on
plot(t,psi_beta,'--k','LineWidth',1);
hold on
plot(t,psi_beta_hat,'-k','LineWidth',1);
hold off
title('Kalman Observer Estimator','Interpreter','latex');
legend('$\psi_{\alpha}$','$\hat{\psi}_{\alpha}$','$\psi_{\beta}$','$\hat{\psi}_{\beta}$','Interpreter','latex','Location','northwest');
set(gca,'ylim',[-1.25, 1.25])
set(gca,'xlim',[t(1),t(end)]);
xlabel('t/s','Interpreter','latex');
ylabel({'$Vs$'},'Interpreter','latex','Rotation',0);
grid on
% print -deps2 observer

figure(2); 
plot(t,psi_alpha,'--k','LineWidth',1.8);
hold on
plot(t,psi_alpha_hat,'-k','LineWidth',1.8);
hold off
title('Kalman Observer Estimator','Interpreter','latex');
legend('$\psi_{\alpha}$','$\hat{\psi}_{\alpha}$','Interpreter','latex','Location','northwest');
set(gca,'ylim',[0.9, 1.05])
set(gca,'xlim',[0.135 0.15]);
xlabel('t/s','Interpreter','latex');
ylabel({'$Vs$'},'Interpreter','latex','Rotation',0);
grid on
% print -deps2 observer_zoomed


figure(3); 
plot(t,i_alpha,'--k','LineWidth',1.8);
hold on
plot(t,i_alpha_hat,'-k','LineWidth',1.8);
hold on
plot(t,i_beta,'--k','LineWidth',1);
hold on
plot(t,i_beta_hat,'-k','LineWidth',1);
hold off
title('Kalman Observer Estimator','Interpreter','latex');
legend('$i_{\alpha}$','$\hat{i}_{\alpha}$','$i_{\beta}$','$\hat{i}_{\beta}$','Interpreter','latex','Location','northwest');
set(gca,'ylim',[-125, 125])
set(gca,'xlim',[t(1),t(end)]);
xlabel('t/s','Interpreter','latex');
ylabel({'$A$'},'Interpreter','latex','Rotation',0);
grid on
% print -deps2 observerI

figure(4); 
plot(t,i_alpha,'--k','LineWidth',1.8);
hold on
plot(t,i_alpha_hat,'-k','LineWidth',1.8);
hold off
title('Kalman Observer Estimator','Interpreter','latex');
legend('$i_{\alpha}$','$\hat{i}_{\alpha}$','Interpreter','latex','Location','northwest');
set(gca,'ylim',[75, 120])
set(gca,'xlim',[0.118 0.13]);
xlabel('t/s','Interpreter','latex');
ylabel({'$A$'},'Interpreter','latex','Rotation',0);
grid on
% print -deps2 observerIzoomed

return
figure(2); 
subplot 211
plot(t,w1,'-k','LineWidth',1.8);
hold on
plot(t,w1_hat(:,1),'--k','LineWidth',1.8);
hold off
title('Observer performance','Interpreter','latex');
legend('$\omega_1$','$\hat{\omega}_1$','Interpreter','latex','Location','northwest');
set(gca,'xlim',[t(1),t(end)]);
set(gca,'ylim',[-0.1, 1.75])
xlabel('t/s','Interpreter','latex');
ylabel('$\omega/rad/s$','Interpreter','latex','Rotation',90);
grid on
subplot 212
plot(t,w2,'-k','LineWidth',1);
hold on
plot(t,x_hat(:,2),'--k','LineWidth',1);
hold off
title('Observer performance','Interpreter','latex');
legend('$\omega_2$','$\hat{\omega}_2$','Interpreter','latex','Location','northwest');
set(gca,'xlim',[t(1),t(end)]);
set(gca,'ylim',[-0.1, 1.1])
xlabel('t/s','Interpreter','latex');
ylabel('$\omega/rad/s$','Interpreter','latex','Rotation',90);
grid on
% print -deps2 observer_2

figure(3); 
plot(t,tau_2,'--k','LineWidth',1.8);
hold on
plot(t,x_hat(:,4),'-k','LineWidth',1.8);
hold off
title('Observer performance','Interpreter','latex');
legend('$\tau_2$','$\hat{\tau}_2$','Interpreter','latex','Location','northwest');
set(gca,'xlim',[t(1),t(end)]);
set(gca,'ylim',[-0.1, 0.5])
xlabel('t/s','Interpreter','latex');
ylabel('$\tau/Nm$','Interpreter','latex','Rotation',90);
grid on
% print -deps2 load_obs_1