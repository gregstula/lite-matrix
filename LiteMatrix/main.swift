//
//  main.swift
//  LifeGenSwift
//
//  Created by Gregory D. Stula on 8/30/15.
//  Copyright (c) 2015 Gregory D. Stula. All rights reserved.
//

import Foundation

class Cell: NSObject {
    var test = "dude"
}

class Cell_Swift_Only {
    var test = "success"
}

struct StructCell {
    var test = "bro"
}

let mat = LiteMatrix<Cell_Swift_Only>(rows: 100, columns: 100, repeatedValue:Cell_Swift_Only())

for i in 0..<100 {
    for j in 0..<100 {
        mat[i, j] = Cell_Swift_Only()
    }
}

print("\(mat[0,0].test)")

//let x = Cell_Swift_Only()
//
//let y = unsafeBitCast(x, UnsafeMutablePointer<Void>.self)
//
//let z = UnsafeMutablePointer<Cell_Swift_Only>(y)
//
//let a = z.memory

//let rl = 100
//let cl = 100
//
//var mat = LiteMatrix<Cell>(rows: rl, columns: cl)
//var arr = [[StructCell]]((0..<rl).map{ _ in [StructCell]((0..<cl).map{ _ in StructCell()})})
//
//for array in mat {
//    for thing in mat {
//        print("\(thing.test)")
//    }