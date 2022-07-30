//
//  Board.swift
//  Sudoku_IN_Swift
//
//  Created by Andrew Peal on 17/7/2022.
//

import Foundation

class sudokuBoard {
    
    let xAxis = ["a","b","c","d","e","f","g","h","i"];
    let yAxis = [1,2,3,4,5,6,7,8,9];
    var cellCount = 0;
    var boxRow = 0;
    var board = [String: cell]();
    var boxOrder : Array<String> = [];
    
    init () {
        
        // Create each cell, assign the cell position (unique), and add the cell to the board. Also create
        // the rows & add a reference of each row to the containing cells.
        
        var thisRow : row;
        
        for xVal in xAxis {
            
            thisRow = row(id: "Row \(xVal)");
            
            var newCell : cell;
            
            for yVal in yAxis {
                
                let cellPosition : String = xVal + String(yVal);
                newCell = cell();
                newCell.position = cellPosition;
                newCell.thisRow = thisRow;
                thisRow.cells.append(newCell);
                board[cellPosition] = newCell;
            }
            
        }
        
        // Create the columns and add a reference of each column to the containing cells.

        var thisCol : column;
        
        for yVal in yAxis {
            
            thisCol = column(id: "Column \(yVal)");
            
            var cellPosition : String;
            
            for xVal in xAxis {
                cellPosition = xVal + String(yVal);
                board[cellPosition]?.thisCol = thisCol;
                thisCol.cells.append(board[cellPosition]!);
            }
        }
        
        // n is the factor size of the board. Normally set to 3, this results in a 9x9 board, 81 cells in total, standard Sudoku size.
        // Create the boxes and add a reference of each box to the containing cells.

        let n = 3;
        var boxNum = 0;
        //var boxOrder : Array<String> = [];

        for tots in 0...(n - 1) { // x component
            
            var newBox : cube;
            
            for index in 0...(n - 1) { // y component
                
                let begin = (index * n) + 1;
                let end = (begin + n) - 1;
                
                boxNum += 1;
                newBox = cube(); // create a new cube aka (Box)
                newBox.id = "Cube " + String(boxNum);
                
                let totsBegin = (tots*n) + 1;
                let totsEnd = (totsBegin + n) - 1;
                
                for i in totsBegin...totsEnd {
                    
                    var cellPosition : String;
                    
                    for j in begin...end {
                        
                        cellPosition = xAxis[i - 1] + String(yAxis[j - 1]);
                        
                        boxOrder.append(cellPosition);
                        
                        board[cellPosition]?.thisCube = newBox;
                        newBox.cells.append(board[cellPosition]!);
                        
                    } // end for j
                    
                } // end for i
                
            } // end for index
            
        }

        // Loop through the board and add references to siblings for each cell.
        // A sibling is any cell that is contained in the same row, column or cube.

        for pos in boxOrder {
            
            let currentCell = board[pos];
            let thisRow = currentCell?.thisRow;
            let thisCol = currentCell?.thisCol;
            let thisCube = currentCell?.thisCube;
            
            for r in thisRow!.cells {
                r.siblings.insert(pos);
            }
            for c in thisCol!.cells {
                c.siblings.insert(pos);
            }
            for b in thisCube!.cells {
                b.siblings.insert(pos);
            }
        }
        
        var posCounter : Int = 0;
        var subRowCounter : Int = 1;
        var newSubRow = subRow();
        newSubRow.id = "R\(subRowCounter)";
        for pos in boxOrder {
            
            if (posCounter >= 3) {              // every third cell, create a new subRow
                newSubRow = subRow();
                subRowCounter += 1;
                newSubRow.id = "R\(subRowCounter)";
                posCounter = 0;
            }
            
            var currCell = board[pos]!;              // reference to the current cell
            
            currCell.thisSubRow = newSubRow;
            newSubRow.addCell(add: currCell);
            posCounter += 1;
        }

        // Remove itself from the siblings list. A cell cannot be a sibling of itself

        for pos in boxOrder {
            board[pos]?.siblings.remove(pos);
        }
        
    } // end init()
    
    func setCell (pos: String, value: Int) {
        board[pos]?.insert(insertValue: value);
    }
    
    func getCellCount() -> Int {
        // not being used at the moment
        return 0;
    }
    
