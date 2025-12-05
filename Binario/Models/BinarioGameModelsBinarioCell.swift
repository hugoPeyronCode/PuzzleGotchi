//
//  BinarioCell.swift
//  PuzzleGotchi
//
//  Created by Hugo Peyron on 05/12/2025.
//

import Foundation

enum CellValue: Int, Codable {
  case empty = 0
  case zero = 1
  case one = 2
  
  var displayValue: String {
    switch self {
    case .empty: return ""
    case .zero: return "0"
    case .one: return "1"
    }
  }
  
  func toggled() -> CellValue {
    switch self {
    case .empty: return .zero
    case .zero: return .one
    case .one: return .empty
    }
  }
}

struct BinarioCell: Identifiable, Codable {
  let id: UUID
  var value: CellValue
  let isLocked: Bool // Pre-filled cells that can't be changed
  let row: Int
  let col: Int
  
  init(value: CellValue, isLocked: Bool, row: Int, col: Int) {
    self.id = UUID()
    self.value = value
    self.isLocked = isLocked
    self.row = row
    self.col = col
  }
}
