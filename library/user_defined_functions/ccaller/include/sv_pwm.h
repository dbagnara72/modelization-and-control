#ifndef _SV_PWM_
#define _SV_PWM_

#include <sv_pwm.h>

#define MATH_2_SQRT3				1.15470053837925
#define MATH_1_2PI					0.15915494309189
#define MATH_SQRT3_2				0.86602540378443
#define MATH_SQRT_3_2				1.22474487139159
#define MATH_1_SQRT3				0.57735026918962

typedef struct sv_pwm_s 
{
	float	ts;
	float	ua;
	float 	ub;
	float	du;
	float	dv;
	float	dw;
	unsigned int enable;
} sv_pwm_t;

#define SVPWM sv_pwm_t

void sv_pwm_process(SVPWM *c);

#endif