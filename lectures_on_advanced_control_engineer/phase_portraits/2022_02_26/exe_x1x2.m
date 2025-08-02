 %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
 function exe_x1x2
 % Nonlinear system:
 % x1d=beta*(2-x1)+x1^2*x2
 % x2d=x1-x1^2*x2
 %%%%%%%%%%%%%%%%
 MainString = mfilename; Stampa=0;
 global beta
 ii=0;
 for beta=(2:5);                     % Changing beta changes the equilibrium point
    x10=2*beta/(beta-1);             % Equilibrium point
    x20=(beta-1)/(2*beta);
    ii=ii+1;
    figure(ii); clf
    V=[[-1.5 1.5]+x10 [-1.5 1.5]+x20];   % Plot window
    In_Con=inicond(V,[5,5]);             % Initial conditions
    Tspan=(0:0.005:1)*2;                 % Simulation final time
    fr=10;  dx=0.06; dy=dx;              % Arrow position and arrow width
    for jj=(1:size(In_Con,1))
       [t,x]=ode45(@exe_x1x2_ode,Tspan,In_Con(jj,:));       % ODE simulation
       plot(x(:,1),x(:,2)); hold on                          % Plot
       freccia(x(fr,1),x(fr,2),x(fr+1,1),x(fr+1,2),dx,dy)    % Draw the arrows
    end
    grid on;  axis(V)                        % Grid and axis
    xlabel('Variable x_1(t)')               % Label along axis x
    ylabel('Variable x_2(t)')               % Label along axis y
    title(['Trajectories in the vicinity of the equilibrium point: beta=' num2str(beta)])
   if Stampa;  eval(['print -depsc ' MainString '_' num2str(gcf) '.eps']);  end
 end
 return

 %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
  function dx=exe_x1x2_ode(t,x);
  global beta
  dx(1,1)=beta*(2-x(1))+x(1)^2*x(2);
  dx(2,1)=x(1)-x(1)^2*x(2);
  return

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function  X0=inicond(V, dxy)
% Provides the initial conditions located on a rectangular shape
% V=[x1 x2 y1 y2] with a number of points given by dxy=[dx dy]
 X0=zeros(2*(dxy(1)+dxy(2)),2);
 for ii= 1:dxy(2);  X0(ii,:)=[V(1) V(3)+(ii-1)*(V(4)-V(3))/dxy(2)]; end
 for ii= 1:dxy(1);  X0(dxy(2)+ii,:)=[V(1)+(ii-1)*(V(2)-V(1))/dxy(1) V(4)]; end
 for ii= 1:dxy(2);  X0(dxy(1)+dxy(2)+ii,:)=[V(2) V(4)-(ii-1)*(V(4)-V(3))/dxy(2)]; end
 for ii= 1:dxy(1);  X0(dxy(1)+2*dxy(2)+ii,:)=[V(2)-(ii-1)*(V(2)-V(1))/dxy(1) V(3)]; end
 return
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

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
plot([x,x+rotpiu(1)],[y,y+rotpiu(2)],'-')
plot([x,x+rotmeno(1)],[y,y+rotmeno(2)],'-')
return
 