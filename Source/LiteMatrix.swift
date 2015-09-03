//
// LiteMatrix.swift
//
// Copyright (c) 2015, Gregory D. Stula
// All rights reserved.
//
// Licence: The BSD 3-Clause License
// http://opensource.org/licenses/BSD-3-Clause

import Foundation

class LiteMatrix<T> {

    let rowCapacity:Int
    let colCapacity:Int
    
    let matrix:ObjcLiteMatrix
    
    let warning:String
    

    // Designated initializer
    init(row:(Int), column col:(Int)) {
        rowCapacity = row
        colCapacity = col
       
        warning = "Index out of range - row capacity: \(rowCapacity), col capacity: \(colCapacity)"
        
        matrix = ObjcLiteMatrix(rowSize:row, withColumnSize:col)
    }
    
    
    // Checks that index is in bounds, at the swift level
    private func indexIsValidForRow(row:Int, column col:Int) -> Bool {
        return row >= 0 && row < rowCapacity && col >= 0 && col < colCapacity
    }
    
    
   // Getter
    private func getObjectFromMatrixAtRow(row:Int, column col:Int) -> T {
        var nilWarning = "Nil returned from matrix at index \(row), \(col)"
        
        var obj = matrix.accessObjectAtRow(row, column: col) as? T
        assert(obj != nil, nilWarning)
        return obj!
    }
    
    
   // Setter
    private func setObjectInMatrixAtIndex(object:T, row:Int, column col:Int) {
        matrix.addObjectToMatrixAtIndex(object as! AnyObject, row: row, column: col)
    }
    
    
   // subscript notation is the only public interface sample[1,2]
    subscript(row: Int, col: Int) -> T {
        
        get {
            assert(indexIsValidForRow(row, column: col), warning)
            return self.getObjectFromMatrixAtRow(row, column: col)
        }
        set {
            assert(indexIsValidForRow(row, column: col),warning)
            self.setObjectInMatrixAtIndex(newValue, row: row, column: col)
        }
    }
}