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

@property (nonatomic) NSUInteger rowCapacity;
@property (nonatomic) NSUInteger colCapacity;
@property (nonatomic) NSMutableArray *arrayOfObjects;
@property (nonatomic) NSString *warining;

@end

#pragma mark - Initializers

@implementation ObjcLiteMatrix

// Designated initializer
- (instancetype)initWithRowSize:(NSNumber *)NSNRow withColumnSize:(NSNumber *)NSNCol
{
    
    self = [super init];
    
    int row = NSNRow.intValue;
    int col = NSNCol.intValue;
    
    if (self) {
        
        // set capacity
        _rowCapacity = row;
        _colCapacity = col;
        
       _warining = [NSString stringWithFormat:@"Index out of range at Objective-C level! row max:%lu column max:%lu",(unsigned long)_rowCapacity, (unsigned long)_colCapacity];
    
        // dynamically allocate the C-style array used to to hold dumb pointers to objects
        _array = (void ***)malloc(row * sizeof(void **));
        
        for (int j = 0; j < col; j++) {
            _array[j] = (void *)malloc(col * sizeof(void *));
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
    int row = NSNRow.intValue;
    int col = NSNCol.intValue;
    
    NSAssert([self indexInValidForRow:row column:col], _warining);
    
    return (__bridge id)_array[row][col];
}

#pragma mark - Mutators

- (void)addObjectToMatrixAtIndex:(id)object row:(NSNumber*)NSNRow column:(NSNumber*)NSNCol
{
    int row = NSNRow.intValue;
    int col = NSNCol.intValue;
    
    NSAssert([self indexInValidForRow:row column:col], _warining);
    
    [self.arrayOfObjects insertObject:object atIndex:row * col];
    _array[row][col] = (__bridge void *)object;
}



- (void)replaceObjectInMatrixAtIndex:(id)object row:(NSNumber*)NSNRow column:(NSNumber*)NSNCol
{
    int row = NSNRow.intValue;
    int col = NSNCol.intValue;
    
    NSAssert([self indexInValidForRow:row column:col], _warining);
    
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
