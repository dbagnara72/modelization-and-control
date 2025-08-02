#include <bemf_obsv_redu.h>

void bemf_obsv_redu_init(volatile BEMF_OBSV_REDU *f, volatile float bemf_obsv_fb_p, volatile float bemf_obsv_p, 
		volatile float motorc_omega_bez, volatile float motorc_m_scale, volatile float motorc_rs_norm, 
		volatile float motorc_ls_norm, volatile float motorc_psi_m_norm, volatile float bemf_obsv_kalman_omega, 
		volatile float bemf_obsv_kalman_theta)
{
	f->ts = 0.0;
	f->bemf_obsv_fb_p = bemf_obsv_fb_p;
	f->bemf_obsv_p = bemf_obsv_p;
	f->motorc_omega_bez = motorc_omega_bez;
	f->motorc_omega_bez_i = 1.0/motorc_omega_bez;
	f->motorc_m_scale = motorc_m_scale;
	f->motorc_rs_norm = motorc_rs_norm;
	f->motorc_ls_norm = motorc_ls_norm;
	f->motorc_psi_m_norm = motorc_psi_m_norm;
	f->bemf_obsv_kalman_omega = bemf_obsv_kalman_omega;
	f->bemf_obsv_kalman_theta = bemf_obsv_kalman_theta;
	bemf_obsv_redu_reset(f);
}

void bemf_obsv_redu_update(volatile BEMF_OBSV_REDU *f, volatile float bemf_obsv_fb_p, volatile float bemf_obsv_p)
{
	f->bemf_obsv_fb_p = bemf_obsv_fb_p;
	f->bemf_obsv_p = bemf_obsv_p;
}

void bemf_obsv_redu_ts(volatile BEMF_OBSV_REDU *f, volatile float ts)
{
	f->ts = ts;
}

void bemf_obsv_redu_reset(volatile BEMF_OBSV_REDU *f)
{
	f->psi_s_alpha_hat = 0.0;
	f->psi_r_alpha_hat = 0.0;
	f->psi_s_beta_hat = 0.0;
	f->psi_r_beta_hat = 0.0;
	f->theta_hat = 0.0;
	f->omega_hat = 0.0;
}

float bemf_obsv_redu_process(volatile BEMF_OBSV_REDU *f, volatile float u_alpha, volatile float u_beta, volatile float i_alpha, 
	volatile float i_beta, volatile float u_dc)
{
	const float theta_hat = f->theta_hat;
	const float omega_hat = f->omega_hat;

	const float psi_m_alpha = f->motorc_psi_m_norm * cosf(theta_hat);
	const float psi_m_beta = f->motorc_psi_m_norm * sinf(theta_hat);

	const float psi_s_alpha_hat_hat = (f->bemf_obsv_fb_p * (psi_m_alpha - f->psi_r_alpha_hat) + f->motorc_m_scale * u_dc * u_alpha - 
	                    f->motorc_rs_norm * i_alpha - f->bemf_obsv_p * f->psi_s_alpha_hat) * f->motorc_omega_bez * f->ts + f->psi_s_alpha_hat;

	const float psi_s_beta_hat_hat = (f->bemf_obsv_fb_p * (psi_m_beta - f->psi_r_beta_hat) + f->motorc_m_scale * u_dc * u_beta - 
	                    f->motorc_rs_norm * i_beta - f->bemf_obsv_p * f->psi_s_beta_hat) * f->motorc_omega_bez * f->ts + f->psi_s_beta_hat;

	const float psi_r_alpha_hat_hat = f->psi_s_alpha_hat - f->motorc_ls_norm * i_alpha;
	const float psi_r_beta_hat_hat = f->psi_s_beta_hat - f->motorc_ls_norm * i_beta;

	const float psi_m_alpha_hat = f->psi_r_alpha_hat;
	const float psi_m_beta_hat = f->psi_r_beta_hat;

	const float theta_bemf_hat = atan2f(psi_m_beta_hat, psi_m_alpha_hat);

	const float dtheta = theta_bemf_hat - theta_hat;
	const float dtheta_bounded = - MATH_PI + fmodf(dtheta + MATH_3PI, MATH_2PI);

    const float omega_hat_hat = dtheta_bounded * f->bemf_obsv_kalman_omega * f->motorc_omega_bez_i + omega_hat;
	const float theta_hat_hat_unbounded = dtheta_bounded * f->bemf_obsv_kalman_theta + theta_hat + omega_hat * f->motorc_omega_bez * f->ts;
	const float theta_hat_hat = - MATH_PI + fmodf(theta_hat_hat_unbounded + MATH_3PI, MATH_2PI);
	

	f->psi_s_alpha_hat = psi_s_alpha_hat_hat;
	f->psi_s_beta_hat = psi_s_beta_hat_hat;

	f->psi_r_alpha_hat = psi_r_alpha_hat_hat;
	f->psi_r_beta_hat = psi_r_beta_hat_hat;

	f->theta_hat = theta_hat_hat;
	f->omega_hat = omega_hat_hat;	

	return omega_hat;
}

