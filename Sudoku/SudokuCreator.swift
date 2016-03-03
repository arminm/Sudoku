//
//  SudokuCreator.swift
//  Sudoku
//
//  Created by Armin Mahmoudi.
//  Copyright (c) 2015 Armin. All rights reserved.
//

import Foundation

// Assuming the puzzle to be a 9x9 2D Array, with rows of the puzzle being the arrays of size 9, inside the puzzle array.
// x represents the index of the row array
// y represents the index of the number on a row array (i.e. column)
//        y –>
// x [0] [0, 1, 2, ... ,8]
// | [1] [0, 1, 2, ...
// V [:] [0, 1, ...
//   [8] [0, ...

//Position class represents the address to a single square on the puzzle.
class Position {
    
    var x : Int // row
    var y : Int // column
    
    init (x: Int, y: Int) {
        self.x = x
        self.y = y
    }
    
}

// Define dificulty level with number of positions left blank on the puzzle
// The numbers are estimates based on my own experience on solving sudokus
enum Difficulty : Int {
    case Hard = 55
    case Medium = 35
    case Easy = 20
}

// The class responsible for creating the puzzle, with three different difficulty levels, and the solution
public class SudokuCreator {
    
    // Initialize the puzzle as a 2D array of Integers
    var solution = Array(count:9, repeatedValue:Array(count:9, repeatedValue:Int(0)))
    
    // Initialize the constraints as a 2D array of [Int: Int] dictionaries, which hold the constraints (i.e. numbers that can not be assigned to each position on the baord.
    var constraints = Array(count:9, repeatedValue:Array(count:9, repeatedValue:[Int: Int]()))
    
    // set the array of numbers
    let numbers = [1,2,3,4,5,6,7,8,9]
    
    // Shuffle function that shuffles an array of any type
    func shuffleArray <T> (originalArray: [T]) -> [T] {
        var shuffledArray = originalArray
        let count = originalArray.count
        for i in 0..<count {
            let randomIndex = Int(arc4random_uniform(UInt32(count)))
            if randomIndex == i { continue }
            swap(&shuffledArray[i], &shuffledArray[randomIndex])
        }
        return shuffledArray
    }
    
    // Find the most constrained position in a row
    private func mostConstrainedPosition (x: Int) -> Position {
        
        // Defining variables that will be used in the loop
        var positionValue : Int
        var positionConstraints : [Int: Int]
        var yPosition = -1
        var maxConstraintsCount = -1
        
        // Loop through the row values to find the most constrained
        for y in 0..<9  {
            positionValue = self.solution[x][y]
            if positionValue == 0 {
                positionConstraints = self.constraints[x][y]
                
                if positionConstraints.count >= maxConstraintsCount {
                    maxConstraintsCount = positionConstraints.count
                    yPosition = y
                }
            }
        }
        
        return Position(x: x, y: yPosition)
    }
    
    // Choose one of the available numbers for a position
    private func availableNumber(position: Position) -> Int {
        
        var availableNum : Int = 0      //  Set to zero in case no available number was found
        for number in shuffleArray(self.numbers) {
            // check if the random number is available for that position
            if self.constraints[position.x][position.y][number] == nil {
                availableNum = number
                break
            }
        }
        
        return availableNum
    }
    
    // Propagate the constraints for a position. This function will add the value of the position on the puzzle, to corresponding constraints for the positions in the same column, row, and 3x3 block
    private func propagateConstraints(position: Position) {
        
        let number = self.solution[position.x][position.y]
        
        // 3x3 Block
        for var i = Int(position.x/3) * 3; i < (Int(position.x/3)+1)*3; i++ {
            for var j = Int(position.y/3)*3; j < (Int(position.y/3)+1)*3; j++ {
                self.constraints[i][j][number] = number
            }
        }
        
        // Column
        for var i = Int(position.x/3)*3; i < 9; i++ {
            self.constraints[i][position.y][number] = number
        }
        
        // Row
        for y in 0..<9 {
            self.constraints[position.x][y][number] = number
        }
    }
    
    // Populate the puzzle:
    func createSolution() {
        
        // Define variables to be used in the loop
        var position : Position
        
        // Create variables to memorize each state of the puzzle and constraints after populating each row. The reason is to be able to back-track for one block if a row gets stuck, and retry.
        var puzzleStates = Array(count:10, repeatedValue:self.solution)
        var constraintsStates = Array(count:10, repeatedValue:self.constraints)
        
        // Track the troubling position before back-tracking, to find out if more than 1 step is required.
        var stuckPosition : Position?
        // "backTracks" checks if after certain backtracks, the puzzle gets stuck yet again, then the next time the algorithm backtracks one more step until it can resolve the issue.
        var backTracks : Int = 0
        
        // Loop through the rows
        for var x = 0; x < 9; x++ {
            
            // Perform the following 9 times:
            for var k = 0; k < 9; k++ {
                
                // Find the most constrained position on the row
                position = self.mostConstrainedPosition(x)
                
                // Find a valid number for the found position
                self.solution[position.x][position.y] = self.availableNumber(position)
                
                // If no valid number is found, back-step to the previous row, and reset the puzzle to the previous state, and retry
                if self.solution[position.x][position.y] == 0 {
                    if stuckPosition == nil || (stuckPosition!.x != position.x || stuckPosition!.y != position.y) {
                        stuckPosition = position
                        backTracks = 1
                    } else if stuckPosition!.x == position.x && stuckPosition!.y == position.y {
                        backTracks++
                    }
                    
                    // set x to the potential valid state
                    x -= backTracks
                    if x < 0 {
                        x = 0
                    }
                    
                    // Back-track the solution and constraints
                    self.constraints = constraintsStates[x+1]
                    self.solution = puzzleStates[x+1]
                    break
                    
                } else {
                    // If a valid number was assigned, propagate the constraints for that position
                    self.propagateConstraints(position)
                }
            }
            
            // Record the state of the puzzle
            puzzleStates[x+1] = self.solution
            constraintsStates[x+1] = self.constraints
        }
    }
    
    // Return a puzzle with selected difficulty level (i.e. number of removed numbers)
    // based on difficulty, numbers are removed from the puzzle at random
    func puzzleWithDifficulty (difficulty: Difficulty) -> [[Int]] {
        
        // Define the variables used in the loop
        var randomX = 0
        var randomY = 0
        var counter : Int = difficulty.rawValue
        var puzzle = self.solution
        
        // Hide as many cells as specified by the difficulty by setting them to 0
        while counter > 0 {
            randomX = Int(arc4random_uniform(UInt32(9)))
            randomY = Int(arc4random_uniform(UInt32(9)))
            if puzzle[randomX][randomY] != 0 {
                puzzle[randomX][randomY] = 0
                counter--
            }
        }
        
        return puzzle
    }
    
    // Reset the puzzle and constraints
    func reset() {
        self.solution = Array(count:9, repeatedValue:Array(count:9, repeatedValue:Int(0)))
        self.constraints = Array(count:9, repeatedValue:Array(count:9, repeatedValue:[Int: Int]()))
    }
}