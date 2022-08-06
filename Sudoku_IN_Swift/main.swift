//
//  main.swift
//  Sudoku_IN_Swift
//
//  Created by Andrew Peal on 17/7/2022.
//

import Foundation

let xAxis = ["a","b","c","d","e","f","g","h","i"];
let yAxis = [1,2,3,4,5,6,7,8,9];
var count = 0;
var boxRow = 0;
typealias subRow = subCube;
typealias subCol = subCube;

print("Welcome to Swiftdoku");

var sudoku = sudokuBoard();
var newBoard = sudoku.board;
var boxOrder = sudoku.boxOrder;

var linOrder = boxOrder.sorted(); // linear order
var randOrder = boxOrder.shuffled(); // random order

sudoku.fillBoard();

/*
for pos in boxOrder {
    var subRow = newBoard[pos]?.thisSubRow;
    print("SubRow: \(subRow?.id) contents: \(subRow?.options)")
}
*/

print("Number of filled cells is: \(countBoard(board: newBoard))");
printBoard(board: newBoard);
