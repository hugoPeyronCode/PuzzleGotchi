//
//  BinarioGenerator.swift
//  PuzzleGotchi
//
//  Created by Hugo Peyron on 05/12/2025.
//

import Foundation

class BinarioGenerator {
  
  // MARK: - Public Methods
  
  /// Generate a complete level pack with the specified difficulty
  static func generateLevelPack(difficulty: BinarioDifficulty, levelCount: Int) -> [BinarioLevel] {
    var levels: [BinarioLevel] = []
    
    for _ in 0..<levelCount {
      let level = generateLevel(difficulty: difficulty)
      levels.append(level)
    }
    
    return levels
  }
  
  /// Generate a single level
  static func generateLevel(difficulty: BinarioDifficulty) -> BinarioLevel {
    let size = difficulty.gridSize
    let solution = generateValidSolution(size: size)
    let initialGrid = createPuzzle(from: solution, difficulty: difficulty)
    
    return BinarioLevel(
      difficulty: difficulty,
      solution: solution,
      initialGrid: initialGrid
    )
  }
  
  // MARK: - Private Methods
  
  /// Generate a valid Binario solution grid
  private static func generateValidSolution(size: Int) -> [[CellValue]] {
    var grid = Array(repeating: Array(repeating: CellValue.empty, count: size), count: size)
    
    // Fill the grid using backtracking to ensure a valid solution
    if fillGrid(&grid, row: 0, col: 0, size: size) {
      return grid
    }
    
    // Fallback: should never happen with proper backtracking
    return grid
  }
  
  /// Backtracking algorithm to fill the grid with valid Binario rules
  private static func fillGrid(_ grid: inout [[CellValue]], row: Int, col: Int, size: Int) -> Bool {
    // Base case: reached the end of the grid
    if row == size {
      return true
    }
    
    // Calculate next position
    let nextRow = col == size - 1 ? row + 1 : row
    let nextCol = col == size - 1 ? 0 : col + 1
    
    // Try both values (0 and 1) randomly
    let values: [CellValue] = Bool.random() ? [.zero, .one] : [.one, .zero]
    
    for value in values {
      grid[row][col] = value
      
      if isValidPlacement(grid, row: row, col: col, size: size) {
        if fillGrid(&grid, row: nextRow, col: nextCol, size: size) {
          return true
        }
      }
    }
    
    // Backtrack
    grid[row][col] = .empty
    return false
  }
  
  /// Check if a placement is valid according to Binario rules
  private static func isValidPlacement(_ grid: [[CellValue]], row: Int, col: Int, size: Int) -> Bool {
    let value = grid[row][col]
    
    // Rule 1: No more than two consecutive identical values in a row
    if col >= 2 {
      if grid[row][col-1] == value && grid[row][col-2] == value {
        return false
      }
    }
    
    // Rule 2: No more than two consecutive identical values in a column
    if row >= 2 {
      if grid[row-1][col] == value && grid[row-2][col] == value {
        return false
      }
    }
    
    // Rule 3: Equal number of 0s and 1s in each row (check when row is complete)
    let rowComplete = grid[row].allSatisfy { $0 != .empty }
    if rowComplete {
      let zeros = grid[row].filter { $0 == .zero }.count
      let ones = grid[row].filter { $0 == .one }.count
      if zeros != size / 2 || ones != size / 2 {
        return false
      }
    }
    
    // Rule 4: Equal number of 0s and 1s in each column (check if column might be complete)
    var colValues: [CellValue] = []
    for r in 0...row {
      colValues.append(grid[r][col])
    }
    
    if colValues.count == size {
      let zeros = colValues.filter { $0 == .zero }.count
      let ones = colValues.filter { $0 == .one }.count
      if zeros != size / 2 || ones != size / 2 {
        return false
      }
    } else {
      // Check if we haven't exceeded half the size for either value
      let zeros = colValues.filter { $0 == .zero }.count
      let ones = colValues.filter { $0 == .one }.count
      if zeros > size / 2 || ones > size / 2 {
        return false
      }
    }
    
    return true
  }
  
  /// Create a puzzle by removing values from the solution
  private static func createPuzzle(from solution: [[CellValue]], difficulty: BinarioDifficulty) -> [[CellValue]] {
    let size = solution.count
    var puzzle = solution
    let totalCells = size * size
    let cluesCount = Int(Double(totalCells) * difficulty.cluesPercentage)
    let cellsToRemove = totalCells - cluesCount
    
    // Create a list of all positions
    var positions: [(Int, Int)] = []
    for row in 0..<size {
      for col in 0..<size {
        positions.append((row, col))
      }
    }
    
    // Shuffle and remove cells
    positions.shuffle()
    for i in 0..<cellsToRemove {
      let (row, col) = positions[i]
      puzzle[row][col] = .empty
    }
    
    return puzzle
  }
}
