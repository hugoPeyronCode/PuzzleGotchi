//
//  BinarioLevel.swift
//  PuzzleGotchi
//
//  Created by Hugo Peyron on 05/12/2025.
//

import Foundation

enum BinarioDifficulty: String, Codable, CaseIterable {
  case easy = "Easy"
  case medium = "Medium"
  case hard = "Hard"
  case expert = "Expert"
  
  var gridSize: Int {
    switch self {
    case .easy: return 6
    case .medium: return 8
    case .hard: return 10
    case .expert: return 12
    }
  }
  
  var cluesPercentage: Double {
    switch self {
    case .easy: return 0.45      // 45% cells pre-filled
    case .medium: return 0.35    // 35% cells pre-filled
    case .hard: return 0.25      // 25% cells pre-filled
    case .expert: return 0.20    // 20% cells pre-filled
    }
  }
}

struct BinarioLevel: Identifiable, Codable {
  let id: UUID
  let difficulty: BinarioDifficulty
  let gridSize: Int
  let solution: [[CellValue]]  // The complete solution
  let initialGrid: [[CellValue]] // Starting grid with clues
  var isCompleted: Bool
  var currentGrid: [[CellValue]]? // Player's progress
  
  init(difficulty: BinarioDifficulty, solution: [[CellValue]], initialGrid: [[CellValue]]) {
    self.id = UUID()
    self.difficulty = difficulty
    self.gridSize = difficulty.gridSize
    self.solution = solution
    self.initialGrid = initialGrid
    self.isCompleted = false
    self.currentGrid = nil
  }
}
