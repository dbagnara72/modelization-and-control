%This MATLAB program is used to calculate the self impedance and plot the
%results in Example 9.3
%The parameters are shown in Figure 9.6
rin=[1.15e-3 2e-3];
rout=[1.75e-3 2.6e-3];
height=[15e-6 15e-6];
d=[7.5e-6 7.5e-6];
L1_air=air_mutual(rin(1),rout(1),rin(1),rout(1),height(1),height(1),d(1),d(1));
L2_air=air_mutual(rin(2),rout(2),rin(2),rout(2),height(2),height(2),d(2),d(2));
L12_air=air_mutual(rin(1),rout(1),rin(2),rout(2),height(1),height(2),d(1),d(2));
L1=L1_air+L2_air+2*L12_air;
ur=1000;
sigma=10;
Rdc=0.093;
t1=0.05e-3;
t2=0.1e-3;
t3=0.5e-3;
L_t1 = L1.*ones(1,1000);
L_t2 = L1.*ones(1,1000);
L_t3 = L1.*ones(1,1000);
Rac_t1 = Rdc.*ones(1,1000);
Rac_t2 = Rdc.*ones(1,1000);
Rac_t3 = Rdc.*ones(1,1000);
i = 1;
for frequency=1e6:1e6:1000e6;
L1_t1=impedance_substrate(rin(1),rout(1),rin(1),rout(1),height(1),...
height(1),d(1),d(1),t1,ur,sigma,frequency);
R1_t1=real(L1_t1);
L1_t1=(imag(L1_t1))/(2*pi*frequency)+L1_air;
L2_t1=impedance_substrate(rin(2),rout(2),rin(2),rout(2),height(2),...
height(2),d(2),d(2),t1,ur,sigma,frequency);
R2_t1=real(L2_t1);
L2_t1=(imag(L2_t1))/(2*pi*frequency)+L2_air;
L12_t1=impedance_substrate(rin(1),rout(1),rin(2),rout(2),height(1),...
    height(2),d(1),d(2),t1,ur,sigma,frequency);
R12_t1=real(L12_t1);
L12_t1=(imag(L12_t1))/(2*pi*frequency)+L12_air;
L_t1(i)=L1_t1+L2_t1+2*L12_t1;
Rac_t1(i)=R1_t1+R2_t1+2*R12_t1;
L1_t2=impedance_substrate(rin(1),rout(1),rin(1),rout(1),height(1),...
height(1),d(1),d(1),t2,ur,sigma,frequency);
R1_t2=real(L1_t2);
L1_t2=(imag(L1_t2))/(2*pi*frequency)+L1_air;
L2_t2=impedance_substrate(rin(2),rout(2),rin(2),rout(2),height(2),...
height(2),d(2),d(2),t2,ur,sigma,frequency);
R2_t2=real(L2_t2);
L2_t2=(imag(L2_t2))/(2*pi*frequency)+L2_air;
L12_t2=impedance_substrate(rin(1),rout(1),rin(2),rout(2),height(1),...
    height(2),d(1),d(2),t2,ur,sigma,frequency);
R12_t2=real(L12_t2);
L12_t2=(imag(L12_t2))/(2*pi*frequency)+L12_air;
L_t2(i)=L1_t2+L2_t2+2*L12_t2;
Rac_t2(i)=R1_t2+R2_t2+2*R12_t2;

L1_t3=impedance_substrate(rin(1),rout(1),rin(1),rout(1),height(1),...
height(1),d(1),d(1),t3,ur,sigma,frequency);
R1_t3=real(L1_t3);
L1_t3=(imag(L1_t3))/(2*pi*frequency)+L1_air;
L2_t3=impedance_substrate(rin(2),rout(2),rin(2),rout(2),height(2),...
height(2),d(2),d(2),t3,ur,sigma,frequency);
R2_t3=real(L2_t3);
L2_t3=(imag(L2_t3))/(2*pi*frequency)+L2_air;
L12_t3=impedance_substrate(rin(1),rout(1),rin(2),rout(2),height(1),...
    height(2),d(1),d(2),t3,ur,sigma,frequency);
