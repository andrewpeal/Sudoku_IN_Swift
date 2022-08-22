//
//  Cell.swift
//  Sudoku_IN_Swift
//
//  Created by Andrew Peal on 17/7/2022.
//

import Foundation

class cell {
    
    var position : String = "";
    var value : Int = 0;
    var isEmpty : Bool = true;
    var siblings : Set<String> = [];
    var options : Set<Int> = [1,2,3,4,5,6,7,8,9];
    var thisRow : row // a reference to the row the cell belongs to
    var thisCol : column // a reference to the column this cell belongs to
    var thisCube : cube // formerly called a box -> this is a reference to the cube
    var thisSubRow : subRow
    var thisSubCol : subCol
    
    init () {
        
        thisRow = row();
        thisCol = column();
        thisCube = cube();
        thisSubRow = subRow();
        thisSubCol = subCol();
    }
    
    func insert (insertValue: Int) {
        
        self.value = insertValue;
        isEmpty = false;
        thisRow.contents.insert(value); // insert the value into the row reference
        thisRow.options.remove(value); // remove the value from the row reference options
        thisCol.contents.insert(value); // insert the value into the col reference
        thisCol.options.remove(value); // remove the value from the col reference options
        thisCube.contents.insert(value); // insert the value into the cube reference
        thisCube.options.remove(value); // remove the value from the cube reference options
        
        // [#BETA] Beta code is code which is currently in use but still been
        // tested and is not required for production build.
        thisSubRow.contents.insert(value);
        thisSubRow.options.remove(value);
        // /[#BETA]
        
        updateRow();
        updateCol();
        updateCube();
        
    }
    
    func updateRow () {
         for cell in thisRow.cells {
             cell.options.remove(value);
         }
         
    }
    
    func updateCol () {
         for cell in thisCol.cells {
             cell.options.remove(value);
         }
         
    }
    
    func updateCube () {
        
        
         for cell in thisCube.cells {
             cell.options.remove(value);
             // for each subRow in the?
         }
        
         
    }
}
