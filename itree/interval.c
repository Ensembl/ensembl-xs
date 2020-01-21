/*
 * Libitree: an interval tree library in C 
 *
 * Copyright [1999-2015] Wellcome Trust Sanger Institute and the 
 * EMBL-European Bioinformatics Institute
 * Copyright [2016-2020] EMBL-European Bioinformatics Institute
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

#include "interval.h"

#ifdef __cplusplus
#include <cstdlib>

using std::malloc;
using std::free;
using std::size_t;
#else
#include <stdlib.h>
#include <stdio.h>
#endif

interval_t *interval_new ( float low, float high, SV *data, dup_f dup, rel_f rel ) {
  interval_t *ri = (interval_t*) malloc ( sizeof *ri );

  if ( ri == NULL )
    return NULL;

  ri->low = low;
  ri->high = high;
  ri->dup = dup;
  ri->rel = rel;
  ri->data = ri->dup( data );

  return ri;
}

interval_t *interval_copy ( const interval_t *i ) {
  return interval_new ( i->low, i->high, i->data, i->dup, i->rel );
}

void interval_delete ( interval_t *i ) {
  if ( i != NULL ) {
    if ( i->data ) i->rel ( i->data );
    free ( i );
  }

}

int interval_overlap(const interval_t* i1, const interval_t* i2) {
  return i1->low <= i2->high && i2->low <= i1->high;
}

/*
 * WARNING
 *
 * Comparison of floating-point values does not guarantee the correct results
 * and is subject to machine-dependent behaviour.
 *
 * This is critical and needs to be revised.
 */
int interval_equal(const interval_t* i1, const interval_t* i2) {
  return i1->low == i2->low && i1->high == i2->high;
}
