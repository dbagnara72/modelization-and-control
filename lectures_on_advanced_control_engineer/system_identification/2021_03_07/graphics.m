close all


N=length(t);
b1_array = b3*ones(1,N);
b2_array = b4*ones(1,N);
a1_array = a3*ones(1,N);
a2_array = a2*ones(1,N);

figure; 
bode(sysIc,sysId)
legend('$G(s)$','$G(Z)$','Interpreter','latex')
title('$Bode$ $diagram$ $of$ $the$ $dynamical$ $system$','Interpreter','latex')
grid on
% print -dtiff bode_diagram

figure; 
subplot 211
plot(t,u_input,t,y_output);
legend('$u(t)$','$y(t)$','Interpreter','latex')
title('$Step$ $responce$','Interpreter','latex')
grid on
xlabel('$s$','Interpreter','latex');
ylabel('');
subplot 212
plot(t,noise)
title('$noise$ $applied$ $to$ $the$ $measure$','Interpreter','latex')
legend('$n(t)$','Interpreter','latex')
grid on
xlabel('$s$','Interpreter','latex');
% print -dtiff step_responce

figure; 
subplot 211
plot(t,a1_hat,t,a2_hat,t,a1_array,t,a2_array);
title('$Parameters$ $estimation$','Interpreter','latex')
% set(gca,'ylim',[-2 2])
grid on
xlabel('$s$','Interpreter','latex');
ylabel('');
legend('$\hat{a}_1$','$\hat{a}_2$','$a_1$','$a_2$','Interpreter','latex');
subplot 212
plot(t,b1_hat,t,b2_hat,t,b1_array,t,b2_array);
title('$Parameters$ $estimation$','Interpreter','latex')
grid on
xlabel('$s$','Interpreter','latex');
ylabel('');
legend('$\hat{b}_1$','$\hat{b}_2$','$b_1$','$b_2$','Interpreter','latex');
% set(gca,'ylim',[0.15 0.2])
% print -dtiff param_estimator

