clear all
close all
clc

load sim_result_1.mat;

figure(1); 
subplot 211
plot(t,x_sim,'-k','LineWidth',1.8);
hold on
plot(t,x_ref_sim,'--k','LineWidth',1.8);
hold off
% title('Cart tracking performance - no load estimation case','Interpreter','latex');
legend('$x$','$x^{ref}$','Interpreter','latex','Location','best');
xlabel('t/s','Interpreter','latex');
ylabel('$x/m$','Interpreter','latex','Rotation',90);
grid on
subplot 212
plot(t,phi_sim,'-k','LineWidth',1.8);
% title('Inverted pendulum tracking performance - no load estimation case','Interpreter','latex');
legend('$\vartheta$','Interpreter','latex','Location','best');
xlabel('t/s','Interpreter','latex');
ylabel('$\vartheta/rad$','Interpreter','latex','Rotation',90);
grid on
print -deps2 invpenoncart_sim_results_1

figure(2); 
subplot 211
plot(t,xstate_sim(:,1),'-k','LineWidth',2);
hold on
plot(t,xstate_sim(:,2),'-k','LineWidth',1);
hold on
plot(t,xstate_sim(:,3),'--k','LineWidth',2);
hold on
plot(t,xstate_sim(:,4),'--k','LineWidth',1);
hold off
% title('State vector - no load estimation case','Interpreter','latex');
legend('$x_1$','$x_2$','$x_3$','$x_4$','Interpreter','latex','Location','best');
xlabel('t/s','Interpreter','latex');
ylabel('$\vec{x}$','Interpreter','latex','Rotation',90);
grid on
subplot 212
plot(t,xstate_hat_sim(:,1),'-k','LineWidth',2);
hold on
plot(t,xstate_hat_sim(:,2),'-k','LineWidth',1);
hold on
plot(t,xstate_hat_sim(:,3),'--k','LineWidth',2);
hold on
plot(t,xstate_hat_sim(:,4),'--k','LineWidth',1);
hold off
% title('Estimated state vector - no load estimation case','Interpreter','latex');
legend('$\hat{x}_1$','$\hat{x}_2$','$\hat{x}_3$','$\hat{x}_4$','Interpreter',...
    'latex','Location','best');
xlabel('t/s','Interpreter','latex');
ylabel('$\hat{\vec{x}}$','Interpreter','latex','Rotation',90);
grid on
print -deps2 invpenoncart_sim_results_2

figure(3); 
subplot 211
plot(t,x_le_sim,'-k','LineWidth',1.8);
hold on
plot(t,x_ref_le_sim,'--k','LineWidth',1.8);
hold off
% title('Cart tracking performance - load estimation case','Interpreter','latex');
legend('$x$','$x^{ref}$','Interpreter','latex','Location','best');
xlabel('t/s','Interpreter','latex');
ylabel('$x/m$','Interpreter','latex','Rotation',90);
grid on
subplot 212
plot(t,phi_le_sim,'-k','LineWidth',1.8);
% title('Inverted pendulum tracking performance - load estimation case','Interpreter','latex');
legend('$\vartheta$','Interpreter','latex','Location','best');
xlabel('t/s','Interpreter','latex');
ylabel('$\vartheta/rad$','Interpreter','latex','Rotation',90);
grid on
print -deps2 invpenoncart_sim_results_3

figure(4); 
subplot 211
plot(t,xstate_le_sim(:,1),'-k','LineWidth',2);
hold on
plot(t,xstate_le_sim(:,2),'-k','LineWidth',1);
hold on
plot(t,xstate_le_sim(:,3),'--k','LineWidth',2);
hold on
plot(t,xstate_le_sim(:,4),'--k','LineWidth',1);
hold off
% title('State vector - load estimation case','Interpreter','latex');
legend('$x_1$','$x_2$','$x_3$','$x_4$','Interpreter','latex','Location','best');
xlabel('t/s','Interpreter','latex');
ylabel('$\vec{x}$','Interpreter','latex','Rotation',90);
grid on
subplot 212
plot(t,xstate_hat_le_sim(:,1),'-k','LineWidth',2);
hold on
plot(t,xstate_hat_le_sim(:,2),'-k','LineWidth',1);
hold on
plot(t,xstate_hat_le_sim(:,3),'--k','LineWidth',2);
hold on
plot(t,xstate_hat_le_sim(:,4),'--k','LineWidth',1);
hold off
% title('Estimated state vector - load estimation case','Interpreter','latex');
legend('$\hat{x}_1$','$\hat{x}_2$','$\hat{x}_3$','$\hat{x}_4$','Interpreter',...
    'latex','Location','best');
xlabel('t/s','Interpreter','latex');
ylabel('$\hat{\vec{x}}$','Interpreter','latex','Rotation',90);
grid on
print -deps2 invpenoncart_sim_results_4
