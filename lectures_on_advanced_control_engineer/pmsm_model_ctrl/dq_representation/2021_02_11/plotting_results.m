close all
clear all
clc

load sim_result_1.mat

figure;
subplot 211
plot(omega_m,tau_m,'k-','LineWidth',1.8);
xlabel('$\omega_m/rpm$','Interpreter','latex')
ylabel('$\tau_m/Nm$','Interpreter','latex')
title('\textbf{Motor Speed-Torque limit curve}','Interpreter','latex')
legend('$\tau_m$','Interpreter','latex','Location','best');
set(gca,'xlim',[0 omega_m(end)]); 
set(gca,'ylim',[0 max(tau_m)*1.05]); 
grid on
subplot 212
plot(omega_m,delta_p,'k-','LineWidth',1.8);
xlabel('$\omega_m/rpm$','Interpreter','latex')
ylabel('$\Delta p/bar$','Interpreter','latex')
title('\textbf{Drivetrain Speed-Delta Pressure limit curve}','Interpreter','latex')
legend('$\Delta p$','Interpreter','latex','Location','best');
set(gca,'xlim',[0 omega_m(end)]); 
set(gca,'ylim',[0 max(delta_p)*1.05]); 
grid on
print -deps limit_curves
