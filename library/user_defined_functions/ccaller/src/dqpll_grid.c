#include <dqpll_grid.h>

param_t param;
int aggancio_pll_ContaFault_RUN;
int aggancio_pll_ContaFault;

void dqpll_grid_init(volatile DQPLL_GRID *dqpll_ctrl)
{
	dqpll_ctrl->ts = 0.0;
	dqpll_ctrl->kp_dqpll_grid = KP_DQPLL_GRID;
	dqpll_ctrl->ki1_dqpll_grid = KI1_DQPLL_GRID;
	dqpll_ctrl->ki2_dqpll_grid = KI2_DQPLL_GRID;
	dqpll_grid_reset(dqpll_ctrl);
	
	param.pll_lim_ok = DQPLL_GRID_LIM_OK;
	param.cabcd_global_state = CABCD_STATE_ZVS_RUN;
	param.cabcd_fault = 0x000;
	param.pll_state = DQPLL_GRID_STATE_STOP;
}

void dqpll_grid_ts(volatile DQPLL_GRID *dqpll_ctrl, volatile float ts)
{
	dqpll_ctrl->ts = ts;
}

void dqpll_grid_reset(volatile DQPLL_GRID *dqpll_ctrl)
{
	dqpll_ctrl->u_xi = 0.0;
	dqpll_ctrl->u_eta = 0.0;
	dqpll_ctrl->omega_hat = 0.0;
	dqpll_ctrl->omega_i_hat = 0.0;
	dqpll_ctrl->gamma_hat = 0.0;
	dqpll_ctrl->clip_active = 0;
	dqpll_ctrl->dqpll_state = DQPLL_GRID_STATE_STOP;
	aggancio_pll_ContaFault = 0;
	aggancio_pll_ContaFault_RUN = 0;
}

