
close all
clc


figure(1); 
plot(t,Href_sim,'k-','LineWidth',2);
hold on
plot(t,H_sim,'-','LineWidth',2,'Color',[0.6 0.6 0.6]);
hold off
title('Harmonic amplitude tracking performance','Interpreter','latex');
legend('$H^{ref}(t)$','$H(t)$','Interpreter','latex','Location','best');
set(gca,'xlim',[t(1),t(end)]);
xlabel('t/s','Interpreter','latex');
ylabel({'$H(t)/V$'},'Interpreter','latex','Rotation',90);
h = get(gca,'Children');
set(gca,'Children',[h(2) h(1)])
grid on
print -depsc amplitude_track

figure(2); 
subplot 211
plot(t,y_sim,'k-','LineWidth',2)
title('Harmonic extraction','Interpreter','latex');
legend('$y(t)$','Interpreter','latex','Location','best');
set(gca,'xlim',[t(end)-8e-3,t(end)]);
xlabel('t/s','Interpreter','latex');
ylabel({'$y(t)/V$'},'Interpreter','latex','Rotation',90);
grid on
subplot 212
plot(t,h_sim,'k-','LineWidth',2)
title('Harmonic extraction','Interpreter','latex');
legend('$h(t)$','Interpreter','latex','Location','best');
set(gca,'xlim',[t(end)-8e-3,t(end)]);
set(gca,'ylim',[-5 5]);
xlabel('t/s','Interpreter','latex');
ylabel({'$h(t)/V$'},'Interpreter','latex','Rotation',90);
grid on
print -depsc harmonic_extraction



figure(3); 
plot(t,h_sim,'k-','LineWidth',1);
hold on
plot(t,hhat_sim,'-','LineWidth',3,'Color',[0.6 0.6 0.6]);
hold off
title('Harmonic amplitude tracking performance','Interpreter','latex');
legend('$h(t)$','$\hat{h}(t)$','Interpreter','latex','Location','best');
set(gca,'xlim',[t(end)-8e-3,t(end)]);
xlabel('t/s','Interpreter','latex');
ylabel({'$h(t)/V$'},'Interpreter','latex','Rotation',90);
h = get(gca,'Children');
set(gca,'Children',[h(2) h(1)])
grid on
print -depsc observer_performance

figure(4); 
plot(t,href_sim,'k-','LineWidth',1);
hold on
plot(t,hhat_sim,'-','LineWidth',3,'Color',[0.6 0.6 0.6]);
hold off
title('Harmonic tracking performance','Interpreter','latex');
legend('$h^{ref}(t)$','$\hat{h}(t)$','Interpreter','latex','Location','best');
set(gca,'xlim',[t(end)-8e-3,t(end)]);
xlabel('t/s','Interpreter','latex');
ylabel({'$h(t)/V$'},'Interpreter','latex','Rotation',90);
h = get(gca,'Children');
set(gca,'Children',[h(2) h(1)])
grid on
print -depsc harmonic_tracking
