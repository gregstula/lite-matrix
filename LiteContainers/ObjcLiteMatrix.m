// ObjcLiteMatrix
// ObjcLiteMatrix.m
//
// Created by Gregory D. Stula on 9/1/15.
// Copyright (c) 2015 Gregory D. Stula. All rights reserved.
//
// Licence: The BSD 3-Clause License
// http://opensource.org/licenses/BSD-3-Clause

#import "ObjcLiteMatrix.h"

# pragma mark - private interface

@interface ObjcLiteMatrix() {
// The 2D array
void ***_array;
}

@property (nonatomic) NSInteger rowCapacity;
@property (nonatomic) NSInteger colCapacity;
@property (nonatomic) NSMutableArray *arrayOfObjects;
@property (nonatomic) NSString *warning;

@end

#pragma mark - Initializers

@implementation ObjcLiteMatrix

// Designated initializer
- (instancetype)initWithRowSize:(NSNumber *)NSNRow withColumnSize:(NSNumber *)NSNCol
{
    
    self = [super init];
    
    NSInteger row = NSNRow.integerValue;
    NSInteger col = NSNCol.integerValue;
    
    if (self) {
        
        // set capacity
        _rowCapacity = row;
        _colCapacity = col;
        
       _warning = [NSString stringWithFormat:@"Index out of range at Objective-C level! row max:%lu column max:%lu",(unsigned long)_rowCapacity, (unsigned long)_colCapacity];
    
        // dynamically allocate the C-style array used to to hold dumb pointers to objects
        _array = (void ***)malloc(row * sizeof(void **));
        
        for (int i = 0; i < row; i++) {
            _array[i] = (void *)malloc(col * sizeof(void *));
        }
        
        // Allocate NSMutableArray with explicit capicity
        _arrayOfObjects = [[NSMutableArray alloc] initWithCapacity: row * col];
    }
        return row <= 0 || col <= 0 ? nil : self;
}


// Init
- (instancetype)init
{
   return nil;
}

#pragma mark - Precondition for bounds checking

// Checks that the parameters passed are in the bounds set by then initializer
- (bool)indexInValidForRow:(int)row column:(int)col {
    
    return (row >= 0 && row < _rowCapacity) && col >= 0 && col < _colCapacity;
}

#pragma mark - Accessor

- (id)accessObjectAtRow:(NSNumber *)NSNRow column:(NSNumber *)NSNCol
{
    NSInteger row = NSNRow.integerValue;
    NSInteger col = NSNCol.integerValue;
    
    NSAssert([self indexInValidForRow:row column:col], _warning);
    
    return (__bridge id)_array[row][col];
}

#pragma mark - Mutators

- (void)addObjectToMatrixAtIndex:(id)object row:(NSNumber*)NSNRow column:(NSNumber*)NSNCol
{
    NSInteger row = NSNRow.integerValue;
    NSInteger col = NSNCol.integerValue;
    
    NSAssert([self indexInValidForRow:row column:col], _warning);
    
    [self.arrayOfObjects addObject:object];
    _array[row][col] = (__bridge void *)object;
}



- (void)replaceObjectInMatrixAtIndex:(id)object row:(NSNumber*)NSNRow column:(NSNumber*)NSNCol
{
    NSInteger row = NSNRow.integerValue;
    NSInteger col = NSNCol.integerValue;
    
    NSAssert([self indexInValidForRow:row column:col], _warning);
    
    free(_array[row][col]);
    _array[row][col] = NULL;
    
    [self.arrayOfObjects replaceObjectAtIndex:row * col withObject:object];
    
    _array[row][col] = (__bridge void*)object;
    
}

#pragma mark - dealloc

// Free what you malloc
- (void)dealloc
{
    for (int j = 0; j < _colCapacity; j++) {
        free(_array[j]);
    }
    free(_array);
}

@end
