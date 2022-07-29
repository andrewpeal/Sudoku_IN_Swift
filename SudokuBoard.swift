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
            
            let currCell = board[pos]!;              // reference to the current cell
            
            currCell.thisSubRow = newSubRow;
            newSubRow.addCell(add: currCell);
            posCounter += 1;
        }
        

        // Remove itself from the siblings list. A cell cannot be a sibling of itself

        for pos in boxOrder {
            board[pos]?.siblings.remove(pos);
        }
        
    } // end init()
    
    func fillBoard () {
        
        var thisCell : cell?;
        var options : Set<Int>?;
        var thisRow : row?;
        var thisCol : column?;
        var thisBox : cube?;
        //var rowOptions : Set<Int>?;
        
        for pos in boxOrder {
            
            thisCell = board[pos]
            options = thisCell?.options
            thisRow = thisCell?.thisRow
            thisCol = thisCell?.thisCol
            thisBox = thisCell?.thisCube
            //rowOptions = thisRow!.options
            
            var inserted : Bool = false
            var inRow : Bool;
            var inCol : Bool;
            var inBox : Bool;
            
            for value in options! {
                // if value is not in row. column or box
                inRow = thisCell!.thisRow.contents.contains(value)
                inCol = thisCell!.thisCol.contents.contains(value)
                inBox = thisCell!.thisCube.contents.contains(value)
                
                var isValid = true
                print ("Cell is: " + thisCell!.position)
                var childOptions : Set<Int>?;
                
                for child in thisCell!.siblings {
                    
                    childOptions = board[child]?.options

                    if board[child]!.isEmpty {
                        //print("Child is: " + child)
                        //print ("Child Options are: ")
                        //print(childOptions)
                        if childOptions!.count < 2 && childOptions!.contains(value) {
                            //print ("Options are: ")
                            //print (options)
                            //print("Failure is imminent")
                            isValid = false
                        } // end if
                    } // end if
                } // end for

                if !inRow && !inCol && !inBox && isValid && !inserted {
                    print ("Options are: \(options!)")
                    //print (options)
                    print ("Inserting: " + String(value))
                    thisCell!.insert(insertValue: value)
                    
                    print ("Row Options: ")
                    print (thisRow!.getTotalOptions())
                    print ("Column Options: ")
                    print (thisCol!.getTotalOptions())
                    print ("Box Options: ")
                    print (thisBox!.getTotalOptions())
                    print("------------------------------------")
                    
                    inserted = true
                    break
                } // end if
            } // end for
            if !inserted {
                print ("Row Options: ")
                print (thisRow!.getTotalOptions())
                print ("Column Options: ")
                print (thisCol!.getTotalOptions())
                print ("Box Options: ")
                print (thisBox!.getTotalOptions())
                print("Terminating...")
                break
            } // end if
            
        } // end for

    } // end func

} // end class
