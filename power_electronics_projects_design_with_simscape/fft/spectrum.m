clear all
close all;
clc
beep off

load uq_data.mat

N1 = 1;
N2 = length(motorc_uq);
segnale = motorc_uq(N1:N2);
time = time(N1:N2).*1e-3;
tc = time(2);

figure; 
plot(time,segnale);
title('motorc uq')
ylabel('');
xlabel('t/s');
set(gca,'xlim',[time(1) time(end)]);
grid on
print('motorc_uq','-dpdf');


sig_fft=segnale;
Nfft=length(sig_fft);
u1=Nfft*tc;
f_sig=fft(sig_fft,Nfft);
Xrange=[f_sig(1)/Nfft f_sig(2:Nfft/2)'/(Nfft/2)];
freq=[0:1/u1:Nfft/2/u1-1/u1]';

figure; 
subplot 211
bar(freq,abs(Xrange));
xlim([0.1 1]);
grid;
xlabel('Hz');
ylabel('');
title('motorc uq spectrum')
subplot 212
bar(freq,abs(Xrange));
xlim([1 5]);
grid;
xlabel('Hz');
ylabel('');
title('motorc uq spectrum')
print('spectrum_uq_1','-dpdf');

figure; 
subplot 211
bar(freq,abs(Xrange));
xlim([5 10]);
grid;
xlabel('Hz');
ylabel('');
title('motorc uq spectrum')
subplot 212
bar(freq,abs(Xrange));
xlim([10 100]);
grid;
xlabel('Hz');
ylabel('');
title('motorc uq spectrum')
print('spectrum_uq_2','-dpdf');

