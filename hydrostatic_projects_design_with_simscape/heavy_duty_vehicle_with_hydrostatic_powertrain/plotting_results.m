close all
clear all
clc

load load_sim_1.mat

figure;
subplot 211
plot(time,qR_sim,'k-','LineWidth',1.8);
hold on
plot(time,qL_sim,'-','LineWidth',1.8,'Color',[0.5 0.5 0.5]);
hold off
ylabel('$q - [l/min]$','Interpreter','latex')
title('\textbf{Hydraulic quantities - flow rate}','Interpreter','latex')
legend('$q_R$','$q_L$','Interpreter','latex','Location','best');
set(gca,'xlim',[time(1) time(end)]); 
% set(gca,'ylim',[0 300]); 
grid on
subplot 212
plot(time,dpR_sim,'k-','LineWidth',1.8);
hold
plot(time,dpL_sim,'-','LineWidth',1.8,'Color',[0.5 0.5 0.5]);
xlabel('$time - [s]$','Interpreter','latex')
ylabel('$\Delta p - [bar]$','Interpreter','latex')
title('\textbf{Hydraulic quantities - delta pressure}','Interpreter','latex')
legend('$\Delta p_R$','$\Delta p_L$','Interpreter','latex','Location','best');
set(gca,'xlim',[time(1) time(end)]); 
% set(gca,'ylim',[0 450]); 
grid on
print -depsc hydro_data_1


figure;
subplot 211
plot(time,engine_data(:,3),'-','LineWidth',1.8,'Color',[0.5 0.5 0.5]);
hold on 
plot(time,torque_engine_limit,'k-','LineWidth',1.8);
hold off
ylabel('$\tau_e - [Nm]$','Interpreter','latex')
title('\textbf{Engine quantities - torque and torque limit}','Interpreter','latex')
legend('$\tau_e$','$\tau_e^{lim}$','Interpreter','latex','Location','best');
set(gca,'xlim',[time(1) time(end)]); 
% set(gca,'ylim',[0 1500]); 
grid on
subplot 212
plot(time,engine_data(:,2),'k-','LineWidth',1.8);
ylabel('$\omega_e - [rpm]$','Interpreter','latex')
title('\textbf{Engine quantities - rotor speed}','Interpreter','latex')
legend('$\omega_e$','Interpreter','latex','Location','best');
set(gca,'xlim',[time(1) time(end)]); 
% set(gca,'ylim',[0 2050]); 
grid on
print -depsc engine_data_1

figure;
subplot 211
plot(time,v_ref_track_R,'-','LineWidth',1.8,'Color',[0.5 0.5 0.5]);
hold on 
plot(time,v_track_R,'k-','LineWidth',1.8);
hold off
ylabel('$v_R^{track} - [m/s]$','Interpreter','latex')
title('\textbf{Track quantities - speed reference and speed track}','Interpreter','latex')
legend('$v_R^{ref}$','$v_R^{track}$','Interpreter','latex','Location','best');
set(gca,'xlim',[time(1) time(end)]); 
set(gca,'ylim',[-12 12]); 
grid on
subplot 212
plot(time,v_ref_track_L,'-','LineWidth',1.8,'Color',[0.5 0.5 0.5]);
hold on 
plot(time,v_track_L,'k-','LineWidth',1.8);
hold off
ylabel('$v_L^{track} - [m/s]$','Interpreter','latex')
title('\textbf{Track quantities - speed reference and speed track}','Interpreter','latex')
legend('$v_L^{ref}$','$v_L^{track}$','Interpreter','latex','Location','best');
set(gca,'xlim',[time(1) time(end)]); 
set(gca,'ylim',[-12 12]); 
grid on
print -depsc track_data_1

figure;
plot(time,v_track_R,'-','LineWidth',1.8,'Color',[0.5 0.5 0.5]);
hold on 
plot(time,v_track_L,'k-','LineWidth',1.8);
hold off
ylabel('$v^{track} - [m/s]$','Interpreter','latex')
title('\textbf{Track quantities - speed synchronization and limiter}','Interpreter','latex')
legend('$v_R^{track}$','$v_L^{track}$','Interpreter','latex','Location','best');
set(gca,'xlim',[time(1) time(end)]); 
% set(gca,'ylim',[0 12]); 
grid on
print -depsc track_data_2

figure;
subplot 211
plot(time,dmR,'-','LineWidth',1.8,'Color',[0.5 0.5 0.5]);
hold on 
plot(time,dpR,'k-','LineWidth',1.8);
hold off
ylabel('$p.u.$','Interpreter','latex')
title('\textbf{Pump and Motor volumetric displacements in p.u. of the right drive-line}','Interpreter','latex')
legend('$d_m^{R}$','$d_p^{R}$','Interpreter','latex','Location','best');
set(gca,'xlim',[time(1) time(end)]); 
set(gca,'ylim',[-1.1 1.1]); 
grid on
subplot 212
plot(time,dmL,'-','LineWidth',1.8,'Color',[0.5 0.5 0.5]);
hold on 
plot(time,dpL,'k-','LineWidth',1.8);
hold off
ylabel('$p.u.$','Interpreter','latex')
title('\textbf{Pump and Motor volumetric displacements in p.u. of the left drive-line}','Interpreter','latex')
legend('$d_m^{R}$','$d_p^{R}$','Interpreter','latex','Location','best');
set(gca,'xlim',[time(1) time(end)]); 
set(gca,'ylim',[-1.1 1.1]); 
grid on
print -depsc volumetric_displacements








































