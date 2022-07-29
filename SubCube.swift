//
//  SubCube.swift
//  Sudoku_IN_Swift
//
//  Created by Andrew Peal on 28/7/2022.
//

import Foundation

class subCube {
    
    var id : String;
    var parent : String;
    var options : Set<Int>;
    var contents : Set<Int>;
    var values : Set<Int>;
    var cells: Array<cell>;
    var isEmpty : Bool;
    
    init () {
        id = "";
        parent = "";
        options = Set<Int>();
        contents = Set<Int>();
        values = Set<Int>();
        cells = Array<cell>();
        isEmpty = true;
    }
    
    func addCell(add: cell) {
        cells.append(add);
    }
}
