#ifndef _BEMF_OBSV_REDU_
#define _BEMF_OBSV_REDU_

#include <math.h>
#include <math_f.h>

typedef struct bemf_obsv_redu_s {
	float			ts;		    					/* sampling time */
	float			psi_s_alpha_hat;		    	/*  */
	float			psi_r_alpha_hat;		    	/*  */
	float			psi_s_beta_hat;		    		/*  */
	float			psi_r_beta_hat;		    		/*  */
	float			theta_hat;		    			/*  */
	float			omega_hat;		    			/*  */
	float			bemf_obsv_fb_p;		    		/*  */
	float			bemf_obsv_p;		    		/*  */
	float			motorc_omega_bez;		    	/*  */
	float			motorc_omega_bez_i;		    	/*  */
	float			motorc_m_scale;		    		/*  */
	float			motorc_rs_norm;		    		/*  */
	float			motorc_ls_norm;		    		/*  */
	float			motorc_psi_m_norm;		    	/*  */
	float			bemf_obsv_kalman_omega;			/*  */
	float			bemf_obsv_kalman_theta;			/*  */
} bemf_obsv_redu_t;
#define BEMF_OBSV_REDU bemf_obsv_redu_t

void bemf_obsv_redu_init(volatile BEMF_OBSV_REDU *f, volatile float bemf_obsv_fb_p, volatile float bemf_obsv_p, 
		volatile float motorc_omega_bez, volatile float motorc_m_scale, volatile float motorc_rs_norm, 
		volatile float motorc_ls_norm, volatile float motorc_psi_m_norm, volatile float bemf_obsv_kalman_omega, 
		volatile float bemf_obsv_kalman_theta);

void bemf_obsv_redu_ts(volatile BEMF_OBSV_REDU *f, volatile float ts);

void bemf_obsv_redu_reset(volatile BEMF_OBSV_REDU *f);

void bemf_obsv_redu_update(volatile BEMF_OBSV_REDU *f,volatile float bemf_obsv_fb_p, volatile float bemf_obsv_p);

float bemf_obsv_redu_process(volatile BEMF_OBSV_REDU *f, volatile float u_alpha, volatile float u_beta, volatile float i_alpha, 
	volatile float i_beta, volatile float u_dc);

#endif