float dqpll_grid_process(volatile DQPLL_GRID *dqpll_ctrl, volatile float u_phase_r, volatile float u_phase_s, volatile float u_phase_t)
{
	float th_sin, th_cos; // componenti seno e coseno dell'angolo stimato dal pll
	float ts, kp_dqpll_grid, ki1_dqpll_grid, ki2_dqpll_grid;
	float omega_i_hat, gamma_hat;
	float u_grid_alpha, u_grid_beta, u_grid_xi, u_grid_eta, u_grid_xi_n, u_grid_eta_n;
	float gamma_hat_unbounded;
	float omega_i_hat_tilde;
	float u_vector_length_inverter;
	float uxi_tilde, ueta_tilde, u_square_tilde, u_tilde;

		ts = dqpll_ctrl->ts;
		kp_dqpll_grid = dqpll_ctrl->kp_dqpll_grid;
		ki1_dqpll_grid = dqpll_ctrl->ki1_dqpll_grid;
		ki2_dqpll_grid = dqpll_ctrl->ki2_dqpll_grid;

		omega_i_hat = dqpll_ctrl->omega_i_hat;
		gamma_hat = dqpll_ctrl->gamma_hat;
		
		/* sincosf(gamma_hat, &th_sin, &th_cos); */
		th_sin = sinf(gamma_hat);
		th_cos = cosf(gamma_hat);

		u_grid_alpha = MATH_2_3 * (u_phase_r - MATH_HALF *  u_phase_s - MATH_HALF *  u_phase_t);
		u_grid_beta = MATH_1_SQRT3 * (u_phase_s - u_phase_t);

		u_vector_length_inverter = 1.0f / sqrtf(u_grid_alpha * u_grid_alpha + u_grid_beta * u_grid_beta);
		//u_vector_length = isqrtf(u_grid_alpha * u_grid_alpha + u_grid_beta * u_grid_beta);

		u_grid_xi = u_grid_alpha * th_cos + u_grid_beta * th_sin;
		u_grid_eta = u_grid_beta * th_cos - u_grid_alpha * th_sin;

		u_grid_xi_n = u_grid_xi * u_vector_length_inverter;
		u_grid_eta_n = u_grid_eta * u_vector_length_inverter;

		dqpll_ctrl->u_xi = u_grid_xi_n;
		dqpll_ctrl->u_eta = u_grid_eta_n;

		uxi_tilde = 1.0f - u_grid_xi_n;
		ueta_tilde = 0.0f - u_grid_eta_n;

		u_square_tilde = uxi_tilde * uxi_tilde + ueta_tilde * ueta_tilde;
		u_tilde = 0.0;
		if (u_square_tilde > 0.0f)
			{
				u_tilde = sqrtf(u_square_tilde);
			}
		if (ueta_tilde >= 0.0f)
			{
				u_tilde *= -1.0f;
			}

		// calcola frequenza di linea in p.u.
		dqpll_ctrl->omega_i_hat = u_grid_eta_n * ki1_dqpll_grid * ts + omega_i_hat;
		dqpll_ctrl->omega_hat = u_grid_eta_n * kp_dqpll_grid + dqpll_ctrl->omega_i_hat;
		dqpll_ctrl->gamma_hat = dqpll_ctrl->omega_hat * ki2_dqpll_grid * ts + gamma_hat;
//		gamma_hat_unbounded = dqpll_ctrl->omega_hat * ki2_dqpll_grid * ts + gamma_hat;
		
		// keep estimated phase between PI and -PI
		if (dqpll_ctrl->gamma_hat > MATH_PI)
			{
				while(dqpll_ctrl->gamma_hat > MATH_PI) dqpll_ctrl->gamma_hat -= MATH_2PI;
			}
		else if (dqpll_ctrl->gamma_hat < -MATH_PI)
			{
				while(dqpll_ctrl->gamma_hat < -MATH_PI) dqpll_ctrl->gamma_hat += MATH_2PI;
			}
			
//		dqpll_ctrl->gamma_hat = - MATH_PI + fmodf(gamma_hat_unbounded + MATH_3PI, MATH_2PI);

	switch (dqpll_ctrl->dqpll_state)
	{
		case DQPLL_GRID_STATE_STOP:
			// resetta le variabili ed i filtri
			dqpll_ctrl->omega_hat = 0.0;
			dqpll_ctrl->omega_i_hat = 0.0;
			dqpll_ctrl->gamma_hat = 0.0;
			dqpll_ctrl->dqpll_state = DQPLL_GRID_STATE_START; // prova continuamente a ripartire
		break;

		case DQPLL_GRID_STATE_FAULT:
			// il fault va latchato nella macchina a stati principale
			dqpll_ctrl->dqpll_state = DQPLL_GRID_STATE_STOP; // va in stop e riprova ad agganciarsi
			//param.cabcd_fault |= FAULT_PLL_SYNC; // alza il bit del fault PLL
		break;

		case DQPLL_GRID_STATE_START:
			omega_i_hat_tilde = dqpll_ctrl->omega_i_hat - omega_i_hat;
		    if ((dqpll_ctrl->omega_hat > OMEGA_HAT_WINDOW1) || (dqpll_ctrl->omega_hat < -OMEGA_HAT_WINDOW1))          // la frequenza stimata deve superare una certa soglia
				{
					if ((omega_i_hat_tilde < param.pll_lim_ok) && (omega_i_hat_tilde > -param.pll_lim_ok))// se la frequenza e nei limiti
						{
								param.pll_state = DQPLL_GRID_STATE_CONNECTING;  // va subito in Connecting
								dqpll_ctrl->dqpll_state = DQPLL_GRID_STATE_CONNECTING;  // va subito in Connecting
								param.cabcd_fault &= ~FAULT_DQPLL_GRID_SYNC;    // abbassa il bit del fault PLL
								aggancio_pll_ContaFault = 0;               // Metto a zero il contatore perche vado in Run
						}
					else
						{
							param.cabcd_fault |= FAULT_DQPLL_GRID_SYNC;    // alza il bit del fault PLL
							param.pll_state = DQPLL_GRID_STATE_START;      // rimane nello stato
							dqpll_ctrl->dqpll_state = DQPLL_GRID_STATE_START; 
						}
				}
		   else
		       aggancio_pll_ContaFault++;

		   if(aggancio_pll_ContaFault >= AGGANCIO_PLL_CONTAFAULT_WINDOW1)
			{
				aggancio_pll_ContaFault = 0;
				param.pll_state = DQPLL_GRID_STATE_START; // rimane nello stato
				dqpll_ctrl->dqpll_state = DQPLL_GRID_STATE_START; // rimane nello stato
			}
		break;

		case DQPLL_GRID_STATE_CONNECTING:

			omega_i_hat_tilde = dqpll_ctrl->omega_i_hat - omega_i_hat;
			if ((dqpll_ctrl->omega_hat > OMEGA_HAT_WINDOW2) || (dqpll_ctrl->omega_hat < -OMEGA_HAT_WINDOW2))          // la frequenza stimata deve superare una certa soglia
			{
		                    if ((omega_i_hat_tilde < param.pll_lim_ok) && (omega_i_hat_tilde > -param.pll_lim_ok))
								{  // se la frequenza e nei limiti
									param.pll_state = DQPLL_GRID_STATE_CONNECTING; // rimane in run
									dqpll_ctrl->dqpll_state = DQPLL_GRID_STATE_CONNECTING; // rimane in run
								}
		                    else
								{
									param.pll_state = DQPLL_GRID_STATE_FAULT;      // va subito in fault ma sarebbe meglio inserire un contatore di attesa
									dqpll_ctrl->dqpll_state = DQPLL_GRID_STATE_FAULT;      // va subito in fault ma sarebbe meglio inserire un contatore di attesa
									param.cabcd_fault |= FAULT_DQPLL_GRID_SYNC;    // alza il bit del fault PLL
								}
		                }
		                else
		                {
		                     aggancio_pll_ContaFault_RUN++;
		                }

		                if(aggancio_pll_ContaFault_RUN >= AGGANCIO_PLL_CONTAFAULT_WINDOW2 )
							{
								param.pll_state = DQPLL_GRID_STATE_FAULT;
								dqpll_ctrl->dqpll_state = DQPLL_GRID_STATE_FAULT;
								aggancio_pll_ContaFault_RUN = 0;
								param.cabcd_fault |= FAULT_DQPLL_GRID_SYNC;                 // alza il bit del fault PLL
							}

		                if (param.cabcd_global_state == CABCD_STATE_ZVS_RUN )    // se il pfc va in RUN
							{
								param.pll_state = DQPLL_GRID_STATE_RUN;
								dqpll_ctrl->dqpll_state = DQPLL_GRID_STATE_RUN;
								aggancio_pll_ContaFault_RUN = 0;
							}
		break;


		case DQPLL_GRID_STATE_RUN:
		omega_i_hat_tilde = dqpll_ctrl->omega_i_hat - omega_i_hat;
		if ((dqpll_ctrl->omega_hat > OMEGA_HAT_WINDOW2) || (dqpll_ctrl->omega_hat < -OMEGA_HAT_WINDOW2))    // la frequenza stimata deve superare una certa soglia
			{
			    if ((omega_i_hat_tilde < param.pll_lim_ok) && (omega_i_hat_tilde > -param.pll_lim_ok))
					{  // se la frequenza ï¿½ nei limiti
						param.pll_state = DQPLL_GRID_STATE_RUN; // rimane in run
						dqpll_ctrl->dqpll_state = DQPLL_GRID_STATE_RUN; // rimane in run
					}
			    else
					{
						param.pll_state = DQPLL_GRID_STATE_FAULT; // va subito in fault ma sarebbe meglio inserire un contatore di attesa
						dqpll_ctrl->dqpll_state = DQPLL_GRID_STATE_FAULT; // va subito in fault ma sarebbe meglio inserire un contatore di attesa
						param.cabcd_fault |= FAULT_DQPLL_GRID_SYNC; // alza il bit del fault PLL
					}
			}
			else
				{
					aggancio_pll_ContaFault_RUN++;
				}

			if(aggancio_pll_ContaFault_RUN >= AGGANCIO_PLL_CONTAFAULT_WINDOW2 )
				{
					param.pll_state = DQPLL_GRID_STATE_FAULT;
					dqpll_ctrl->dqpll_state = DQPLL_GRID_STATE_FAULT;
					aggancio_pll_ContaFault_RUN = 0;
					param.cabcd_fault |= FAULT_DQPLL_GRID_SYNC; // alza il bit del fault PLL
				}

			if (param.cabcd_global_state < CABCD_STATE_ZVS_RUN )    // se il PFC esce dal RUN
				{
					param.pll_state = DQPLL_GRID_STATE_STOP;
					dqpll_ctrl->dqpll_state = DQPLL_GRID_STATE_STOP;
				}
			break;
	}

	return gamma_hat;
}

