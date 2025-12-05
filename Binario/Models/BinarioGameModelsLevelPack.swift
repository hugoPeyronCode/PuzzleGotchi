//
//  LevelPack.swift
//  PuzzleGotchi
//
//  Created by Hugo Peyron on 05/12/2025.
//

import Foundation

struct LevelPack: Identifiable, Codable {
  let id: UUID
  let name: String
  let description: String
  let difficulty: BinarioDifficulty
  let levelCount: Int
  let price: Int // In-game currency
  let iconName: String
  var isPurchased: Bool
  var levels: [BinarioLevel]?
  
  init(
    name: String,
    description: String,
    difficulty: BinarioDifficulty,
    levelCount: Int,
    price: Int,
    iconName: String,
    isPurchased: Bool = false
  ) {
    self.id = UUID()
    self.name = name
    self.description = description
    self.difficulty = difficulty
    self.levelCount = levelCount
    self.price = price
    self.iconName = iconName
    self.isPurchased = isPurchased
    self.levels = nil
  }
  
  // Predefined packs
  static let availablePacks: [LevelPack] = [
    LevelPack(
      name: "Beginner Bundle",
      description: "Perfect for learning the basics",
      difficulty: .easy,
      levelCount: 10,
      price: 100,
      iconName: "star.fill",
      isPurchased: false
    ),
    LevelPack(
      name: "Intermediate Challenge",
      description: "Test your logical skills",
      difficulty: .medium,
      levelCount: 15,
      price: 200,
      iconName: "bolt.fill",
      isPurchased: false
    ),
    LevelPack(
      name: "Advanced Pack",
      description: "For seasoned players",
      difficulty: .hard,
      levelCount: 20,
      price: 300,
      iconName: "flame.fill",
      isPurchased: false
    ),
    LevelPack(
      name: "Expert Collection",
      description: "Ultimate challenge awaits",
      difficulty: .expert,
      levelCount: 25,
      price: 500,
      iconName: "crown.fill",
      isPurchased: false
    )
  ]
}
