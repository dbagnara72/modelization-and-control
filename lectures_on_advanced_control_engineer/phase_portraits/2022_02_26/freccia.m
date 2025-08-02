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