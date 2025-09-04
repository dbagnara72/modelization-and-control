close all;
clc

N1=Nc-floor(1/Tc);
N2=Nc;
signal = omega_1_msmsm_sim(N1:N2);
time = time_tc_msmsm_sim(N1:N2);

sig_fft=signal;
Nfft = length(sig_fft)-1;
u1 = Nfft*Tc;
f_sig=fft(sig_fft,Nfft);
Xrange=[f_sig(1)/Nfft f_sig(2:Nfft/2)'/(Nfft/2)];
freq = (0:1/u1:Nfft/2/u1-1/u1)';

figure; 
subplot 211
plot(time,signal);
title('signal analysis')
ylabel('A');
xlabel('sec');
set(gca,'xlim',[time(1) time(end)]);
grid on
subplot 212
bar(freq,abs(Xrange));
xlim([0 25]);
grid;
xlabel('Hz');
ylabel('');
title('signal spectrum')
% print('signal_spectrum_1','-depsc');