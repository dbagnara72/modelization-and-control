#include <dqpll_thyr.h>

param_thyr_rect_t param_thyr_rect;
int lock_pll_countFault_run;
int lock_pll_countFault;

void dqpll_thyr_init(volatile DQPLL_THYR *dqpll_ctrl)
{
	dqpll_ctrl->ts = 0.0;
	dqpll_ctrl->kp_dqpll_thyr = KP_DQPLL_THYR;
	dqpll_ctrl->ki1_dqpll_thyr = KI1_DQPLL_THYR;
	dqpll_ctrl->ki2_dqpll_thyr = KI2_DQPLL_THYR;
	dqpll_thyr_reset(dqpll_ctrl);
	
	param_thyr_rect.pll_lim_ok = DQPLL_THYR_LIM_OK;
	param_thyr_rect.cabcd_global_state = CABCD_STATE_ZVS_RUN;
	param_thyr_rect.cabcd_fault = 0x000;
	param_thyr_rect.pll_state = DQPLL_THYR_STATE_STOP;
}

void dqpll_thyr_ts(volatile DQPLL_THYR *dqpll_ctrl, volatile float ts)
{
	dqpll_ctrl->ts = ts;
}

void dqpll_thyr_reset(volatile DQPLL_THYR *dqpll_ctrl)
{
	dqpll_ctrl->u_xi = 0.0;
	dqpll_ctrl->u_eta = 0.0;
	dqpll_ctrl->omega_hat = 0.0;
	dqpll_ctrl->omega_i_hat = 0.0;
	dqpll_ctrl->gamma_hat = 0.0;
	dqpll_ctrl->clip_active = 0;
	dqpll_ctrl->dqpll_state = DQPLL_THYR_STATE_STOP;
	lock_pll_countFault = 0;
	lock_pll_countFault_run = 0;
}

