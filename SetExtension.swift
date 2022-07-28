//
//  SetExtension.swift
//  Sudoku_IN_Swift
//
//  Created by Andrew Peal on 26/7/2022.
//

import Foundation

extension Set {
    
    func getSingleItem() -> Int? {
        
        for temp in self {
            return temp as? Int;
        }
        return 0;
    }
    
}
