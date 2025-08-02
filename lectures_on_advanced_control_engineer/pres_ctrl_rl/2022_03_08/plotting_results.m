
figure; 
plot(t,i_ref,'--k','LineWidth',1.8); hold on 
plot(t,i_out,'-k','LineWidth',1.8); hold off 
title('Tracking of the P-Resonant Controller','Interpreter','latex')
legend('$i^{ref}$','$i$','Interpreter','latex');
xlabel('t/s','Interpreter','latex');
ylabel('A','Interpreter','latex','rotation',0);
set(gca,'xlim',[t(end)-(3*2*pi/w) t(end)]);
set(gca,'ylim',[-1.5 1.5]);
set(gca,'fontname','Times New Roman')
grid on
% print -deps2 PRssd_performance
