#ifndef _BEMF_OBSV_LOAD_EST_REDU_SIMULINK_
#define _BEMF_OBSV_LOAD_EAT_REDU_SIMULINK_

extern BEMF_OBSV_LOAD_EST_REDU state_obsv_load_est_redu;
extern unsigned int state_obsv_load_est_redu_initialized;

typedef struct bemf_obsv_load_est_redu_output_s {
	float					omega_pu_hat;				/* omega pu hat */
	float					theta_hat;					/* theta hat */
	float					psi_r_alpha_hat;			/* psi rotor alpha hat */
	float					psi_r_beta_hat;				/* psi rotor beta hat */
} bemf_obsv_load_est_redu_output_t;
#define BEMF_OBSV_LOAD_EST_REDU_OUTPUT bemf_obsv_load_est_redu_output_t



BEMF_OBSV_LOAD_EST_REDU_OUTPUT bemf_obsv_load_est_redu_process_simulink(unsigned char reset, const float u_alpha, const float u_beta, 
		const float i_alpha, const float i_beta, const float u_dc, const float motor_torque_pu, const float ts, const float bemf_obsv_fb_p, const float bemf_obsv_p, 
		const float motorc_omega_bez, const float motorc_m_scale, const float motorc_rs_norm, const float motorc_ls_norm, 
		const float motorc_psi_m_norm, const float motorc_load_inertia_norm, const float bemf_obsv_luenberger_1, 
		const float bemf_obsv_luenberger_2, const float bemf_obsv_luenberger_3);
#endif
