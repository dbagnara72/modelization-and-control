close all
clear all
clc

load sim_result_1.mat

figure;
subplot 211
plot(t,ibattery,'k-','LineWidth',1.8);
xlabel('$t/s$','Interpreter','latex')
ylabel('$i_{battery}/A$','Interpreter','latex')
title('\textbf{Battery Current During Overspeed and Inverter Fault}','Interpreter','latex')
legend('$i_{battery}$','Interpreter','latex','Location','best');
set(gca,'xlim',[t(1) t(end)]); 
set(gca,'ylim',[min(ibattery)*1.05 0]); 
grid on
subplot 212
plot(t,vbattery,'k-','LineWidth',1.8);
xlabel('$t/s$','Interpreter','latex')
ylabel('$v_{battery}/A$','Interpreter','latex')
title('\textbf{Battery Voltage During Overspeed and Inverter Fault }','Interpreter','latex')
legend('$v_{battery}$','Interpreter','latex','Location','best');
set(gca,'xlim',[t(1) t(end)]); 
set(gca,'ylim',[max(vbattery)*0.95 max(vbattery)*1.05]); 
grid on
% print -djpeg vi_battery_fault
print -depsc vi_battery_fault

return

figure;
subplot 211
plot(t,omega_m,'k-','LineWidth',1.8);
xlabel('$t/s$','Interpreter','latex')
ylabel('$\omega_m/rpm$','Interpreter','latex')
title('\textbf{Motor Speed During Overspeed and Inverter Fault}','Interpreter','latex')
legend('$\omega_m$','Interpreter','latex','Location','best');
set(gca,'xlim',[t(1) t(end)]); 
set(gca,'ylim',[0 max(omega_m)*1.05]); 
grid on
subplot 212
plot(t,tau_e,'k-','LineWidth',1.8);
xlabel('$t/s$','Interpreter','latex')
ylabel('$\tau_m/Nm$','Interpreter','latex')
title('\textbf{Motor Torque During Overspeed and Inverter Fault}','Interpreter','latex')
legend('$\tau_m$','Interpreter','latex','Location','best');
set(gca,'xlim',[t(1) t(end)]); 
set(gca,'ylim',[min(tau_e)*1.05 0]); 
grid on
print -djpeg pmsm_overspeed_fault

eq = phi_d.*omega_m*4/60*2*pi;

figure;
subplot 211
plot(t,ud.*Ubez,'k-','LineWidth',1.8);
hold on
plot(t,eq,'k--','LineWidth',1.8);
hold off
xlabel('$t/s$','Interpreter','latex')
ylabel('$u_d/V$','Interpreter','latex')
title('\textbf{Motor D-Voltage During Overspeed and Inverter Fault}','Interpreter','latex')
legend('$u_d$','$e_q$','Interpreter','latex','Location','best');
set(gca,'xlim',[t(1) t(end)]); 
set(gca,'ylim',[0 max(eq)*1.05]); 
grid on
subplot 212
plot(t,uq.*Ubez,'k-','LineWidth',1.8);
xlabel('$t/s$','Interpreter','latex')
ylabel('$u_q/V$','Interpreter','latex')
title('\textbf{Motor Q-Voltage During Overspeed and Inverter Fault}','Interpreter','latex')
legend('$u_q$','Interpreter','latex','Location','best');
set(gca,'xlim',[t(1) t(end)]); 
set(gca,'ylim',[0 max(uq.*Ubez)*1.05]); 
grid on
print -djpeg pmsm_ud_uq



