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

#ifndef _INTERVAL_TREE_H_
#define _INTERVAL_TREE_H_

/*
  Interval Tree library

  This is an adaptation of the AVL balanced tree C library
  created by Julienne Walker which can be found here:

  http://www.eternallyconfuzzled.com/Libraries.aspx

*/
#ifdef __cplusplus
#include <cstddef>

using std::size_t;

extern "C" {
#else
#include <stddef.h>
#endif

#include "interval.h"
#include "interval_list.h"
  
/* Opaque types */
typedef struct itree itree_t;
typedef struct itreetrav itreetrav_t;

/* Interval tree functions */
itree_t    *itree_new ( dup_f dup, rel_f rel );
void       itree_delete ( itree_t *tree );
interval_t *itree_find ( itree_t *tree, interval_t *interval );
ilist_t    *itree_findall ( itree_t *tree, interval_t *interval );
int        itree_insert ( itree_t *tree, interval_t *interval );
int        itree_remove ( itree_t *tree, interval_t *interval );
size_t     itree_size ( itree_t *tree );

/* Tree traversal functions */
itreetrav_t *itreetnew ( void );
void        itreetdelete ( itreetrav_t *trav );
interval_t  *itreetfirst ( itreetrav_t *trav, itree_t *tree );
interval_t  *itreetlast ( itreetrav_t *trav, itree_t *tree );
interval_t  *itreetnext ( itreetrav_t *trav );
interval_t  *itreetprev ( itreetrav_t *trav );

#ifdef __cplusplus
}
#endif

#endif /* _INTERVAL_TREE_H_ */
