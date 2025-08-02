
#include <first_harmonic_tracker.h>
#include <first_harmonic_tracker_simulink.h>

FIRST_HARMONIC_TRACKER first_harmonic_tracker_state = {0.0F};
unsigned int first_harmonic_tracker_state_initialized = 0;

// ------------------------------------------------------------------------------
FIRST_HARMONIC_TRACKER_OUTPUT first_harmonic_tracker_process_simulink(unsigned char reset, const float u, const float ts)
{

	if (!first_harmonic_tracker_state_initialized) {
	    first_harmonic_tracker_init(&first_harmonic_tracker_state);
		first_harmonic_tracker_state_initialized = 1;
	}

	first_harmonic_tracker_ts(&first_harmonic_tracker_state, ts);

	if (reset) {
		first_harmonic_tracker_reset(&first_harmonic_tracker_state);
	}
	
	const float output_value = first_harmonic_tracker_process(&first_harmonic_tracker_state, u);

	const FIRST_HARMONIC_TRACKER_OUTPUT output = {
		.output_pu_hat = first_harmonic_tracker_state.first_harmonic_tracker_output
	};
	return output;
}

