function initialization()
    ts_inv = 1/fPWM_INV;
    dead_time_INV = 0;
    dead_time = dead_time_INV;
    delayINV_modA = 0;
    
    tsample = ts_inv;

    tc = ts_inv/400;
    t_measure = simlength/45;
    Nc = floor(t_measure/tc);
    Ns_inv = floor(t_measure/ts_inv);
    Nsample = floor(t_measure/tsample);

    s=tf('s');
    z=tf('z',ts_inv);
    
    %% current quantization
    Imax_adc = 96;
    CurrentQuantization = Imax_adc/2^11;
    
    %% DClink
    CFi = 90e-6; %210e-6
    Vdc_bez = 400;
    Vdc = Vdc_bez*0.9;
    Vdc_max = Vdc_bez*1.25;
    udc_bez = Vdc_bez;
    
    run('pmsm_data/pmsm_64Nm_2291rpm_ver_vii.m');
    
    
    %% propeller
    run('propeller_data/propeller_model.m');
    %% load data
    run('load_data/load_data.m');
    
    %% PMSM control 
    % torque_mode = 0;
    % id_ref_pu = 0.175;
    % id_ff_omega_th = 1.1;
    % bemf_obsv_enable_speed = 0.1;
    
    torque_mode = 1;
    torque_ref = 0;
    angle_error_deg = -10;
    angle_error = angle_error_deg/180*pi;
    time_init = 0.025;
    id_ref_pu = 0;
    id_ff_omega_th = 0.2;
    bemf_obsv_enable_speed = 0.20;
    
    %% I/F control
    I_F_control = 1;
    iload_rms_ref = 5;
    id_ref_if_pu = iload_rms_ref*sqrt(2)/ibez;
    omega_ref_if_pu = 300*2*pi/omega_bez;
    
    %% simulation data: speed reference, load torque 
    omega_m_sim1 = omega_m_bez*0.2;
    omega_m_sim2 = omega_m_bez*0.35;
    omega_m_sim3 = omega_m_bez*0.5;
    omega_m_sim4 = omega_m_bez*0.75;
    omega_m_sim5 = omega_m_bez;
    tau_load_sim = 0; %N*m
    b = tau_load_sim/(omega_m_bez/60*2*pi);
    b_square = tau_load_sim/(omega_m_bez/60*2*pi)^2;
    
    %% rotor speed observer
    Aso = [1 ts_inv; 0 1];
    Cso = [1 0];
    p2place = exp([-250 -1000]*ts_inv);
    K = (acker(Aso',Cso',p2place))';
    kg = K(1)
    kw = K(2)
    % kg = 0.2;
    % kw = 38;
    
    %% rotor speed control
    kp_w = 1;
    ki_w = 1;
    %% current control
    kp_i = 0.125;
    ki_i = 6;
    % kp_i = 0.25;
    % ki_i = 12;
    CTRPIFF_CLIP_RELEASE = 0.01;
    %% FW control
    kp_fw = 0.05;
    ki_fw = 1.8;
    
    %% BEMF observer
    emf_fb_p = 0.05;
    % emf_fb_p = 0.2;
    emf_p = emf_fb_p*4/10;
    emf_fb_p_ccaller = emf_fb_p;
    emf_p_ccaller = emf_fb_p_ccaller*4/10;
    motorc_m_scale = 2/3*Vdc_bez/ubez;
    
    %% Module selection
    Tambient = 25; % celsius
    DThs_init = 0; % Heat sink initial delta temperature [Celsius]
    run('module_data/module_CAB016M12FM3.m');
    run('heatsink_data/heatsink_data.m');
    
    %% Lithium Ion Battery
    soc_init = 0.96;
    
    R = 8.3143;
    F = 96487;
    T = 273.15+40;
    Q = 400*3600; %C
    
    Vdc_nom =Vdc_bez;
    Pnom = 20e3;
    Idc_nom = Pnom/Vdc_nom;
    Rmax = Vdc_nom^2/(Pnom*0.1);
    Rmin = Vdc_nom^2/(Pnom);
    
    E_1 = -1.031;
    % E0 = 3.685;
    E0 = 3.485;
    % E1 = 0.15;
    E1 = 0.2156;
    E2 = 0;
    E3 = 0;
    Elog = -0.05;
    alpha = 35;
    
    q1Kalman = ts_inv^2;
    q2Kalman = ts_inv^1;
    q3Kalman = 0;
    rKalman = 1;
    
    Zmodel = (0:1e-3:1);
    ocv_model = E_1*exp(-Zmodel*alpha) + E0 + E1*Zmodel + E2*Zmodel.^2 +...
        E3*Zmodel.^3 + Elog*log(1-Zmodel+ts_inv);
    % figure; 
    % plot(Zmodel,ocv_model,'LineWidth',2);
    % xlabel('state of charge [p.u.]');
    % ylabel('open circuit voltage [V]');
    % title('open circuit voltage(state of charge)');
    % grid on
    
    
    %% C-Caller
    open_system('svm_bemf_pmsm');
    Simulink.importExternalCTypes('svm_bemf_pmsm','Names',{'mavgflt_output_t'});
    Simulink.importExternalCTypes('svm_bemf_pmsm','Names',{'bemf_mb_obsv_output_t'});
    Simulink.importExternalCTypes('svm_bemf_pmsm','Names',{'dqvector_pi_output_t'});
    Simulink.importExternalCTypes('svm_bemf_pmsm','Names',{'sv_pwm_output_t'});
    Simulink.importExternalCTypes('svm_bemf_pmsm','Names',{'global_state_machine_output_t'});

end