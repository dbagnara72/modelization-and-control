close all


s=tf('s');

w0=2*pi*50;
wp = 200*2*pi;
ctrl = 1 + 35*s/(s^2 + w0*s*2*0.0001 + w0^2);
plant = wp^2/(s^2+2*wp*s+wp^2);
G=minreal(ctrl*plant);
figure; bode(G); grid on