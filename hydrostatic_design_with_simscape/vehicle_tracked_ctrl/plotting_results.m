close all
clear all
clc

load sim_result_3.mat

figure;
subplot 211
plot(time,qA_sim,'k-','LineWidth',1.8);
hold on
plot(time,qB_sim,'-','LineWidth',1.8,'Color',[0.5 0.5 0.5]);
hold off
ylabel('$q - [l/min]$','Interpreter','latex')
title('\textbf{Hydraulic quantities - flow rate}','Interpreter','latex')
legend('$q_A$','$q_B$','Interpreter','latex','Location','best');
set(gca,'xlim',[time(1) time(end)]); 
% set(gca,'ylim',[0 300]); 
grid on
subplot 212
plot(time,dpA_sim,'k-','LineWidth',1.8);
hold
plot(time,dpB_sim,'-','LineWidth',1.8,'Color',[0.5 0.5 0.5]);
xlabel('$time - [s]$','Interpreter','latex')
ylabel('$\Delta p - [bar]$','Interpreter','latex')
title('\textbf{Hydraulic quantities - delta pressure}','Interpreter','latex')
legend('$\Delta p_A$','$\Delta p_B$','Interpreter','latex','Location','best');
set(gca,'xlim',[time(1) time(end)]); 
% set(gca,'ylim',[0 450]); 
grid on
print -deps hydro_data_1


figure;
subplot 211
plot(time,engine_torque_sim,'-','LineWidth',1.8,'Color',[0.5 0.5 0.5]);
hold on 
plot(time,engine_torque_limit_sim,'k-','LineWidth',1.8);
hold off
ylabel('$\tau_e - [Nm]$','Interpreter','latex')
title('\textbf{Engine quantities - torque and torque limit}','Interpreter','latex')
legend('$\tau_e$','$\tau_e^{lim}$','Interpreter','latex','Location','best');
set(gca,'xlim',[time(1) time(end)]); 
% set(gca,'ylim',[0 1500]); 
grid on
subplot 212
plot(time,engine_speed_sim,'k-','LineWidth',1.8);
ylabel('$\omega_e - [rpm]$','Interpreter','latex')
title('\textbf{Engine quantities - rotor speed}','Interpreter','latex')
legend('$\omega_e$','Interpreter','latex','Location','best');
set(gca,'xlim',[time(1) time(end)]); 
% set(gca,'ylim',[0 2050]); 
grid on
print -deps engine_data_1

figure;
subplot 211
plot(time,v_track1_ref_sim,'-','LineWidth',1.8,'Color',[0.5 0.5 0.5]);
hold on 
plot(time,v_track1_sim,'k-','LineWidth',1.8);
hold off
ylabel('$v_1^{track} - [m/s]$','Interpreter','latex')
title('\textbf{Track quantities - speed reference and speed track}','Interpreter','latex')
legend('$v_1^{ref}$','$v_1^{track}$','Interpreter','latex','Location','best');
set(gca,'xlim',[time(1) time(end)]); 
% set(gca,'ylim',[0 12]); 
grid on
subplot 212
plot(time,v_track2_ref_sim,'-','LineWidth',1.8,'Color',[0.5 0.5 0.5]);
hold on 
plot(time,v_track2_sim,'k-','LineWidth',1.8);
hold off
ylabel('$v_2^{track} - [m/s]$','Interpreter','latex')
title('\textbf{Track quantities - speed reference and speed track}','Interpreter','latex')
legend('$v_2^{ref}$','$v_2^{track}$','Interpreter','latex','Location','best');
set(gca,'xlim',[time(1) time(end)]); 
% set(gca,'ylim',[0 12]); 
grid on
print -deps track_data_1

figure;
plot(time,v_track1_sim,'-','LineWidth',1.8,'Color',[0.5 0.5 0.5]);
hold on 
plot(time,v_track2_sim,'k-','LineWidth',1.8);
hold off
ylabel('$v^{track} - [m/s]$','Interpreter','latex')
title('\textbf{Track quantities - speed synchronization and limiter}','Interpreter','latex')
legend('$v_1^{track}$','$v_2^{track}$','Interpreter','latex','Location','best');
set(gca,'xlim',[time(1) time(end)]); 
% set(gca,'ylim',[0 12]); 
grid on
print -deps track_data_2









































