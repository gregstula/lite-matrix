// ObjcLiteMatrix
// ObjcLiteMatrix.m
//
// Created by Gregory D. Stula on 9/1/15.
// Copyright (c) 2015 Gregory D. Stula. All rights reserved.
//
// Licence: The BSD 3-Clause License
// http://opensource.org/licenses/BSD-3-Clause

#import "ObjcLiteMatrix.h"
#import "lite_matrix_lookup.h"

# pragma mark - private interface
@interface ObjcLiteMatrix() {
    lite_matrix_lookup_table *internal_matrix;
}

@property (nonatomic) NSInteger rowCapacity;
@property (nonatomic) NSInteger colCapacity;
@property (nonatomic) NSString *warning;
@property (nonatomic) NSMutableArray *arrayOfObjects;

// Debugging
@property (nonatomic) NSInteger arg1Value;
@property (nonatomic) NSInteger arg2Value;

@end


#pragma mark - Initializers
@implementation ObjcLiteMatrix

# define ERR_F -1
// Designated initializer
- (instancetype)initWithRowSize:(NSInteger)rowSize withColumnSize:(NSInteger)colSize
{
    
    self = [super init];
    
    if (self) {
        
        // set capacity
        _rowCapacity = rowSize;
        _colCapacity = colSize;
        
        _arg1Value = ERR_F;
        _arg2Value = ERR_F;
        
        
        // dynamically allocate the C-style array used to to hold dumb pointers to objects
        internal_matrix = LCLM_alloc_lookup_table(rowSize, colSize);
        
    }
    
    return _rowCapacity <= 0 || _colCapacity <= 0 ? nil : self;
}


// Init
- (instancetype)init
{
    return nil;
}


- (NSString *)warning
{
    _warning = [NSString stringWithFormat:@"Index out of range at Objective-C level! row max:%lu column max:%lu arg1:%lu arg2:%lu",(unsigned long)_rowCapacity, (unsigned long)_colCapacity, _arg1Value != ERR_F ? _arg1Value : 0, _arg2Value != ERR_F ? _arg2Value : 0];
    
    return _warning;
}


#pragma mark - Precondition for bounds checking
// Checks that the parameters passed are in the bounds set by then initializer
- (bool)indexInValidForRow:(NSInteger)row column:(NSInteger)col
{
    return (row >= 0 && row < _rowCapacity) && (col >= 0 && col < _colCapacity);
}


#pragma mark - Accessor
- (id)accessObjectAtRow:(NSInteger)row column:(NSInteger)col
{
    // Debug
    self.arg1Value = row;
    self.arg2Value = col;
    
    NSAssert([self indexInValidForRow:row column:col], self.warning);
    
    return (__bridge id)LCLM_access_object_at_index(internal_matrix, row, col);
}


#pragma mark - Mutators
- (void)addObjectToMatrixAtIndex:(id)object row:(NSInteger)row column:(NSInteger)col
{
    // Debug
    self.arg1Value = row;
    self.arg2Value = col;
    
    NSAssert([self indexInValidForRow:row column:col], self.warning);
    
    [self.arrayOfObjects insertObject:object atIndex:row * col];
    LCLM_insert_object_at_index(internal_matrix, row, col, (__bridge void*)object);
}


#pragma mark - dealloc
// Free what you malloc
- (void)dealloc
{
    LCLM_dealloc_lookup_table(internal_matrix);
}

@end

