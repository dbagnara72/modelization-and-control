
#include <bemf_obsv_redu.h>
#include <bemf_obsv_redu_simulink.h>

BEMF_OBSV_REDU state_obsv_redu = {0.0F};
unsigned int state_obsv_redu_initialized = 0;

// ------------------------------------------------------------------------------
BEMF_OBSV_REDU_OUTPUT bemf_obsv_redu_process_simulink(unsigned char reset, const float u_alpha, const float u_beta, 
		const float i_alpha, const float i_beta, const float u_dc, const float ts, 
		const float bemf_obsv_fb_p, const float bemf_obsv_p, const float motorc_omega_bez, const float motorc_m_scale, 
		const float motorc_rs_norm, const float motorc_ls_norm, const float motorc_phi_m_norm, const float bemf_obsv_kalman_omega, 
		const float bemf_obsv_kalman_theta)
{

	if (!state_obsv_redu_initialized) {
	    bemf_obsv_redu_init(&state_obsv_redu, bemf_obsv_fb_p, bemf_obsv_p, motorc_omega_bez, motorc_m_scale, motorc_rs_norm,
		motorc_ls_norm, motorc_phi_m_norm, bemf_obsv_kalman_omega, bemf_obsv_kalman_theta);
		state_obsv_redu_initialized = 1;
	}

	bemf_obsv_redu_ts(&state_obsv_redu, ts);

	if (reset) {
		bemf_obsv_redu_reset(&state_obsv_redu);
	}
	
	const float output_value = bemf_obsv_redu_process(&state_obsv_redu, u_alpha, u_beta, i_alpha, i_beta, u_dc);
	const float omega_pu_hat = output_value;

	const BEMF_OBSV_REDU_OUTPUT bemf_obsv_redu_output = {
		.omega_pu_hat = omega_pu_hat,
		.theta_hat = state_obsv_redu.theta_hat,
		.psi_r_alpha_hat = state_obsv_redu.psi_r_alpha_hat,
		.psi_r_beta_hat = state_obsv_redu.psi_r_beta_hat
	};
	return bemf_obsv_redu_output;
}

