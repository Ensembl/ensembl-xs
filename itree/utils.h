/*
 * Libitree: an interval tree library in C
 *
 * Copyright [1999-2015] Wellcome Trust Sanger Institute and the
 * EMBL-European Bioinformatics Institute
 * Copyright [2016-2022] EMBL-European Bioinformatics Institute
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 * http://www.apache.org/licenses/LICENSE-2.0
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
*/

#ifndef _UTILS_H_
#define _UTILS_H_

#ifdef __cplusplus
#include <cmath>
#include <cfloat>
#include <cstdbool>

using std::size_t;

extern "C" {
#else
#include <math.h>
#include <float.h>
#include <stdbool.h>
#endif

#define BIGRND 0x7fffffff

typedef unsigned int uint;

/* Generate a random number between 0.0 and 1.0 */
double rnd01() {
  return ((double) random() / (double) BIGRND);
}

/* Generate a random number between -1.0 and +1.0 */
double nrnd01() {
  return ((rnd01() * 2.0) - 1.0);
}

/*
 * From http://floating-point-gui.de, Michael Borgwardt
 *
 * A presumably good method for comparing floating-point values using precision.
 *
 */
/* bool nearly_equal(float a, float b, float epsilon) { */
/*   float abs_a = fabs ( a ); */
/*   float abs_b = fabs ( b ); */
/*   float diff  = fabs ( a - b ); */

/*   if ( a == b ) // shortcut, handles infinities *\/ */
/*     return true; */
/*   else if ( a == 0 || b == 0 ||  ( abs_a + abs_b < FLT_MIN ) )  */
/*     /\* a or b is zero or both are extremely close to it */
/*        relative error is less meaningful here *\/ */
/*     return diff < ( epsilon * FLT_MIN ); */
/*   else /\* use relative error *\/ */
/*     return diff / fmin( (abs_a + abs_b), FLT_MAX ) < epsilon; */
/* } */

#endif /* _UTILS_H_ */
