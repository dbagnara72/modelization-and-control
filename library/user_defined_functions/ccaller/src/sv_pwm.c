#include <sv_pwm.h>

void sv_pwm_process(SVPWM *c)
{
	float ref_a, ref_b, t1, t2, t0;
	unsigned int pwm_sector;
	
	const float tbpwm = 1.0F;

	if (c->enable)
	{
		if (c->ua >= 0)
			ref_a = c->ua * MATH_SQRT3_2;
		else
			ref_a = c->ua * -MATH_SQRT3_2;

		if (c->ub >= 0)
			ref_b = c->ub * 0.5;
		else
			ref_b = c->ub * -0.5;

		if (ref_a >= ref_b)
		{
			if (c->ua >= 0)
			{
				if (c->ub >= 0) 
				{
					pwm_sector = 0;
					t2 = c->ub * MATH_2_SQRT3;
					t1 = c->ua - c->ub * MATH_1_SQRT3;
					t0 = 1.0 - t2 - t1;

					if (t0 > 0) 
					{
						c->du = (t0 * tbpwm * 0.5); 		                   
						c->dv = (t1 * tbpwm) + c->du;
						c->dw = (t2 * tbpwm) + c->dv;
					}
					else 
					{
						t1 = t1 / (t1 + t2);
						c->du = 0;
						c->dv = (t1 * tbpwm);
						c->dw = tbpwm + 2 * c->ts;
					}
				}
				else 
				{
					pwm_sector = 5;
					t1 = c->ua + c->ub * MATH_1_SQRT3;
					t2 = (c->ua - t1) * 0.5 - c->ub * MATH_SQRT3_2;
					t0 = 1.0 - t2 - t1;

					if (t0 > 0) 
					{
						c->du = (t0 * 0.5);
						c->dw = (t1 * tbpwm) + c->du;
						c->dv = (t2 * tbpwm) + c->dw;
					}
					else 
					{
						t1 = t1 / (t1 + t2);
						c->du = 0;
						c->dw = (t1 * tbpwm);
						c->dv = tbpwm + 2 * c->ts;
					}
				}
			}
			else {
				if (c->ub >= 0) 
				{
					pwm_sector = 2;
					t2 = c->ub * -MATH_1_SQRT3 - c->ua;
					t1 = c->ub * MATH_SQRT3_2 - (c->ua + t2) * 0.5;
					t0 = 1.0 - t2 - t1;

					if (t0 > 0) 
					{
						c->dv = (t0 * tbpwm * 0.5);
						c->dw = (t1 * tbpwm) + c->dv;
						c->du = (t2 * tbpwm) + c->dw;
					}
					else 
					{
						t1 = t1 / (t1 + t2);
						c->dv = 0;
						c->dw = (t1 * tbpwm);
						c->du = tbpwm + 2 * c->ts;
					}
				}
				else 
				{
					pwm_sector = 3;
					t1 = c->ub * -MATH_2_SQRT3;
					t2 = c->ub * MATH_1_SQRT3 - c->ua;
					t0 = 1.0 - t2 - t1;

					if (t0 > 0) 
					{
						c->dw = (t0 * tbpwm * 0.5);
						c->dv = (t1 * tbpwm) + c->dw;
						c->du = (t2 * tbpwm) + c->dv;
					}
					else 
					{
						t1 = t1 / (t1 + t2);
						c->dw = 0;
						c->dv = (t1 * tbpwm);
						c->du = tbpwm + 2 * c->ts;
					}
				}
			}
		}
		else 
		{
			if (c->ub >= 0) 
			{
				pwm_sector = 1;
				t1 = c->ub * MATH_1_SQRT3 - c->ua;
				t2 = (c->ua - t1) * 0.5 + c->ub * MATH_SQRT3_2;
				t0 = 1.0 - t2 - t1;

				if (t0 > 0) 
				{
					c->dv = (t0 * tbpwm * 0.5);
					c->du = (t1 * tbpwm) + c->dv;
					c->dw = (t2 * tbpwm) + c->du;
				}
				else 
				{
					t1 = t1 / (t1 + t2);
					c->dv = 0;
					c->du = (t1 * tbpwm);
					c->dw = tbpwm + 2 * c->ts;
				}
			}
			else 
			{
				pwm_sector = 4;
				t2 = c->ua - c->ub * MATH_1_SQRT3;
				t1 = (c->ua + t2) * -0.5 - c->ub * MATH_SQRT3_2;
				t0 = 1.0 - t2 - t1;

				if (t0 > 0) 
				{
					c->dw = (t0 * tbpwm * 0.5);
					c->du = (t1 * tbpwm) + c->dw;
					c->dv = (t2 * tbpwm) + c->du;
				}
				else 
				{
					t1 = t1 / (t1 + t2);
					c->dw = 0;
					c->du = (t1 * tbpwm);
					c->dv = tbpwm + 2 * c->ts;
				}
			}
		}
	}
	else
	{
		c->du = 0.5; 		                   
		c->dv = 0.5;
		c->dw = 0.5;
	}

}

	