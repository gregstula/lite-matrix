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
        
        matrix = ObjcLiteMatrix(rowSize: rows, withColumnSize: cols)
        warning = "Index out of range - row capacity: \(rowCapacity), col capacity: \(colCapacity)"
       
        for i in 0..<rowCapacity {
            for j in 0..<colCapacity {
                matrix.addObjectToMatrixAtIndex(T() as AnyObject, row:i , column:j)
            }
        }
    }


    // Initializes a Matrix of references to the same object
    init(row: Int, column col: Int, withRepeatedValue value: T) {
        rowCapacity = row
        colCapacity = col
        
        matrix = ObjcLiteMatrix(rowSize: row, withColumnSize: col)
        warning = "Index out of range - row capacity: \(rowCapacity), col capacity: \(colCapacity)"
        
        for i in 0..<rowCapacity {
            for j in 0..<colCapacity {
                matrix.addObjectToMatrixAtIndex(value as AnyObject, row:i , column:j)
            }
        }
    }
    
    
    // Double subscript notation is the only public interface: exampleMatrix[1,2]
    subscript(row: Int, col: Int) -> T {
        get {
            assert(indexIsValidForRow(row, column: col), warning)
            return getObjectFromMatrixAtRow(row, column: col)
        }
        set {
            assert(indexIsValidForRow(row, column: col),warning)
            setObjectInMatrixAtIndex(newValue, row: row, column: col)
        }
    }


    private func getObjectFromMatrixAtRow(row:Int, column col: Int) -> T {
        let nilWarning = "Nil returned from matrix at index \(row), \(col)"
        let obj = matrix.accessObjectAtRow(row, column: col) as? T
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

    /* Debugging */
    private func indexIsValidForRow(row: Int, column col: Int) -> Bool {
        return (row >= 0 && row < rowCapacity) && (col >= 0 && col < colCapacity)
    }
}


// MARK: Implementation of CollectionType Protocol
extension LiteMatrix : CollectionType {
    typealias Index = Int
    
    var startIndex:Int {
        return 0
    }
    
    
    var endIndex:Int {
        return rowCapacity - 1
    }
    
    // Generator for implementing for..in iteration
    func generate() -> AnyGenerator<T> {
    
        let rowMax = rowCapacity
        let colMax = colCapacity
        
        var rowIndex = 0
        var colIndex = 0
        
        // Passes function definition for next() on init with a closure
        return anyGenerator {
            if rowIndex < rowMax {
                if colIndex < colMax {
                    return self.getObjectFromMatrixAtRow(rowIndex, column: colIndex++)
                } else {
                    colIndex = 0
                    return self.getObjectFromMatrixAtRow(rowIndex++, column: colIndex)
                }
            } else {
                return nil
            }
        }
    }
    
    // A single subscript, i, will return what is in the column at index i, in the first row
    // This is only implemented to conform to the CollectionType protocol and the objects
    // in the matrix ought not be accessed this way. This is prone to index out of bounds.
    internal subscript(i: Int) -> T {
        assert(indexIsValidForRow(0, column: i), warning)
        return getObjectFromMatrixAtRow(0, column: i)
    }
    
} // End of extension CollectionType