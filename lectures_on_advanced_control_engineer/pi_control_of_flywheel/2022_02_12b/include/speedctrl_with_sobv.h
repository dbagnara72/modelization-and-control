#ifndef _CTRL_
#define _CTRL_

#define ts          0.001

#define ae11		1.0
#define ae12		0.001
#define ae13		0.0

#define ae21		0.0
#define ae22		1.0
#define ae23		-0.001

#define ae31		0.0
#define ae32		0.0
#define ae33		1.0

#define be1		0.0
#define be2		0.001
#define be3		0.0

#define ce1		1.0
#define ce2		0.0
#define ce3		0.0

#define le1		2.052734441579463
#define le2		1265.733547807589
#define le3		-211635.1210315072

#define kp		31.41592653589793
#define ki		314.1592653589793

typedef struct sobvctrl_s {
	float		x1_hat;			
	float		x2_hat;					
	float		x3_hat;					
	float		omega_hat;					
	float		tau_load_hat;					
} sobvctrl_t;
#define SOBVCTRL sobvctrl_t

typedef struct pictrl_s {
	float		tau_m_i;			
	float		tau_m;			
} pictrl_t;
#define PICTRL pictrl_t

void sobvReset(SOBVCTRL *obv);

void piReset(PICTRL *pi);

void sobvProcess(SOBVCTRL *obv, float tau_m, float theta);

void piProcess(PICTRL *pi, float omega_ref, float omega_hat, float tau_load_hat);

void ctrlSimulink(float omega_ref, float theta, float reset, 
        float *tau_m, float *omega_hat, float *tau_load_hat);

#endif
