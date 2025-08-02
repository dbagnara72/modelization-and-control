
figure; 
plot(t,i_ref,'-k','LineWidth',2); 
hold on 
plot(t,i_out,'-','LineWidth',3,'Color',[0.6 0.6 0.6]);
hold off 
title('Tracking Performance of the Proportional-Resonant Control','Interpreter','latex')
legend('$i^{ref}$','$i$','Interpreter','latex');
xlabel('t/s','Interpreter','latex');
ylabel('A','Interpreter','latex','rotation',0);
set(gca,'xlim',[t(1) t(end)]);
set(gca,'ylim',[-1.5 1.5]);
set(gca,'fontname','Times New Roman')
h = get(gca,'Children');
set(gca,'Children',[h(2) h(1)])
grid on
print -depsc PRssd_performance
