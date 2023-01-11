/*
 * Libitree: an interval tree library in C
 *
 * Copyright [1999-2015] Wellcome Trust Sanger Institute and the
 * EMBL-European Bioinformatics Institute
 * Copyright [2016-2023] EMBL-European Bioinformatics Institute
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

#ifndef _INTERVAL_H_
#define _INTERVAL_H_

#ifdef __cplusplus
#include <cstddef>

using std::size_t;

extern "C" {
#else
#include <stddef.h>
#endif

#include <EXTERN.h>
#include <perl.h>
  
/* User-defined item handling */
typedef SV *(*dup_f) ( SV *p );
typedef void  (*rel_f) ( SV *p );

typedef struct interval {

  float  low, high; /* Interval boundaries, inclusive */
  SV   *data;     /* User-defined content */
  dup_f  dup;       /* Clone an interval data item */
  rel_f  rel;       /* Destroy an interval data item */

} interval_t;
  
/* Interval functions */
interval_t *interval_new ( float, float, SV*, dup_f, rel_f );
interval_t *interval_copy(const interval_t*);
void       interval_delete ( interval_t* );
int        interval_overlap ( const interval_t*, const interval_t* );
/*
 * WARNING
 *
 * Comparison of floating-point values does not guarantee the correct results
 * and is subject to machine-dependent behaviour.
 *
 * This is critical and needs to be revised.
 */
int        interval_equal ( const interval_t*, const interval_t* );
		   
#ifdef __cplusplus
}
#endif

#endif /* _INTERVAL_H_ */
