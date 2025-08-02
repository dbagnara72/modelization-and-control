g = 9.81;
%% dati impianto 
lunghezza_impianto = 1288;
Dpuleggia = 4.9; % diametro puleggia in m
mu = 7.67; %massa unitaria fune on kg/m
% nv = 58; % numero di veicoli
nv = 0; % numero di veicoli
mvv = 850; % massa veicolo a vuoto
mvc = 1490; % massa veicolo a carico
max_pendenza = 27; % massima pendenza in gradi
modulo_elastico_fune = 125e3; %N/mm^2
sezione_metallica_fune = 872; %mm^2


%% data plant normalized/scaled over one LD
l_fune = lunghezza_impianto*2;
m_fune = l_fune * mu;
m_veicoli_max = mvc*nv;
m_veicoli_min = mvv*nv;

ratio = 0.5; % ration between "m" and "l" of the inertia
Jm_max = (m_fune+m_veicoli_max)*(ratio)*Dpuleggia/2+Jm_rotore_LD9 %kg*m^2
Jl_max = (m_fune+m_veicoli_max)*(1-ratio)*Dpuleggia/2 %kg*m^2
Jm_min = (m_fune+m_veicoli_min)*(ratio)*Dpuleggia/2+Jm_rotore_LD9 %kg*m^2
Jl_min = (m_fune+m_veicoli_min)*(1-ratio)*Dpuleggia/2 %kg*m^2

% Jm_avg = 117000;
% Jl_avg = 115000;
Jm_avg = Jm_max;
Jl_avg = Jl_max;
J = (Jm_avg + Jl_avg)/n_modules;
J = J
% Jm_avg = (Jm_max+Jm_min)/2;
% Jl_avg = (Jl_max+Jl_min)/2;
% Jm_avg = (Jm_min);
% Jl_avg = (Jl_min);
% Ktheta_avg = 1/4*(modulo_elastico_fune * sezione_metallica_fune * (Dpuleggia/2)^2 / lunghezza_impianto);
Ktheta_avg = 125000;

f0_min = 1/2/pi*sqrt(Ktheta_avg*(1/Jm_max+1/Jl_max)) %Hz
f0_max = 1/2/pi*sqrt(Ktheta_avg*(1/Jm_min+1/Jl_min)) %Hz
max_load = 1/2*m_veicoli_max*sind(max_pendenza)* g * Dpuleggia/10  % Nm - ipotesi che 1/10 dei veicoli carichi si trovano nel punto di max pendenza

%% data fuer simulation - these data implement the real plant
% Jl = Jl_min;
% Jm = Jm_min;
Jl = Jl_max;
Jm = Jm_max;

ke_l = 1.1;
ke_m = 1.1;
ke_theta = 1;

% Jl = ke_l*Jl_avg;
% Jm = ke_m*Jm_avg;
% Jl = 80500;
% Jm = 81900;
Ktheta = ke_theta*Ktheta_avg
w0 = sqrt(Ktheta*(1/Jm+1/Jl)) %rad/s
f0 = w0/(2*pi) %Hz
% Tload = max_load;
% Tload = Tnom/3;
% Tload = 0;