float dqpll_thyr_process(volatile DQPLL_THYR *dqpll_ctrl, volatile float u_phase_r, volatile float u_phase_s, volatile float u_phase_t)
{
	float th_sin, th_cos; // componenti seno e coseno dell'angolo stimato dal pll
	float ts, kp_dqpll_thyr, ki1_dqpll_thyr, ki2_dqpll_thyr;
	float omega_i_hat, gamma_hat;
	float u_thyr_alpha, u_thyr_beta, u_thyr_xi, u_thyr_eta, u_thyr_xi_n, u_thyr_eta_n;
	float gamma_hat_unbounded;
	float omega_i_hat_tilde;
	float u_vector_length_inverter;
	float uxi_tilde, ueta_tilde, u_square_tilde, u_tilde;

		ts = dqpll_ctrl->ts;
		kp_dqpll_thyr = dqpll_ctrl->kp_dqpll_thyr;
		ki1_dqpll_thyr = dqpll_ctrl->ki1_dqpll_thyr;
		ki2_dqpll_thyr = dqpll_ctrl->ki2_dqpll_thyr;

		omega_i_hat = dqpll_ctrl->omega_i_hat;
		gamma_hat = dqpll_ctrl->gamma_hat;
		
		/* sincosf(gamma_hat, &th_sin, &th_cos); */
		th_sin = sinf(gamma_hat);
		th_cos = cosf(gamma_hat);

		/* for thyristor rectifier */
		u_thyr_beta = MATH_2_3 * (u_phase_r - MATH_HALF *  u_phase_s - MATH_HALF *  u_phase_t);
		u_thyr_alpha = -MATH_1_SQRT3 * (u_phase_s - u_phase_t);

		u_vector_length_inverter = 1.0f / sqrtf(u_thyr_alpha * u_thyr_alpha + u_thyr_beta * u_thyr_beta);

		u_thyr_xi = u_thyr_alpha * th_cos + u_thyr_beta * th_sin;
		u_thyr_eta = u_thyr_beta * th_cos - u_thyr_alpha * th_sin;

		u_thyr_xi_n = u_thyr_xi * u_vector_length_inverter;
		u_thyr_eta_n = u_thyr_eta * u_vector_length_inverter;

		dqpll_ctrl->u_xi = u_thyr_xi_n;
		dqpll_ctrl->u_eta = u_thyr_eta_n;

		ueta_tilde = 0.0f - u_thyr_eta_n;

		// calcola frequenza di linea in p.u.
		dqpll_ctrl->omega_i_hat = u_thyr_eta_n * ki1_dqpll_thyr * ts + omega_i_hat;
		dqpll_ctrl->omega_hat = u_thyr_eta_n * kp_dqpll_thyr + dqpll_ctrl->omega_i_hat;
		dqpll_ctrl->gamma_hat = dqpll_ctrl->omega_hat * ki2_dqpll_thyr * ts + gamma_hat;
				
		/* keep estimated phase between 0 and 2PI (important for thyristor rectifier) */ 
		if (dqpll_ctrl->gamma_hat > MATH_2PI)
			{
				while(dqpll_ctrl->gamma_hat > MATH_2PI) dqpll_ctrl->gamma_hat -= MATH_2PI;
			}
		else if (dqpll_ctrl->gamma_hat < MATH_NULL)
			{
				while(dqpll_ctrl->gamma_hat < MATH_NULL) dqpll_ctrl->gamma_hat += MATH_2PI;
			}

	switch (dqpll_ctrl->dqpll_state)
	{
		case DQPLL_THYR_STATE_STOP:
			// resetta le variabili ed i filtri
			dqpll_ctrl->omega_hat = 0.0;
			dqpll_ctrl->omega_i_hat = 0.0;
			dqpll_ctrl->gamma_hat = 0.0;
			dqpll_ctrl->dqpll_state = DQPLL_THYR_STATE_START; // prova continuamente a ripartire
		break;

		case DQPLL_THYR_STATE_FAULT:
			// il fault va latchato nella macchina a stati principale
			dqpll_ctrl->dqpll_state = DQPLL_THYR_STATE_STOP; // va in stop e riprova ad agganciarsi
			//param.cabcd_fault |= FAULT_PLL_SYNC; // alza il bit del fault PLL
		break;

		case DQPLL_THYR_STATE_START:
			omega_i_hat_tilde = dqpll_ctrl->omega_i_hat - omega_i_hat;
		    if ((dqpll_ctrl->omega_hat > OMEGA_HAT_WINDOW1) || (dqpll_ctrl->omega_hat < -OMEGA_HAT_WINDOW1))          // la frequenza stimata deve superare una certa soglia
				{
					if ((omega_i_hat_tilde < param_thyr_rect.pll_lim_ok) && (omega_i_hat_tilde > -param_thyr_rect.pll_lim_ok))// se la frequenza e nei limiti
						{
								param_thyr_rect.pll_state = DQPLL_THYR_STATE_CONNECTING;  // va subito in Connecting
								dqpll_ctrl->dqpll_state = DQPLL_THYR_STATE_CONNECTING;  // va subito in Connecting
								param_thyr_rect.cabcd_fault &= ~FAULT_DQPLL_THYR_SYNC;    // abbassa il bit del fault PLL
								lock_pll_countFault = 0;               // Metto a zero il contatore perche vado in Run
						}
					else
						{
							param_thyr_rect.cabcd_fault |= FAULT_DQPLL_THYR_SYNC;    // alza il bit del fault PLL
							param_thyr_rect.pll_state = DQPLL_THYR_STATE_START;      // rimane nello stato
							dqpll_ctrl->dqpll_state = DQPLL_THYR_STATE_START; 
						}
				}
		   else
		       lock_pll_countFault++;

		   if(lock_pll_countFault >= LOCK_PLL_COUNTFAULT_WINDOW1)
			{
				lock_pll_countFault = 0;
				param_thyr_rect.pll_state = DQPLL_THYR_STATE_START; // rimane nello stato
				dqpll_ctrl->dqpll_state = DQPLL_THYR_STATE_START; // rimane nello stato
			}
		break;

		case DQPLL_THYR_STATE_CONNECTING:

			omega_i_hat_tilde = dqpll_ctrl->omega_i_hat - omega_i_hat;
			if ((dqpll_ctrl->omega_hat > OMEGA_HAT_WINDOW2) || (dqpll_ctrl->omega_hat < -OMEGA_HAT_WINDOW2))          // la frequenza stimata deve superare una certa soglia
			{
		                    if ((omega_i_hat_tilde < param_thyr_rect.pll_lim_ok) && (omega_i_hat_tilde > -param_thyr_rect.pll_lim_ok))
								{  // se la frequenza e nei limiti
									param_thyr_rect.pll_state = DQPLL_THYR_STATE_CONNECTING; // rimane in run
									dqpll_ctrl->dqpll_state = DQPLL_THYR_STATE_CONNECTING; // rimane in run
								}
		                    else
								{
									param_thyr_rect.pll_state = DQPLL_THYR_STATE_FAULT;      // va subito in fault ma sarebbe meglio inserire un contatore di attesa
									dqpll_ctrl->dqpll_state = DQPLL_THYR_STATE_FAULT;      // va subito in fault ma sarebbe meglio inserire un contatore di attesa
									param_thyr_rect.cabcd_fault |= FAULT_DQPLL_THYR_SYNC;    // alza il bit del fault PLL
								}
		                }
		                else
		                {
		                     lock_pll_countFault_run++;
		                }

		                if(lock_pll_countFault_run >= LOCK_PLL_COUNTFAULT_WINDOW2 )
							{
								param_thyr_rect.pll_state = DQPLL_THYR_STATE_FAULT;
								dqpll_ctrl->dqpll_state = DQPLL_THYR_STATE_FAULT;
								lock_pll_countFault_run = 0;
								param_thyr_rect.cabcd_fault |= FAULT_DQPLL_THYR_SYNC;                 // alza il bit del fault PLL
							}

		                if (param_thyr_rect.cabcd_global_state == CABCD_STATE_ZVS_RUN )    // se il pfc va in RUN
							{
								param_thyr_rect.pll_state = DQPLL_THYR_STATE_RUN;
								dqpll_ctrl->dqpll_state = DQPLL_THYR_STATE_RUN;
								lock_pll_countFault_run = 0;
							}
		break;


		case DQPLL_THYR_STATE_RUN:
		omega_i_hat_tilde = dqpll_ctrl->omega_i_hat - omega_i_hat;
		if ((dqpll_ctrl->omega_hat > OMEGA_HAT_WINDOW2) || (dqpll_ctrl->omega_hat < -OMEGA_HAT_WINDOW2))    // la frequenza stimata deve superare una certa soglia
			{
			    if ((omega_i_hat_tilde < param_thyr_rect.pll_lim_ok) && (omega_i_hat_tilde > -param_thyr_rect.pll_lim_ok))
					{  // se la frequenza ï¿½ nei limiti
						param_thyr_rect.pll_state = DQPLL_THYR_STATE_RUN; // rimane in run
						dqpll_ctrl->dqpll_state = DQPLL_THYR_STATE_RUN; // rimane in run
					}
			    else
					{
						param_thyr_rect.pll_state = DQPLL_THYR_STATE_FAULT; // va subito in fault ma sarebbe meglio inserire un contatore di attesa
						dqpll_ctrl->dqpll_state = DQPLL_THYR_STATE_FAULT; // va subito in fault ma sarebbe meglio inserire un contatore di attesa
						param_thyr_rect.cabcd_fault |= FAULT_DQPLL_THYR_SYNC; // alza il bit del fault PLL
					}
			}
			else
				{
					lock_pll_countFault_run++;
				}

			if(lock_pll_countFault_run >= LOCK_PLL_COUNTFAULT_WINDOW2 )
				{
					param_thyr_rect.pll_state = DQPLL_THYR_STATE_FAULT;
					dqpll_ctrl->dqpll_state = DQPLL_THYR_STATE_FAULT;
					lock_pll_countFault_run = 0;
					param_thyr_rect.cabcd_fault |= FAULT_DQPLL_THYR_SYNC; // alza il bit del fault PLL
				}

			if (param_thyr_rect.cabcd_global_state < CABCD_STATE_ZVS_RUN )    // se il PFC esce dal RUN
				{
					param_thyr_rect.pll_state = DQPLL_THYR_STATE_STOP;
					dqpll_ctrl->dqpll_state = DQPLL_THYR_STATE_STOP;
				}
			break;
	}

	return gamma_hat;
}

