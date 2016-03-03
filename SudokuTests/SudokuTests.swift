//
//  SudokuTests.swift
//  SudokuTests
//
//  Created by Armin Mahmoudi on 2014-12-19.
//  Copyright (c) 2014 Armin. All rights reserved.
//

import UIKit
import XCTest

class SudokuTests: XCTestCase {

    // Check the SudokuChecker and its performance
    func testSudokuChecker() {
        
        // Measure Performance of the checker:
        self.measureBlock() {
            let rightSolution = [[4, 1, 7, 2, 8, 9, 6, 5, 3], [8, 3, 2, 6, 5, 1, 7, 4, 9], [6, 9, 5, 3, 7, 4, 2, 1, 8], [2, 8, 3, 4, 6, 7, 5, 9, 1], [5, 4, 9, 8, 1, 2, 3, 7, 6], [1, 7, 6, 9, 3, 5, 8, 2, 4], [3, 2, 1, 7, 9, 8, 4, 6, 5], [9, 6, 4, 5, 2, 3, 1, 8, 7], [7, 5, 8, 1, 4, 6, 9, 3, 2]]
            XCTAssert(checkSudokuSolution(rightSolution), "Failed to Check! (Correct Solution)")
        }
        
        // Empty solution:
        XCTAssert(!checkSudokuSolution([[0]]), "Failed to Check! (Empty Array)")

        // Sample Correct Solutions:
        let rightSolution = [[6, 4, 5, 7, 9, 8, 2, 1, 3], [8, 9, 2, 4, 3, 1, 7, 6, 5], [7, 3, 1, 6, 2, 5, 8, 9, 4], [4, 1, 8, 3, 5, 7, 9, 2, 6], [5, 7, 9, 1, 6, 2, 4, 3, 8], [2, 6, 3, 9, 8, 4, 1, 5, 7], [9, 2, 7, 5, 4, 6, 3, 8, 1], [1, 8, 6, 2, 7, 3, 5, 4, 9], [3, 5, 4, 8, 1, 9, 6, 7, 2]]
        XCTAssert(checkSudokuSolution(rightSolution), "Failed to Check! (Correct Solution)")
        
        // Sample Incorrect Solitions:
        // with 0 numbers
        let wrongSolution = [[2, 8, 4, 7, 9, 1, 3, 0, 0], [3, 6, 9, 5, 8, 2, 1, 4, 7], [7, 1, 5, 6, 3, 4, 2, 9, 8], [1, 4, 3, 9, 2, 7, 5, 8, 0], [5, 7, 6, 3, 1, 8, 9, 2, 4], [9, 2, 8, 4, 5, 6, 7, 1, 3], [6, 3, 7, 2, 4, 9, 8, 5, 1], [8, 5, 2, 1, 6, 3, 4, 7, 9], [4, 9, 1, 8, 7, 5, 6, 3, 2]]
        XCTAssert(!checkSudokuSolution(wrongSolution), "Failed to Check! (0 numbers)")
        
        // duplicates
        let wrongSolution2 = [[4, 1, 1, 1, 8, 9, 6, 5, 3], [4, 3, 2, 6, 5, 1, 7, 4, 9], [6, 9, 5, 3, 7, 4, 2, 1, 8], [2, 8, 3, 4, 6, 7, 5, 9, 1], [5, 4, 9, 8, 1, 2, 3, 7, 6], [1, 7, 6, 9, 3, 5, 8, 2, 4], [3, 2, 1, 7, 9, 8, 4, 6, 5], [9, 6, 4, 5, 2, 3, 1, 8, 7], [7, 5, 8, 1, 4, 6, 9, 3, 2]]
        XCTAssert(!checkSudokuSolution(wrongSolution2), "Failed to Check! (Duplicates)")
        
        // negative or greater than 9 numbers
        let wrongSolution3 = [[4, 1, 7, 2, 8, 9, -1, 5, 3], [8, 3, 2, 6, 5, 1, 7, 4, 9], [6, 9, 5, 3, 7, 4, 2, 1, 8], [2, 8, 3, 4, 6, 7, 5, 9, 1], [5, 4, 9, 8, 1, 2, 3, 7, 6], [1, 7, 6, 9, 3, 5, 8, 2, 4], [3, 2, 1, 7, 9, 8, 4, 6, 5], [9, 6, 4, 5, 2, 3, 1, 8, 7], [7, 5, 8, 1, 4, 6, 9, 3, 2]]
        XCTAssert(!checkSudokuSolution(wrongSolution3), "Failed to Check! (Negative Number)")

        // numbers greater than 9
        let wrongSolution4 = [[4, 1, 7, 78, 8, 9, 2, 5, 3], [8, 3, 2, 6, 5, 1, 7, 4, 9], [6, 9, 5, 3, 7, 4, 2, 1, 8], [2, 8, 3, 4, 6, 7, 5, 9, 1], [5, 4, 9, 8, 1, 2, 3, 7, 6], [1, 7, 6, 9, 3, 5, 8, 2, 4], [3, 2, 1, 7, 9, 8, 4, 6, 5], [9, 6, 4, 5, 2, 3, 1, 8, 7], [7, 5, 8, 1, 4, 6, 9, 3, 2]]
        XCTAssert(!checkSudokuSolution(wrongSolution4), "Failed to Check! (Greater than 9 Number)")
    }
    
    // Test Sudoku creator's functionality and its performance
    func testSudokuCreator() {
        self.measureBlock() {
            let sudokuCreator = SudokuCreator()
            sudokuCreator.createSolution()
            XCTAssert(checkSudokuSolution(sudokuCreator.solution), "Failed to Create Valid Solution!")
            sudokuCreator.reset()
        }
    }
    
}
