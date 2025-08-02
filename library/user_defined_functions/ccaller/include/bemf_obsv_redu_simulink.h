#ifndef _BEMF_OBSV_REDU_SIMULINK_
#define _BEMF_OBSV_REDU_SIMULINK_

#define BEMF_OBSV_LOAD_REDU_INSTANCES				16

typedef struct bemf_obsv_redu_output_s {
	float					omega_pu_hat;				/* omega pu hat */
	float					theta_hat;					/* theta hat */
	float					psi_r_alpha_hat;			/* psi rotor alpha hat */
	float					psi_r_beta_hat;				/* psi rotor beta hat */
} bemf_obsv_redu_output_t;
#define BEMF_OBSV_REDU_OUTPUT bemf_obsv_redu_output_t

extern BEMF_OBSV_REDU state_obsv_redu;
extern unsigned int state_obsv_redu_initialized;

BEMF_OBSV_REDU_OUTPUT bemf_obsv_redu_process_simulink(unsigned char reset, const float u_alpha, const float u_beta, 
		const float i_alpha, const float i_beta, const float u_dc, const float ts, 
		const float bemf_obsv_fb_p, const float bemf_obsv_p, const float motorc_omega_bez, const float motorc_m_scale, 
		const float motorc_rs_norm, const float motorc_ls_norm, const float motorc_psi_m_norm, const float bemf_obsv_kalman_omega, 
		const float bemf_obsv_kalman_theta);
#endif
