//
// LiteMatrix.swift
//
// Copyright (c) 2015, Gregory D. Stula
// All rights reserved.
//
// Licence: The BSD 3-Clause License
// http://opensource.org/licenses/BSD-3-Clause

import Foundation

class LiteMatrix<T: NSObject> {

    private let matrix: ObjcLiteMatrix
    let rowCapacity: Int
    let colCapacity: Int
    
    private var initializeTOnMatrixInit: Bool = true
    private var warning: String
    private var index = (x:0, y:0)
    
    
    // Designated initializer, initializes a matrix of unique objects
    init(rows: Int, columns cols: Int) {
        rowCapacity = rows
        colCapacity = cols
        matrix = ObjcLiteMatrix(rowSize:rows, withColumnSize:cols)
        warning = "Index out of range - row capacity: \(rowCapacity), col capacity: \(colCapacity)"
        if initializeTOnMatrixInit {
            for var i = 0; i < rowCapacity; i++ {
                for var j = 0; j < colCapacity; j++ {
                    matrix.addObjectToMatrixAtIndex(T() as AnyObject, row:i , column:j)
                }
            }
        }
    }


    // Initializes a Matrix of references to the same object
    /*init(row: Int, column col: Int, withRepeatedValue value:T) {
        rowCapacity = row
        colCapacity = col
        matrix = ObjcLiteMatrix(rowSize:row, withColumnSize:col)
        warning = "Index out of range - row capacity: \(rowCapacity), col capacity: \(colCapacity)"
        if initializeTOnMatrixInit {
            for var i = 0; i < rowCapacity; i++ {
                for var j = 0; j < colCapacity; j++ {
                    matrix.addObjectToMatrixAtIndex(value as AnyObject, row:i , column:j)
                }
            }
        }
    }
    */


    private func getObjectFromMatrixAtRow(row: Int, column col: Int) -> T {
        var nilWarning = "Nil returned from matrix at index \(row), \(col)"
        
        var obj = matrix.accessObjectAtRow(row, column: col) as? T
        assert(obj != nil, nilWarning)
        return obj!
    }
    
    
    private func setObjectInMatrixAtIndex(object: T, row: Int, column col: Int) {
        matrix.addObjectToMatrixAtIndex(object as AnyObject, row: row, column: col)
    }


    /* Debugging */
    private func updateWarning() {
        warning = "Index out of range - \(index) - row capacity: \(rowCapacity), col capacity: \(colCapacity)"
    }


     private func indexIsValidForRow(row: Int, column col: Int) -> Bool {
        return (row >= 0 && row < rowCapacity) && (col >= 0 && col < colCapacity)
    }


   // Subscript notation is the only public interface: exampleMatrix[1,2]
    subscript(row: Int, col: Int) -> T {
        
        get {
            //index = (x:row, y:col)
            //updateWarning()
            assert(indexIsValidForRow(row, column: col), warning)
            return getObjectFromMatrixAtRow(row, column: col)
        }
        set {
            //index = (row, col)
            //updateWarning()
            assert(indexIsValidForRow(row, column: col),warning)
            setObjectInMatrixAtIndex(newValue, row: row, column: col)
        }
    }
}
