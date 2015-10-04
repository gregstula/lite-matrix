//
//  lite_matrix_lookup.c
//  LiteMatrixTest2
//
// LiteMatrix C API
//
//  Created by Gregory D. Stula on 10/3/15.
//  Copyright © 2015 Gregory D. Stula. All rights reserved.
//

#include <stdio.h>
#include <stdlib.h>
#include <stdbool.h>
#include <assert.h>
#include <objc/NSObjCRuntime.h>

#include "lite_matrix_lookup.h"

// Private Prototypes;
bool LCLM_index_is_valid_for(lite_matrix_lookup_table *internal_lookup, NSInteger row, NSInteger col);


typedef struct lite_matrix_lookup_table {// The 2D array
    void*** table;
    NSInteger col_capacity;
    NSInteger row_capacity;
} lite_matrix_lookup_table;



lite_matrix_lookup_table* LCLM_alloc_lookup_table(NSInteger row_capacity, NSInteger col_capacity)
{
    lite_matrix_lookup_table *internal_lookup = malloc(sizeof(lite_matrix_lookup_table));
    
    internal_lookup->row_capacity = row_capacity;
    internal_lookup->col_capacity = col_capacity;
    
    // dynamically alloc 2D array
    internal_lookup->table = malloc(row_capacity * sizeof(void **));
    
    for (int i = 0; i < row_capacity; i++) {
        internal_lookup->table[i] = malloc(col_capacity * sizeof(void* ));
    }
    
    for (int i = 0; i < row_capacity; i++) {
        for (int j = 0; j < col_capacity; j++) {
            internal_lookup->table[i][j] = NULL;
        }
    }
    
    return internal_lookup;
}


// This should only be used at initialization internally in LiteMatrix.swift
void LCLM_insert_object_at_index
(lite_matrix_lookup_table* internal_lookup, NSInteger row, NSInteger col, void* object)
{
    assert(LCLM_index_is_valid_for(internal_lookup, row, col));
    internal_lookup->table[row][col] = object;
}


void* LCLM_access_object_at_index
(lite_matrix_lookup_table* internal_lookup, NSInteger row, NSInteger col)
{
    //assert(LCLM_index_is_valid_for(internal_lookup, row, col));
    return internal_lookup->table[row][col];
}


NSInteger LCLM_get_col_capacity(lite_matrix_lookup_table *internal_lookup)
{
    return internal_lookup->col_capacity;
}


NSInteger LCLM_get_row_capacity(lite_matrix_lookup_table *internal_lookup)
{
    return internal_lookup->row_capacity;
}


bool LCLM_index_is_valid_for(lite_matrix_lookup_table *internal_lookup, NSInteger row, NSInteger col)
{
    return (row >=0 && row < internal_lookup->row_capacity) && (col >=0 && col < internal_lookup->col_capacity);
}


// Must be called manually by Swift wrapper
void LCLM_dealloc_lookup_table(lite_matrix_lookup_table *internal_lookup)
{
        for (int j = 0; j < internal_lookup->col_capacity; j++) {
            free(internal_lookup->table);
        }
        free(internal_lookup->table);
        free(internal_lookup);
}