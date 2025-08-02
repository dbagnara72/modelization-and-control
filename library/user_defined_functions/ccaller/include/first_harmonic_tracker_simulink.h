#ifndef _FIRST_HARMONIC_TRACKER_SIMULINK_
#define _FIRST_HARMONIC_TRACKER_SIMULINK_

typedef struct first_harmonic_tracker_output_s {
	float					output_pu_hat;				/* output pu hat */
} first_harmonic_tracker_output_t;
#define FIRST_HARMONIC_TRACKER_OUTPUT first_harmonic_tracker_output_t

extern FIRST_HARMONIC_TRACKER first_harmonic_tracker_state;
extern unsigned int first_harmonic_tracker_state_initialized;

FIRST_HARMONIC_TRACKER_OUTPUT first_harmonic_tracker_process_simulink(unsigned char reset, const float u, const float ts);
#endif
