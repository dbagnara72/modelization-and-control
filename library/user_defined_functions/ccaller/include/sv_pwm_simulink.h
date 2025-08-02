#ifndef _SV_PWM_SIMULINK_
#define _SV_PWM_SIMULINK_

typedef struct sv_pwm_output_s {
	float	m_u;
	float	m_v;
	float	m_w;
} sv_pwm_output_t;
#define SV_PWM_OUTPUT sv_pwm_output_t

SV_PWM_OUTPUT sv_pwm_process_simulink(const float ua, const float ub, const float ts, unsigned int enable);

#endif