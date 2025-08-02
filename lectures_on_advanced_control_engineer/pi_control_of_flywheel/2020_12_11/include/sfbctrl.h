#ifndef _SFBCTRL_
#define _SFBCTRL_

#define a11		1.0
#define a12		0.001

#define a21		0.0
#define a22		1.0

#define b1		0.0
#define b2		0.001

#define c1		0.0055
#define c2		0.0

#define l1		0.247929107867307
#define l2		1.64188743820755

#define k1		2
#define k2		3

#define n		16.6666666666667

#define uc_max	12.0

typedef struct sobvctrl_s {
	float		x1_hat;			
	float		x2_hat;					
	float		xp_hat;					
} sobvctrl_t;
#define SOBVCTRL sobvctrl_t

void sobvReset(SOBVCTRL *obv);

float sobvProcess(SOBVCTRL *obv, float uc, float xp);

float sfbProcess(SOBVCTRL *obv, float xp_ref);

void sfbProcessSimulink(float xp_ref, float xp, float reset, float *uc, float *xp_hat);

#endif
