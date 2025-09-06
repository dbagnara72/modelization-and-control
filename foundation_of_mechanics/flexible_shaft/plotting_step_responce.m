close all
clc

tratto1=2.2;
tratto2=2.2;
tratto3=1;
colore1 = [0.25 0.25 0.25];
colore2 = [0.5 0.5 0.5];
colore3 = [0.75 0.75 0.75];
t1c = time_tc_msmsm_sim(end) - Nc*Tc;
t2c = time_tc_msmsm_sim(end) - Nc*Tc/2;

fontsize_plotting = 14;

figure;
subplot 211
plot(time_tc_msmsm_sim,omega_1_msmsm_sim,'-','LineWidth',tratto1,'Color',colore1);
hold on
plot(time_tc_msmsm_sim,omega_2_msmsm_sim,'-','LineWidth',tratto1,'Color',colore2);
hold on
plot(time_tc_msmsm_sim,omega_3_msmsm_sim,'-','LineWidth',tratto1,'Color',colore3);
hold off
title('System pulse response - inner speeds','Interpreter','latex','FontSize',fontsize_plotting);
legend('$\omega_1$','$\omega_2$','$\omega_3$','Location','best',...
    'Interpreter','latex','FontSize',fontsize_plotting);
xlabel('$t/s$','Interpreter','latex','FontSize', fontsize_plotting);
ylabel('$p.u.$','Interpreter','latex','FontSize', fontsize_plotting);
set(gca,'ylim',[-0.25 0.75]);
set(gca,'xlim',[t1c t2c]);
grid on
subplot 212
plot(time_tc_msmsm_sim,tau_theta_12_msmsm_sim,'-','LineWidth',tratto1,'Color',colore1);
hold on
plot(time_tc_msmsm_sim,tau_theta_23_msmsm_sim,'-','LineWidth',tratto1,'Color',colore2);
hold off
title('System pulse response - inner torques','Interpreter','latex','FontSize',fontsize_plotting);
legend('$\tau_12$','$\tau_23$','Location','best',...
    'Interpreter','latex','FontSize',fontsize_plotting);
xlabel('$t/s$','Interpreter','latex','FontSize', fontsize_plotting);
ylabel('$p.u.$','Interpreter','latex','FontSize', fontsize_plotting);
set(gca,'ylim',[-1.5 2.25]);
set(gca,'xlim',[t1c t2c]);
grid on
print('plant_msmsm_pulse_responce','-depsc');

