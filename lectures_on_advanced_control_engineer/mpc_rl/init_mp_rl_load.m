clear all
close all
clc


Ts=1/20e3; % control sampling time 
s=tf('s');
z=tf('z',Ts);

simlength = 0.2;
Tc = 1e-5; % sampling time for "toworkspace"
Nc = floor(simlength/Tc); % number of maximum point saved in "toworkspace"

rho = 0.0002;
rho = 0;
% rho = 0.1;
udc = 250;

R = 1;
L = 5e-3;

iref_a = 50;
w0=2*pi*50;

A = -R/L;
B = 1/L;
C = 1;
Ad = 1 + A*Ts;
Bd = B*Ts;

%% MPC
function output = mpc(Ad,Bd,udc,rho,ref,input)

    persistent output_z

    if isempty(output_z)
        output_z = 0;
    end
    
    if (output_z == 0)
        
        i_hat_1 = Ad*input+Bd*udc;
        i_hat_2 = Ad*input;
        i_hat_3 = Ad*input-Bd*udc;
        
        J1 = (ref - i_hat_1)^2 + rho*abs(udc-output_z)^2;       % output = 1
        J2 = (ref - i_hat_2)^2 + rho*abs(0-output_z)^2;          % output = 0
        J3 = (ref - i_hat_3)^2 + rho*abs(-udc-output_z)^2;      % output = -1
        
        if ((J1 <= J2) && (J1 <= J3)) 
            output = udc;
        elseif ((J2 <= J1) && (J2 <= J3)) 
            output = 0;
        else 
            output = -udc;
        end 
        
    elseif (output_z == udc)
        
        i_hat_1 = Ad*input+Bd*udc;
        i_hat_2 = Ad*input;
        
        J1 = (ref - i_hat_1)^2 + rho*abs(udc-output_z)^2;       % output = 1
        J2 = (ref - i_hat_2)^2 + rho*abs(0-output_z)^2;          % output = 0
        
        if ((J1 <= J2)) 
            output = udc;
        else
            output = 0;
        end
    else %(output_z == -udc)
        
        i_hat_2 = Ad*input;
        i_hat_3 = Ad*input-Bd*udc;
        
        J2 = (ref - i_hat_2)^2 + rho*abs(0-output_z)^2;          % output = 0
        J3 = (ref - i_hat_3)^2 + rho*abs(-1-output_z)^2;      % output = -1
        
        if ((J2 <= J3)) 
            output = 0;
        else
            output = -udc;
        end
    end
    output_z = output;
end










