
#include <svpwm_simulink.h>
#include <svpwm.h>

// ------------------------------------------------------------------------------
SVPWM_OUTPUT svpwm_process_simulink(const float ualpha, const float ubeta, const float ts,
					unsigned int enable)
{
	static SVPWM ctrl = {0};

	ctrl.ualpha = ualpha;
	ctrl.ubeta = ubeta;
	ctrl.ts = ts;
	ctrl.enable = enable;

    svpwm_process(&ctrl);

	const SVPWM_OUTPUT ctrl_out = {
		.da = ctrl.da,
		.db = ctrl.db,
		.dc = ctrl.dc
	};
	return ctrl_out;
}
