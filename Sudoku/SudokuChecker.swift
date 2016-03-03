//
//  SudokuChecker.swift
//  Sudoku
//
//  Created by Armin Mahmoudi.
//  Copyright (c) 2015 Armin. All rights reserved.
//

import Foundation

// Checks a populated puzzle for the three rules of Sudoku and returns false if there is a mistake
public func checkSudokuSolution(puzzle: [[Int]]) -> Bool {
    
    // Check the puzzle for empty
    if puzzle.isEmpty {
        return false
    }
    
    // Check the puzzle's structure to make sure it's a 9x9 2D Array
    if puzzle.count == 9 {
        for row in puzzle {
            if row.count != 9 {
                return false
            }
        }
    } else {
        return false
    }
    
    // Loop through rows
    for x in 0..<9 {
        // Loop through columns
        for y in 0..<9 {
            // Get the value of the position (x, y)
            let number = puzzle[x][y]
            
            // Check for invalid numbers
            if number < 1 || number > 9 {
                return false
            }
            
            // Check the 3x3 Cell in which the number exists against duplicates
            for var i = Int(x/3) * 3; i < (Int(x/3)+1)*3; i++ {
                for var j = Int(y/3)*3; j < (Int(y/3)+1)*3; j++ {
                    if puzzle[i][j] == number && i != x && j != y {
                        return false
                    }
                }
            }
            
            // Check the column y against duplicates
            for var i = 0; i < 9; i++ {
                if puzzle[i][y] == number && i != x {
                    return false
                }
            }
            
            // Check the row x against duplicates
            for j in 0..<9 {
                if puzzle[x][j] == number && j != y {
                    return false
                }
            }
        }
    }
    return true
}
