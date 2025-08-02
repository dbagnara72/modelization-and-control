close all
clc

figure; 
subplot 211
plot(t,sim_xv,'k-','LineWidth',1.8);
hold on
plot(t,sim_load.*1e-8,'-','LineWidth',1.8,'Color',[0.5 0.5 0.5]);
hold off
ylabel('$x_v/[mm]$, $\tau_{load}/100MN$','Interpreter','latex','Rotation',90);
legend('$x_v$','$\tau_{load}$','Interpreter','latex','Location','best');
set(gca,'xlim',[t(1) t(end)]); 
title('\textbf{Position Control - Fast Ramp at 200s}','Interpreter','latex')
grid on
subplot 212
plot(t,sim_xp_ref,'k-','LineWidth',1.88);
hold on
plot(t,sim_xp,'-','LineWidth',1.8,'Color',[0.5 0.5 0.5]);
hold off
ylabel('$x_p/[m]$','Interpreter','latex','Rotation',90);
hold off
legend('$x_p^{ref}$','$x_p$','Interpreter','latex','Location','best');
set(gca,'xlim',[t(1) t(end)]); 
xlabel('$time\,[s]$','Interpreter','latex')
title('\textbf{Position Control - Fast Ramp at 200s}','Interpreter','latex')
grid on
print -depsc test_response
