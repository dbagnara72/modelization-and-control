
#include <svcm_pwm_simulink.h>
#include <svcm_pwm.h>

// ------------------------------------------------------------------------------
SVCM_PWM_OUTPUT svcm_pwm_process_simulink(const float ua, const float ub, const float ucm, const float ts, 
					unsigned int enable)
{
	static SVCMPWM ctrl = {0};

	ctrl.ua = ua;
	ctrl.ub = ub;
	ctrl.ucm = ucm;
	ctrl.ts = ts;
	ctrl.enable = enable;

    svcm_pwm_process(&ctrl);

	const SVCM_PWM_OUTPUT ctrl_out = {
		.m_u = ctrl.du,
		.m_v = ctrl.dv,
		.m_w = ctrl.dw
	};
	return ctrl_out;
}
