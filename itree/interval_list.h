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

#ifndef _INTERVAL_LIST_H_
#define _INTERVAL_LIST_H_

#ifdef __cplusplus
#include <cstddef>

using std::size_t;

extern "C" {
#else
#include <stddef.h>
#endif

#include "interval.h"

/* Declarations for an interval list, opaque types */
typedef struct ilist ilist_t;
typedef struct ilisttrav ilisttrav_t;

/* Interval list functions */
ilist_t     *ilist_new ();
void        ilist_delete ( ilist_t* );
size_t      ilist_size ( ilist_t* );
int         ilist_append ( ilist_t*, interval_t* );

/* Interval list traversal functions */
ilisttrav_t *ilisttrav_new ( ilist_t* );
void        ilisttrav_delete ( ilisttrav_t *trav );
const interval_t  *ilisttrav_first ( ilisttrav_t *trav );
const interval_t  *ilisttrav_last ( ilisttrav_t *trav );
const interval_t  *ilisttrav_next ( ilisttrav_t *trav );
const interval_t  *ilisttrav_prev ( ilisttrav_t *trav );

#ifdef __cplusplus
}
#endif

#endif /* _INTERVAL_LIST_H_ */
