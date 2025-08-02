#ifndef _SVCM_PWM_SIMULINK_
#define _SVCM_PWM_SIMULINK_

typedef struct svcm_pwm_output_s {
	float	m_u;
	float	m_v;
	float	m_w;
} svcm_pwm_output_t;
#define SVCM_PWM_OUTPUT svcm_pwm_output_t

SVCM_PWM_OUTPUT svcm_pwm_process_simulink(const float ua, const float ub, const float ucm, const float ts, unsigned int enable);

#endif