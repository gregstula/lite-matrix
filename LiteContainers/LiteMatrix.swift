//
// LiteMatrix.swift
//
// Copyright (c) 2015, Gregory D. Stula
// All rights reserved.
//
// Licence: The BSD 3-Clause License
// http://opensource.org/licenses/BSD-3-Clause

import Foundation

class LiteMatrix<T : AnyObject> {

    // Used for ARC
    private var ownerOfObjects:Array<T?>
    let rowCapacity:Int
    let colCapacity:Int
    
    /* Opaque pointers are used to represent C pointers to types that cannot be represented in
     Swift, such as incomplete struct typees. It is used here to represent the
     lite_matrix_lookup_table struct that contains the void*** matrix. */
    
    let lookupPtr:COpaquePointer;
    
    // init & deinit
    init(rows:Int, columns cols:Int, repeatedValue:T)
    {
        rowCapacity = rows
        colCapacity = cols
        
        lookupPtr = LCLM_alloc_lookup_table(rows, cols)
        
        ownerOfObjects = [T?](count:rows * cols, repeatedValue:repeatedValue)
        
        let unman = Unmanaged.passRetained(repeatedValue)
        let voidPtr = unsafeBitCast(unman, UnsafeMutablePointer<Void>.self)
        
        for i in 0..<rowCapacity {
            for j in 0..<colCapacity {
                LCLM_insert_object_at_index(lookupPtr, i, j, voidPtr)
            }
        }
    }
    
    
    deinit
    {
        LCLM_dealloc_lookup_table(lookupPtr)
    }
    

    private func accessObjectFromMatrix(row row:Int, column col:Int) -> T?
    {
        assert(indexIsValid(row: row, column: col), "Index out of bounds!")
        // Convert from void* to Swift object
        
        let ptr = LCLM_access_object_at_index(lookupPtr, row, col)
        
        let object = UnsafeMutablePointer<Unmanaged<T>>(ptr)
        
        let unman = object.memory
        
        return unman.takeRetainedValue()
        
    }
    
    
    private func insertObjectInMatrix(object object:T, row:Int, column col:Int)
    {
        // ARC automagically handles the memory management for each object
        // via the Array<T>.
        
        assert(indexIsValid(row: row, column: col), "Index out of bounds!")
        ownerOfObjects[row * col] = object
        
        // Cast the pointer to void*, it is no longer a safe pointer and it does not count
        // towards the object's reference count.
        let voidObjectPointer = unsafeBitCast(object, UnsafeMutablePointer<Void>.self)
        
        // C function call
        LCLM_insert_object_at_index(lookupPtr, row, col, voidObjectPointer)
    }
    
    
    // MARK: Subscript
    // Double subscript notation is the only public interface: exampleMatrix[1,2]
    subscript(row:Int, col:Int) -> T
    {
        get {
            return accessObjectFromMatrix(row: row, column: col)!
        }
        set {
            insertObjectInMatrix(object: newValue, row: row, column: col)
        }
    }
    
    private func indexIsValid(row row:Int, column col:Int) -> Bool
    {
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
    
    
    // Original generate method, now returns the coords it used
    func generate() -> AnyGenerator<T> {
        
        var rowIndex = 0
        var colIndex = 0
    
        return anyGenerator {
        
            guard rowIndex < self.rowCapacity else {
                return nil
            }
            
            if colIndex++ == self.colCapacity {
                colIndex = 0
                rowIndex++
                return self.accessObjectFromMatrix(row: rowIndex, column: colIndex)
            } else {
                return self.accessObjectFromMatrix(row: rowIndex, column: colIndex)
            }
        }
    }
    
    
    // A single subscript, i, will return what is in the column at index i, in the first row
    // This is only implemented to conform to the CollectionType protocol and the objects
    // in the matrix ought not be accessed this way. This is prone to index out of bounds.
    internal subscript(i: Int) -> T {
        return accessObjectFromMatrix(row: 0,column: 0)!
    }
}
// End of extension CollectionType
