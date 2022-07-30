//
//  SudoContainer.swift
//  Sudoku_IN_Swift
//
//  Created by Andrew Peal on 17/7/2022.
//

import Foundation

class sudoContainer {
    var values: Array<Int> = initVal();
    var options: Set<Int> = Set<Int>();
    var contents: Set<Int> = [];
    var cells: Array<cell> = [];
    var id : String = "";
    
    init () {
        //values = initVal();
        //options = initSet();
        //contents = Set<Int>();
        //cells = Array<cell>();
        //id = "";
        
    }
    
    // **** init(id: String)
    //
    // This is a class initialiser when it is required to pass in the id
    // The convenience keyword is used here to allow the call to the main initialiser
    // from within this initialiser. 
    
    convenience init (id: String) {
        self.init();
        self.id = id;
        options = initSet();
        
    }
    
    // **** initSet() ****
    //
    // Function to create an initial set of 9 Integers
    // by virtue of a Set, the resulting set will be in a random order
    //
    
    func initSet() -> Set<Int> {
        var tempSet = Set<Int>();
        for i in 1...9 {
            tempSet.insert(i);
        }
        return tempSet;
    }
    
    func setValue (value: Int, loc: Int) {
        values[loc] = value;
    }
    
    func getTotalOptions () -> Set<Int> {
        var totalOptions : Set<Int> = [];
        var tempOptions : Set<Int>;
        for cell in cells {
            tempOptions = cell.options;
            for opt in tempOptions {
                totalOptions.insert(opt);
            }
        }
        return totalOptions;
    }
    
}
