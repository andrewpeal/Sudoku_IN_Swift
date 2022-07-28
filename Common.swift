//
//  Common.swift
//  Sudoku_IN_Swift
//
//  Created by Andrew Peal on 17/7/2022.
//

import Foundation

func initVal() -> Array<Int> {
    return [0,0,0,0,0,0,0,0,0]
}

func getRandRow() -> Array<Int> {
    var shuffRow = [1,2,3,4,5,6,7,8,9]
    for _ in 1...99 {
        shuffRow = shuffRow.shuffled()
    }
    return shuffRow
}

// Print board to console

func printBoard (board: [String: cell]) {
    
    var line : String = " ";
    for _ in 1...29 {
        line += "-";
        
    }
    
    print(line);
    
    for xVal in xAxis {
        
        var tString = "|";
        var cellPosition : String;
        var currCell : cell;
        let thirds = [3,6,9];
        let div = ["c", "f", "i"];


        
        for yVal in yAxis {
            
            cellPosition = xVal + String(yVal);
            currCell = board[cellPosition]!
            if (thirds.contains(yVal)){
                tString += " " + String(currCell.value) + " |";
            }
            else { tString += " " + String(currCell.value) + " "; }
            
            
        }
        print(tString);

        if(div.contains(xVal)) {
            print(line);
        }
        
    }
}

// **** func countBoard() ****
//
// counts the number of cells in the board that have a value
// used mainly to check that every cell is populated with a value

func countBoard (board: [String: cell]) -> Int {

    var count : Int = 0;
    for xVal in xAxis {
        
   
        var cellPosition : String;
        var currCell : cell;
       
        for yVal in yAxis {
            
            cellPosition = xVal + String(yVal);
            currCell = board[cellPosition]!
            if (!currCell.isEmpty) { count += 1; }
            
        } // end for
         
    } // end for

    return count;

} // end func



