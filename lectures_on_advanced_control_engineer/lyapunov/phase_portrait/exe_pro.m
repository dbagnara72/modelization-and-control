function exe_pro
% Sistema non lineare:
% 
%  dx(1,1)=beta*x(1)^3+x(2);
%  dx(2,1)=-x(1)^3+beta*x(2)^3;
%
global beta
ii=0;
for beta=[-1 0 1];				% Intervallo di variabilità per beta  
    ii=ii+1;
    figure(ii); clf
    V=[-1 1 -1 1]*1.5;						% Finestra di graficazione
   if beta<0
      In_Con=inicond(V,[5,5]);			% Definizione delle condizioni iniziali
      Tspan=(0:0.002:1)*20;				% Intervallo di simulazione 
      fr=10;									% Posizione della freccia
      dx=0.06;   
   elseif beta==0
      col=(0.1:1/10:1)';
      In_Con=[col*V(2) col*0 ];		% Definizione delle condizioni iniziali
      Tspan=(0:0.002:1)*20;			% Intervallo di simulazione 
      fr=80;									% Posizione della freccia      
      dx=0.06;   
   else
      V=[-1 1 -0.5 0.5];						% Finestra di graficazione
      xx=0.1*exp(1i*(0.02:0.04:1)*2*pi)';
      In_Con=[real(xx) imag(xx)];
      Tspan=(0:0.005:1)*10	;					% Intervallo di simulazione 
      fr=180;									% Posizione della freccia   
      dx=0.03;   
   end
   dy=dx;
   for jj=(1:size(In_Con,1))
       [t,x]=ode45(@exe_pro_ode,Tspan,In_Con(jj,:));		% Simulazione con ODE
       plot(x(:,1),x(:,2),'k','LineWidth',1.5); hold on     % Graficazione
       freccia(x(fr,1),x(fr,2),x(fr+1,1),x(fr+1,2),dx,dy)   % Frecce
   end            
  grid on 
  axis(V)
    xlabel('Variable $x_1(t)$','Interpreter','latex') 
    ylabel('Variable $x_2(t)$','Interpreter','latex') 
    title(['Trajectories close to the equilibrium point: beta = ' num2str(beta)],'Interpreter','latex')
end
return

%%%%%%%%%%%%%%%%%%%%%%%%%%%
function dx=exe_pro_ode(t,x)
%  dx(1,1)=beta*x(1)^3+x(2);
%  dx(2,1)=-x(1)^3+beta*x(2)^3;
global beta
dx(1,1)=beta*x(1)^3+x(2);
dx(2,1)=-x(1)^3+beta*x(2)^3;


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
plot([x0,x],[y0,y],'-')
plot([x,x+rotpiu(1)],[y,y+rotpiu(2)],'-k','LineWidth',1.5)
plot([x,x+rotmeno(1)],[y,y+rotmeno(2)],'-k','LineWidth',1.5)
