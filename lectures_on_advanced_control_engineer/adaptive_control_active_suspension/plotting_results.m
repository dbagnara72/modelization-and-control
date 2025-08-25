close all
clc


% figure(1); 
% plot(t,xp_sim,'--k','LineWidth',1.8);
% hold on
% plot(t,street_bump_data(:,1),'--k','LineWidth',1);
% hold on
% plot(t,xm_sim,'-k','LineWidth',1.8);
% hold off
% title('Dynamic during street bump','Interpreter','latex');
% legend('$x_p(t)$','$w(t)$','$x_m(t)$','Interpreter','latex','Location','northeast');
% set(gca,'ylim',[-0.25, 1.5])
% % set(gca,'xlim',[t(1),t(end)]);
% xlabel('t/s','Interpreter','latex');
% % ylabel({'$$'},'Interpreter','latex','Rotation',0);
% grid on

figure(2); 
plot(t,zp_sim,'--k','LineWidth',1.8);
hold on
plot(t,xp_sim,'-k','LineWidth',1);
hold on
plot(t,street_bump_data(:,1),'--k','LineWidth',1);
hold on
plot(t,zm_sim,'-k','LineWidth',1.8);
hold off
title('Dynamic during street bump - without adaptive control','Interpreter','latex');
legend('$z_p(t)$','$x_p(t)$','$w(t)$','$z_m(t)$','Interpreter','latex','Location','northeast');
set(gca,'ylim',[-0.25, 1.5])
% set(gca,'xlim',[t(1),t(end)]);
xlabel('t/s','Interpreter','latex');
% ylabel({'$$'},'Interpreter','latex','Rotation',0);
grid on
print -deps2 track4

return
figure(3); 
plot(t,u_sim,'-k','LineWidth',1.8);
title('Dynamic during street bump','Interpreter','latex');
legend('$u(t)$','Interpreter','latex','Location','northeast');
set(gca,'ylim',[-4.5, 7])
% set(gca,'xlim',[t(1),t(end)]);
xlabel('t/s','Interpreter','latex');
% ylabel({'$$'},'Interpreter','latex','Rotation',0);
grid on
print -deps2 track3
