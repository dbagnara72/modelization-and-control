#include "../include/sfbctrl.h"

// ------------------------------------------------------------------------------
void sobvReset(SOBVCTRL *sobv)
{
	sobv->x1_hat = 0.0;
	sobv->x2_hat = 0.0;
	sobv->xp_hat = 0.0;
}

float sobvProcess(SOBVCTRL *sobv, float uc, float xp)
{
    float error_obs = 0;
   
    sobv->xp_hat = c1*sobv->x1_hat;
    error_obs = xp - sobv->xp_hat;
    sobv->x1_hat = a11*sobv->x1_hat + a12*sobv->x2_hat + l1*error_obs;
    sobv->x2_hat = b2*uc + a22*sobv->x2_hat + l2*error_obs;
    
    return sobv->xp_hat;
}

float sfbProcess(SOBVCTRL *sobv, float xp_ref)
{    
    float u_stfb = 0;
    float uc = 0;
    
    u_stfb = k1*sobv->x1_hat + k2*sobv->x2_hat;
    uc = xp_ref*n - u_stfb; 
    
    if (uc >= uc_max)
        uc = uc_max;
    
    if (uc <= -uc_max)
        uc = -uc_max;

    return uc;
}
void sfbProcessSimulink(float xp_ref, float xp, float reset, float *uc, float *xp_hat)
{
	static SOBVCTRL sobv_instance; 
    
    if (reset == 1)
    {
		sobvReset(&sobv_instance);
	}

    *uc = sfbProcess(&sobv_instance, xp_ref);
    *xp_hat = sobvProcess(&sobv_instance, *uc, xp);
}