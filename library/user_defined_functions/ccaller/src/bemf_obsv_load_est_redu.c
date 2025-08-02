#include <bemf_obsv_load_est_redu.h>

void bemf_obsv_load_est_redu_init(volatile BEMF_OBSV_LOAD_EST_REDU *f, volatile float bemf_obsv_fb_p, volatile float bemf_obsv_p, 
		volatile float motorc_omega_bez, volatile float motorc_m_scale, volatile float motorc_rs_norm, 
		volatile float motorc_ls_norm, volatile float motorc_psi_m_norm, volatile float motorc_load_inertia_norm, volatile float bemf_obsv_luenberger_1, 
		volatile float bemf_obsv_luenberger_2, volatile float bemf_obsv_luenberger_3)
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
	f->motorc_load_inertia_norm = motorc_load_inertia_norm;
	f->bemf_obsv_luenberger_1 = bemf_obsv_luenberger_1;
	f->bemf_obsv_luenberger_2 = bemf_obsv_luenberger_2;
	f->bemf_obsv_luenberger_3 = bemf_obsv_luenberger_3;
	bemf_obsv_load_est_redu_reset(f);
}

void bemf_obsv_load_est_redu_update(volatile BEMF_OBSV_LOAD_EST_REDU *f, volatile float bemf_obsv_fb_p, volatile float bemf_obsv_p)
{
	f->bemf_obsv_fb_p = bemf_obsv_fb_p;
	f->bemf_obsv_p = bemf_obsv_p;
}

void bemf_obsv_load_est_redu_ts(volatile BEMF_OBSV_LOAD_EST_REDU *f, volatile float ts)
{
	f->ts = ts;
}

void bemf_obsv_load_est_redu_reset(volatile BEMF_OBSV_LOAD_EST_REDU *f)
{
	f->psi_s_alpha_hat = 0.0;
	f->psi_r_alpha_hat = 0.0;
	f->psi_s_beta_hat = 0.0;
	f->psi_r_beta_hat = 0.0;
	f->theta_hat = 0.0;
	f->omega_hat = 0.0;
	f->torque_load_hat = 0.0;
}

float bemf_obsv_load_est_redu_process(volatile BEMF_OBSV_LOAD_EST_REDU *f, volatile float u_alpha, volatile float u_beta, volatile float i_alpha, 
	volatile float i_beta, volatile float u_dc, volatile float motor_torque_pu)
{
	const float theta_hat = f->theta_hat;
	const float omega_hat = f->omega_hat;
	const float torque_load_hat = f->torque_load_hat;
	const float torque_motor = motor_torque_pu;

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

   	const float omega_hat_hat = omega_hat + (dtheta_bounded * f->bemf_obsv_luenberger_2 + (torque_motor - torque_load_hat) * f->ts / f->motorc_load_inertia_norm) * f->motorc_omega_bez_i;
	const float theta_hat_hat_unbounded = dtheta_bounded * f->bemf_obsv_luenberger_1 + theta_hat + omega_hat * f->motorc_omega_bez * f->ts;
	const float theta_hat_hat = - MATH_PI + fmodf(theta_hat_hat_unbounded + MATH_3PI, MATH_2PI);
	const float torque_load_hat_hat = torque_load_hat + dtheta_bounded * f->bemf_obsv_luenberger_3;
	

	f->psi_s_alpha_hat = psi_s_alpha_hat_hat;
	f->psi_s_beta_hat = psi_s_beta_hat_hat;

	f->psi_r_alpha_hat = psi_r_alpha_hat_hat;
	f->psi_r_beta_hat = psi_r_beta_hat_hat;

	f->theta_hat = theta_hat_hat;
	f->omega_hat = omega_hat_hat;	
	f->torque_load_hat = torque_load_hat_hat;	

	return omega_hat;
}

