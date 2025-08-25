close all
clc
% 
% 
% figure(1); 
% plot(t,i1,'-k','LineWidth',1.8);
% hold on
% plot(t,i1_ref,'--k','LineWidth',1.8);
% hold off
% title('Tracking performance with disturbance compensation','Interpreter','latex');
% legend('$i_1$','$i_1^{ref}$','Interpreter','latex','Location','northwest');
% set(gca,'ylim',[-1.5, 1.5])
% set(gca,'xlim',[t(1),t(end)]);
% xlabel('t/s','Interpreter','latex');
% ylabel({'$i/A$'},'Interpreter','latex','Rotation',0);
% grid on
% print -deps2 tracks
% figure(2); 
% plot(t,dt,'--k','LineWidth',1);
% hold on
% plot(t,dt_hat,'-k','LineWidth',1);
% hold off
% title('Observer performance','Interpreter','latex');
% legend('$d(t)$','$\hat{d}(t)$','Interpreter','latex','Location','northwest');
% set(gca,'ylim',[-0.5, 0.5])
% set(gca,'xlim',[t(1),t(end)]);
% xlabel('t/s','Interpreter','latex');
% ylabel({'u/V'},'Interpreter','latex','Rotation',0);
% grid on
% print -deps2 observer
figure(1); 
plot(t,i1,'-k','LineWidth',1.8);
hold on
plot(t,i1_ref,'--k','LineWidth',1.8);
hold on
plot(t,dt,'-k','LineWidth',1);
hold off
title('Tracking performance without disturbance compensation','Interpreter','latex');
legend('$i_1$','$i_1^{ref}$','$d(t)$','Interpreter','latex','Location','northwest');
set(gca,'ylim',[-1.5, 1.5])
set(gca,'xlim',[t(1),t(end)]);
xlabel('t/s','Interpreter','latex');
ylabel({'$i/A$'},'Interpreter','latex','Rotation',0);
grid on
print -deps2 tracks_nocomp