    func fillBoard () {
        
        var thisCell : cell?;
        var options : Set<Int>?;
        var thisRow : row?;
        var thisCol : column?;
        var thisBox : cube?;
        
        for pos in boxOrder {
            
            thisCell = board[pos];
            
            if (!thisCell!.isEmpty) {
                continue; // cell is already populated, continue to next iteration of the loop
            }
            
            options = thisCell?.options
            thisRow = thisCell?.thisRow
            thisCol = thisCell?.thisCol
            thisBox = thisCell?.thisCube
            
            var inserted : Bool = false
            var inRow : Bool;
            var inCol : Bool;
            var inBox : Bool;
            
            var dash : String = "";
            for _ in 0...20 {
                dash += "-";
            }
            print(dash);
            print("Inserting cell: \(thisCell!.position)");
            print(dash);
            
            if(options!.isEmpty) {
                print("There are no options.");
                print("Failure is immenent.");
                print("Terminating");
                return;
            }
            
            var invalidOptions = Set<Int>();
            
            // -------------------------------------------------------------
            // Box operations
            // -------------------------------------------------------------

            var tempBoxSet : Set<Int> = options!; // create a temporary option Set
            var boxChildOptions = Set<Int>();
            
            for boxChild in thisBox!.cells {
                if (boxChild.isEmpty && boxChild.position != pos) {
                    
                    for boxChildOpt in boxChild.options {
                        boxChildOptions.insert(boxChildOpt);
                    }
                    
                    tempBoxSet = tempBoxSet.intersection(boxChild.options);
                    //print("Box Child: \(boxChild.position) | Options : \(boxChild.options)");
                }
            }

            //print("boxChildOptions: \(boxChildOptions)");
            //print("tempBoxSet: \(tempBoxSet)");
             
            // ### DEV
            var mustInsert = Set<Int>();
            if (boxChildOptions.count < (thisBox?.getTotalOptions().count)!) {
                mustInsert = (thisBox?.getTotalOptions().subtracting(boxChildOptions))!;
            }
            
            if (mustInsert.count > 0) {
                print("Must insert is: \(mustInsert)")
                for value in mustInsert {
                    thisCell?.insert(insertValue: value);
                }
                continue;
            }
            // ### DEV
            
            // -------------------------------------------------------------
            // Row operations
            // -------------------------------------------------------------

             //var tempRowSet : Set<Int> = options!; // create a temporary option Set
             
             for rowChild in thisRow!.cells {
                 if (rowChild.isEmpty && rowChild.position != pos) {
                     //tempRowSet = tempRowSet.intersection(rowChild.options);
                     if (rowChild.options.count <= 1 ) {
                         // remove the single option from the options of the current cell.
                         // how to get this single option from the Set?
                         let tt : Int = rowChild.options.getSingleItem()!;

                         if (thisRow!.options.count > 1) {

                             invalidOptions.insert(tt);
                             //print("thisRow options count: \(thisRow!.options.count)");
                             //print("***** Removing \(tt) *****");
                             //print("***** The item to be removed is \(tt) *****");
                         }

                     }
                     //print("Row Child: \(rowChild.position) | Options : \(rowChild.options)");
                 }
             }
             
            // -------------------------------------------------------------
            // Column operations
            // -------------------------------------------------------------
             
            //var tempColSet : Set<Int> = options!; // create a temporary option Set
             
             for colChild in thisCol!.cells {
                 if (colChild.isEmpty && colChild.position != pos) {
                     //tempColSet = tempColSet.intersection(colChild.options);
                     if (colChild.options.count <= 1 ) {
                         // remove the single option from the options of the current cell.
                         // how to get this single option from the Set?
                         let tt : Int = colChild.options.getSingleItem()!;

                         if (thisCol!.options.count > 1) {

                             invalidOptions.insert(tt);
                             //print("thisCol options count: \(thisCol!.options.count)");
                             //print("***** Removing \(tt) *****");
                             //print("***** The item to be removed is \(tt) *****");
                         }

                     }
                     //print("Col Child: \(colChild.position) | Options : \(colChild.options)");
                 }
             }
             
             // -------------------------------------------------------------

            print("InvalidOptions is: \(invalidOptions)");
            
            
            var optSet = options!.subtracting(tempBoxSet);
            
            if (!invalidOptions.isEmpty) {
                for invalidOpt in invalidOptions {
                    optSet.remove(invalidOpt);
                }
            }

            
            print("optSet is: \(optSet)");
            
            var posSet : Set<Int>;
            if (optSet.count == 0) {
                posSet = options!;
            }
            else { posSet = optSet; }
            
            print ("Row Options: \(thisRow!.getTotalOptions())"); //print (thisRow!.getTotalOptions());
            print ("Column Options: \(thisCol!.getTotalOptions())"); //print (thisCol!.getTotalOptions());
            print ("Box Options: \(thisBox!.getTotalOptions())"); //print (thisBox!.getTotalOptions());
            print("Cell options: \(options!)");
            
            for value in posSet {
                
                if(!inserted) {
                    thisCell!.insert(insertValue: value)
                    print ("Inserting: " + String(value))
                    inserted.toggle()
                }
                
            }
            
        } // end for

    } // end func

} // end class
