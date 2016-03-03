//
//  ViewController.swift
//  Sudoku
//
//  Created by Armin Mahmoudi.
//  Copyright (c) 2015 Armin. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    let sudokuCreator = SudokuCreator()
    
    @IBOutlet weak var generateButton: UIButton!
    @IBOutlet weak var checkLabel: UILabel!
    @IBOutlet weak var difficultyControl: UISegmentedControl!

    // Generate a new sudoku puzzle with the selected difficulty
    @IBAction func generateSudoku(sender: AnyObject) {
        self.checkLabel.text = "..."
        self.sudokuCreator.reset()
        self.sudokuCreator.createSolution()
        
        // Find the selected difficulty
        var difficulty : Difficulty = .Hard
        switch self.difficultyControl.selectedSegmentIndex {
        case 0:
            difficulty = .Easy
        case 1:
            difficulty = .Medium
        case 2:
            difficulty = .Hard
        default:
            difficulty = .Hard
            break
        }
        
        // Display the Sudoku puzzle with selected difficulty
        self.displaySudoku(self.sudokuCreator.puzzleWithDifficulty(difficulty))
    }
    
    // Displays the sudoku puzzle by removing the zero (hidden) numbers
    func displaySudoku(puzzle: [[Int]]) {
        
        // UILabels are tagged from 1 to 81 to display the numbers
        for i in 1...81 {
            if let label = self.view.viewWithTag(i)! as? UILabel {
                let number : Int = puzzle[(i-1)/9][(i-1)%9]
                if number == 0 {
                    label.text = ""
                } else {
                    label.text = String(number)
                }
            }
        }
    }
    
    // Displays the solution to the board
    @IBAction func displaySolution(sender: AnyObject) {
        self.displaySudoku(self.sudokuCreator.solution)
    }
    
    // Checks the solution to ensure it's valid
    @IBAction func checkSolution(sender: UIButton) {
        // Check the board asynchronusely
        if checkSudokuSolution(self.sudokuCreator.solution) {
            self.checkLabel.text = " ✓ "
        } else {
            self.checkLabel.text = " x "
        }

    }
}

