//
//  lite_lookup.h
//  LiteMatrixTest2
//
//  Created by Gregory D. Stula on 10/3/15.
//  Copyright © 2015 Gregory D. Stula. All rights reserved.
//

#ifndef lite_lookup_h
#define lite_lookup_h
#include <objc/NSObjCRuntime.h>

typedef struct lite_matrix_lookup_table lite_matrix_lookup_table;

lite_matrix_lookup_table* LCLM_alloc_lookup_table(NSInteger row_capacity, NSInteger col_capacity);

void LCLM_dealloc_lookup_table(lite_matrix_lookup_table *intenal_lookup);

void* LCLM_access_object_at_index
(lite_matrix_lookup_table* internal_lookup, NSInteger row, NSInteger col);

void LCLM_insert_object_at_index
(lite_matrix_lookup_table* internal_lookup, NSInteger row, NSInteger col, void* object);

NSInteger LCLM_get_col_capacity(lite_matrix_lookup_table *internal_lookup);
NSInteger LCLM_get_row_capacity(lite_matrix_lookup_table *internal_lookup);

#endif /* lite_lookup_h */
