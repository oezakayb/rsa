#include "extended_euclidean.h"

 void compute_d(unsigned long N, unsigned long e, signed long* s, signed long* t) {
	//int loop_counter = 0;
	//if (e == 0) {
	//	struct tuple result;
	//	result.s = 1;
	//	result.t = 0;
	//	return result;
	//} else {
	//	struct tuple extension = compute_d(e, N % e);
	//	struct tuple result;
	//	result.s = extension.t;
	//	result.t = extension.s - (N / e) * extension.t;
	//	return result;
	//}

    if (e == 0) {
        *s = 1;
        *t = 0;
    } else {
        compute_d(e, N % e, s, t);
        signed long temp = *s;
        *s = *t;
        *t = temp - (N / e) * *t;
    }
}
