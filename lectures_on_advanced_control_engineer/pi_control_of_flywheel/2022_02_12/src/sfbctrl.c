#include "../include/sfbctrl.h"

// -----------------------------------------------------------------------
void sobvReset(SOBVCTRL *sobv)
{
	sobv->x1_hat = 0.0;
	sobv->x2_hat = 0.0;
	sobv->x3_hat = 0.0;
	sobv->omega_hat = 0.0;
	sobv->tau_load_hat = 0.0;
}

void piReset(PICTRL *pi)
{
	pi->tau_m_i = 0.0;
	pi->tau_m = 0.0;
}


float sobvProcess(SOBVCTRL *sobv, float tau_m, float theta)
{
    float error_obs = 0;
   
    sobv->omega_hat = sobv->x2_hat;
    sobv->tau_load_hat = sobv->x3_hat;
    
    error_obs = theta - sobv->x1_hat;

    sobv->x1_hat = be1*tau_m + ae11*sobv->x1_hat + ae12*sobv->x2_hat + 
        ae13*sobv->x3_hat + le1*error_obs;
    sobv->x2_hat = be2*tau_m + ae21*sobv->x1_hat + ae22*sobv->x2_hat + 
        ae23*sobv->x3_hat + le2*error_obs;
    sobv->x3_hat = be3*tau_m + ae31*sobv->x1_hat + ae32*sobv->x2_hat + 
        ae33*sobv->x3_hat + le3*error_obs;
    
    return sobv->omega_hat;
}

float piProcess(PICTRL *pi, float omega_ref, float omega_hat, 
                float tau_load_hat)
{    
    float pi_out = 0;
    
    pi_out = kp * (omega_ref - omega_hat) + pi->tau_m_i; 
    pi->tau_m = pi_out + tau_load_hat;
    pi->tau_m_i = ki*ts*(omega_ref - omega_hat) + pi->tau_m_i;
  
    return pi->tau_m;
}

void ctrlSimulink(float omega_ref, float theta, float reset, 
        float *tau_m, float *omega_hat, float *tau_load_hat)
{
	static SOBVCTRL sobv_instance; 
	static PICTRL pi_instance; 

	static float omega_hat_temp; 
	static float tau_m_temp; 
	static float tau_load_hat_temp; 
    
    if (reset == 1)
    {
		sobvReset(&sobv_instance);
		piReset(&pi_instance);
	}

    omega_hat_temp = sobv_instance.omega_hat;
    tau_load_hat_temp = sobv_instance.tau_load_hat;
    tau_m_temp = pi_instance.tau_m;
            
    *tau_m = piProcess(&pi_instance, omega_ref, omega_hat_temp, 
                       tau_load_hat_temp);
    *omega_hat = sobvProcess(&sobv_instance, tau_m_temp, theta);
    *tau_load_hat = sobv_instance.tau_load_hat;
}