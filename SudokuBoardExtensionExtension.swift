//
//  SudokuBoardExtensionExtension.swift
//  Sudoku_IN_Swift
//
//  Created by Andrew Peal on 28/7/2022.
//

import Foundation

class extendExtendBoard : extendBoard {
    
    override func fillBoard() {
        
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

        
    }
    
}
