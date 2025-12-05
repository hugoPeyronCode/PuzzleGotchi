//
//  BinarioGameViewModel.swift
//  PuzzleGotchi
//
//  Created by Hugo Peyron on 05/12/2025.
//

import Foundation
import SwiftUI

@Observable
class BinarioGameViewModel {
  
  // MARK: - Properties
  
  var currentLevel: BinarioLevel?
  var grid: [[BinarioCell]] = []
  var isLevelComplete: Bool = false
  var moveCount: Int = 0
  
  // MARK: - Initialization
  
  init() {
    // Initialize with empty grid
  }
  
  // MARK: - Public Methods
  
  /// Load a level to play
  func loadLevel(_ level: BinarioLevel) {
    self.currentLevel = level
    self.isLevelComplete = false
    self.moveCount = 0
    
    // Initialize grid from level data
    let gridData = level.currentGrid ?? level.initialGrid
    var cells: [[BinarioCell]] = []
    
    for row in 0..<level.gridSize {
      var rowCells: [BinarioCell] = []
      for col in 0..<level.gridSize {
        let value = gridData[row][col]
        let isLocked = level.initialGrid[row][col] != .empty
        let cell = BinarioCell(value: value, isLocked: isLocked, row: row, col: col)
        rowCells.append(cell)
      }
      cells.append(rowCells)
    }
    
    self.grid = cells
  }
  
  /// Toggle a cell's value
  func toggleCell(row: Int, col: Int) {
    guard row < grid.count, col < grid[row].count else { return }
    
    let cell = grid[row][col]
    
    // Don't allow changing locked cells
    guard !cell.isLocked else { return }
    
    // Toggle the value
    grid[row][col].value = cell.value.toggled()
    moveCount += 1
    
    // Check if level is complete
    checkLevelCompletion()
  }
  
  /// Check if the current grid matches the solution
  private func checkLevelCompletion() {
    guard let level = currentLevel else { return }
    
    // Check if all cells are filled
    let allFilled = grid.allSatisfy { row in
      row.allSatisfy { $0.value != .empty }
    }
    
    guard allFilled else {
      isLevelComplete = false
      return
    }
    
    // Check if solution matches
    var matches = true
    for row in 0..<grid.count {
      for col in 0..<grid[row].count {
        if grid[row][col].value != level.solution[row][col] {
          matches = false
          break
        }
      }
      if !matches { break }
    }
    
    isLevelComplete = matches
  }
  
  /// Reset the current level
  func resetLevel() {
    guard let level = currentLevel else { return }
    loadLevel(level)
  }
  
  /// Get validation errors for a specific row
  func validateRow(_ row: Int) -> [String] {
    var errors: [String] = []
    let rowValues = grid[row].map { $0.value }
    
    // Check for three consecutive identical values
    for i in 0..<rowValues.count - 2 {
      if rowValues[i] != .empty &&
         rowValues[i] == rowValues[i+1] &&
         rowValues[i] == rowValues[i+2] {
        errors.append("Three consecutive \(rowValues[i].displayValue)s in row \(row + 1)")
      }
    }
    
    // Check for equal distribution (only if row is complete)
    if rowValues.allSatisfy({ $0 != .empty }) {
      let zeros = rowValues.filter { $0 == .zero }.count
      let ones = rowValues.filter { $0 == .one }.count
      let half = rowValues.count / 2
      
      if zeros != half || ones != half {
        errors.append("Row \(row + 1) must have equal 0s and 1s")
      }
    }
    
    return errors
  }
  
  /// Get validation errors for a specific column
  func validateColumn(_ col: Int) -> [String] {
    var errors: [String] = []
    let colValues = grid.map { $0[col].value }
    
    // Check for three consecutive identical values
    for i in 0..<colValues.count - 2 {
      if colValues[i] != .empty &&
         colValues[i] == colValues[i+1] &&
         colValues[i] == colValues[i+2] {
        errors.append("Three consecutive \(colValues[i].displayValue)s in column \(col + 1)")
      }
    }
    
    // Check for equal distribution (only if column is complete)
    if colValues.allSatisfy({ $0 != .empty }) {
      let zeros = colValues.filter { $0 == .zero }.count
      let ones = colValues.filter { $0 == .one }.count
      let half = colValues.count / 2
      
      if zeros != half || ones != half {
        errors.append("Column \(col + 1) must have equal 0s and 1s")
      }
    }
    
    return errors
  }
  
  /// Get all validation errors
  func getAllValidationErrors() -> [String] {
    var allErrors: [String] = []
    
    for row in 0..<grid.count {
      allErrors.append(contentsOf: validateRow(row))
    }
    
    for col in 0..<(grid.first?.count ?? 0) {
      allErrors.append(contentsOf: validateColumn(col))
    }
    
    return allErrors
  }
}
