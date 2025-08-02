function equazione
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%  Nonlinear System: 
%  dx(1,1)=x(2);
%  dx(2,1)= -x(1);
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
figure(1)
clf
Tspan=(0:0.005:1)*10;				% Simulation time (200 points)
fr=15;
dx=0.08; dy=dx;
% In_Con=[ 0.0  1.0;					% Initial conditions  
%          0.0 -1.0;					 
%          0.5  0.0;					 
%          1.5  0.0;					 
%         -0.5  0.0;					 
%         -1.5  0.0];
In_Con=[ 1.0  0.0;					% Initial conditions  
];
    
for jj=(1:size(In_Con,1))
    [t,x]=ode45(@equazione_ode,Tspan, In_Con(jj,:));		% Simulation
    plot(x(:,1),x(:,2),'k','LineWidth',1.5); hold on      					    % Data Plot
    freccia(x(fr,1),x(fr,2),x(fr+1,1),x(fr+1,2),dx,dy)   
 end            
grid on									
% axis square
xlabel('Variable $x(t)$','Interpreter','latex') 
ylabel('Variable $v(t)$','Interpreter','latex') 
title('Harmonic oscillator - phase portrait','Interpreter','latex')
set(gca,'xlim',[-1.2 1.2]);
set(gca,'ylim',[-1.2 1.2]);
pbaspect([1 1 1]);
% print -depsc armonic_oscillator2

return

%
function dx=equazione_ode(t,x)
%  Differential equations of the system:
dx(1,1)= x(2);
dx(2,1)= -x(1) -2*x(2);
return

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function f = freccia(x0,y0,x,y,rx,ry)
%f = freccia(x0,y0,x,y,rx,ry)
%freccia disegna una frecccia nel punto x,y nella direzione del vettore
%        dx=x-x0, dy=y-y0. La freccia avra' lunghezza rx e ry nelle
%        due direzioni x  y.
dx=(x-x0)/rx;
dy=(y-y0)/ry;
dxy=sqrt(dx^2+dy^2);
fx=-dx/dxy;
fy=-dy/dxy;
rotpiu=[rx,0;0,ry]*[cos(pi/6), -sin(pi/6); sin(pi/6), cos(pi/6) ]*[fx,fy]';
rotmeno=[rx,0;0,ry]*[cos(pi/6), sin(pi/6); -sin(pi/6), cos(pi/6) ]*[fx,fy]';
plot([x0,x],[y0,y],'-k','LineWidth',1.5)
plot([x,x+rotpiu(1)],[y,y+rotpiu(2)],'-k','LineWidth',1.5)
plot([x,x+rotmeno(1)],[y,y+rotmeno(2)],'-k','LineWidth',1.5)
return

