
#include <sv_pwm_simulink.h>
#include <sv_pwm.h>

// ------------------------------------------------------------------------------
SV_PWM_OUTPUT sv_pwm_process_simulink(const float ua, const float ub, const float ts, 
					unsigned int enable)
{
	static SVPWM ctrl = {0};

	ctrl.ua = ua;
	ctrl.ub = ub;
	ctrl.ts = ts;
	ctrl.enable = enable;

    sv_pwm_process(&ctrl);

	const SV_PWM_OUTPUT ctrl_out = {
		.m_u = ctrl.du,
		.m_v = ctrl.dv,
		.m_w = ctrl.dw
	};
	return ctrl_out;
}