R12_t3=real(L12_t3);
L12_t3=(imag(L12_t3))/(2*pi*frequency)+L12_air;
L_t3(i)=L1_t3+L2_t3+2*L12_t3;
Rac_t3(i)=R1_t3+R2_t3+2*R12_t3;
i=i+1;
end
x = 1e6:1e6:1000e6;
y1= L_t1./L1;
y2 = L_t2./L1;
y3 = L_t3./L1;
z1= Rac_t1./Rdc+1;
z2 = Rac_t2./Rdc+1;
z3 = Rac_t3./Rdc+1;
semilogx(x,y1,'-',x,y2,'-',x,y3,'-');
axis([1e6,1000e6,1.9,2]);
figure;
semilogx(x,z1,'-',x,z2,'-',x,z3,'-');
axis([1e6,1000e6,1,19]);
%File to define the function air_mutual
function y=air_mutual(r1,r2,a1,a2,h1,h2,d1,d2)
%This function is used to calculate the mutual inductance in air core
%condition.
%r1,r2,h1,d1 are the inside radius, outside radius, height and upright
%position of the cross-section 1.
%a1,a2,h2,d2 are the inside radius, outside radius, height and upright
%position of the cross-section 2.
%z is the axis separation. z=0 for self-inductance calculation; z=|d2- d1|

%for mutual inductance calculation.
global uo;
uo = 4*pi*1e-7;
g = @(k)aircoremul(r1,r2,a1,a2,h1,h2,d1,d2,k);
for upper=1000:1000:1000000
[integalresult,err] = quadgk(g,0,upper);
if err<0.01*integalresult
integalresult_real=integalresult;
else
break;
end
end
y = uo.*pi.*integalresult_real./(h1*log(a2/a1)*h2*log(r2/r1));
end
function y = aircoremul(r1,r2,a1,a2,h1,h2,d1,d2,k)
z = d2-d1;
if z == 0
Q = 2.*(h1.*k+exp(-h1.*k)-1)./(k.^2);
else
Q=2.*(cosh(0.5.*(h1+h2).*k)-cosh(0.5.*(h1-h2).*k))./(k.^2);
end
S1 =(besselj(0,r2.*k)-besselj(0,r1.*k))./k;
S2 =(besselj(0,a2.*k)-besselj(0,a1.*k))./k;
if k(1)==0
Q(1)=0;
S1(1)=0;
S2(1)=0;
end
y = S1.*S2.*Q.*exp(-z.*k);
end
%File to define the function impedance_substrate
function y = impedance_substrate(r1,r2,a1,a2,h1,h2,d1,d2,t,ur,sigma,freq)
%This function is used to calculate the additional mutual impedance to the
%presence of the substrate in sandwich structures.

%r1,r2,h1,d1 are the inside radius, outside radius, height and upright
%position of the cross-section 1.
%a1,a2,h2,d2 are the inside radius, outside radius, height and upright
%position of the cross-section 2.
%t is the thickness of the substrate
%ur relative permeability of the magnetic substrate
%sigma relative permeability of the magnetic substrate
%freq operation frequency
global uo;
uo = 4*pi*1e-7;
omega = 2*pi*freq;
g = @(k)integrand(r1,r2,a1,a2,h1,h2,d1,d2,t,ur,sigma,freq,k);
for upper=1000:1000:1000000
[integalresult,err] = quadgk(g,0,upper);
if err<0.01*integalresult
integalresult_real=integalresult;
else
break;
end
end
y=1j.*omega.*uo.*pi.*integalresult_real./(h1*log(a2/a1)*h2*log(r2/r1));
end
function y=integrand(r1,r2,a1,a2,h1,h2,d1,d2,t,ur,sigma,freq,k)
global uo;
z=d2-d1;
if z==0
Q=2.*(h1.*k+exp(-h1.*k)-1)./(k.^2);
else
Q=2.*(cosh(0.5.*(h1+h2).*k)-cosh(0.5.*(h1-h2).*k))./(k.^2);
end
S1=(besselj(0,r2.*k)-besselj(0,r1.*k))./k;
S2=(besselj(0,a2.*k)-besselj(0,a1.*k))./k;
if k(1)==0
Q(1)=0;
S1(1)=0;
S2(1)=0;
end;
eta=sqrt((1j*2*pi.*freq*sigma*ur*4*pi*1e-7)+(k.^2));
phi=(ur.*k-eta)./(ur.*k+eta);
lambda=phi.*(1-exp(-2*t.*eta))./(1-(phi.^2).*exp(-2*t.*eta));
y=S1.*S2.*Q.*lambda.*exp(-(d1+d2).*k);
end
