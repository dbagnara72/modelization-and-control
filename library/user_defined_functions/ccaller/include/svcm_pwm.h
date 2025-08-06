#ifndef _SVCM_PWM_
#define _SVCM_PWM_

#include <math_f.h>

/*
#define MATH_2_SQRT3				1.15470053837925f
#define MATH_1_2PI					0.15915494309189f
#define MATH_SQRT3_2				0.86602540378443f
#define MATH_SQRT_3_2				1.22474487139159f
#define MATH_1_SQRT3				0.57735026918962f
*/

typedef struct svcm_pwm_s 
{
	float	ts;
	float	ua; /* u_alpha */
	float 	ub; /* u_beta */
	float 	ucm;
	float	du;
	float	dv;
	float	dw;
	unsigned int enable;
} svcm_pwm_t;

#define SVCMPWM svcm_pwm_t

void svcm_pwm_process(SVCMPWM *c);

#endif