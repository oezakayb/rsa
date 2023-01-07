#include "extended_euclidean.h"

struct tuple compute_d(unsigned long N, unsigned long e) {
	int loop_counter = 0;
	if (e == 0) {
		struct tuple result;
		result.s = 1;
		result.t = 0;
		return result;
	} else {
		struct tuple extension = compute_d(e, N % e);
		struct tuple result;
		result.s = extension.t;
		result.t = extension.s - (N / e) * extension.t;
		return result;
	}
}
