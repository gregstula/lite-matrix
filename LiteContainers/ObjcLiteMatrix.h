// ObjcLiteMatrix.h
//
// Created by Gregory D. Stula on 9/1/15.
// Copyright (c) 2015 Gregory D. Stula. All rights reserved.
//
// Licence: The BSD 3-Clause License
// http://opensource.org/licenses/BSD-3-Clause

#import <Foundation/Foundation.h>

@interface ObjcLiteMatrix : NSObject

@property (readonly, nonatomic) NSInteger rowCapacity;
@property (readonly, nonatomic) NSInteger colCapacity;

- (instancetype)initWithRowSize:(NSNumber*)NSNRow withColumnSize:(NSNumber*)NSNCol;
- (void)addObjectToMatrixAtIndex:(id)object row:(NSNumber*)NSNRow column:(NSNumber*)NSNCol;
- (id)accessObjectAtRow:(NSNumber*)NSNrow column:(NSNumber*)NSNCol;
- (void)replaceObjectInMatrixAtIndex:(id)object row:(NSNumber*)NSNRow column:(NSNumber*)NSNCol;

@end