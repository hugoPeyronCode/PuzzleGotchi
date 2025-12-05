//
//  GameManager.swift
//  PuzzleGotchi
//
//  Created by Hugo Peyron on 05/12/2025.
//

import Foundation

@Observable
class GameManager {
  
  // MARK: - Properties
  
  var purchasedPacks: [LevelPack] = []
  var currency: Int = 500 // Starting currency
  var availableLevels: [BinarioLevel] = []
  var completedLevelIds: Set<UUID> = []
  
  // MARK: - Initialization
  
  init() {
    loadGameData()
  }
  
  // MARK: - Pack Management
  
  /// Purchase a level pack
  func purchasePack(_ pack: LevelPack) -> Bool {
    // Check if user has enough currency
    guard currency >= pack.price else {
      return false
    }
    
    // Check if pack is already purchased
    guard !pack.isPurchased else {
      return false
    }
    
    // Deduct currency
    currency -= pack.price
    
    // Generate levels for the pack
    let levels = BinarioGenerator.generateLevelPack(
      difficulty: pack.difficulty,
      levelCount: pack.levelCount
    )
    
    // Create purchased pack with levels
    var purchasedPack = pack
    purchasedPack.isPurchased = true
    purchasedPack.levels = levels
    
    // Add to purchased packs
    purchasedPacks.append(purchasedPack)
    
    // Add levels to available levels
    availableLevels.append(contentsOf: levels)
    
    // Save game data
    saveGameData()
    
    return true
  }
  
  /// Mark a level as completed
  func completeLevel(_ level: BinarioLevel) {
    guard !completedLevelIds.contains(level.id) else { return }
    
    completedLevelIds.insert(level.id)
    
    // Award currency based on difficulty
    let reward = rewardForDifficulty(level.difficulty)
    currency += reward
    
    saveGameData()
  }
  
  /// Get reward amount for difficulty
  private func rewardForDifficulty(_ difficulty: BinarioDifficulty) -> Int {
    switch difficulty {
    case .easy: return 10
    case .medium: return 20
    case .hard: return 35
    case .expert: return 50
    }
  }
  
  /// Get levels for a specific pack
  func getLevelsForPack(_ pack: LevelPack) -> [BinarioLevel] {
    guard let purchasedPack = purchasedPacks.first(where: { $0.id == pack.id }) else {
      return []
    }
    return purchasedPack.levels ?? []
  }
  
  /// Get all available packs (purchased and unpurchased)
  func getAllPacks() -> [LevelPack] {
    var packs = LevelPack.availablePacks
    
    // Update purchase status
    for i in 0..<packs.count {
      if purchasedPacks.contains(where: { $0.id == packs[i].id }) {
        packs[i].isPurchased = true
      }
    }
    
    return packs
  }
  
  /// Get next available level to play
  func getNextLevel() -> BinarioLevel? {
    return availableLevels.first { !completedLevelIds.contains($0.id) }
  }
  
  // MARK: - Persistence
  
  private func saveGameData() {
    // Save to UserDefaults
    if let encoded = try? JSONEncoder().encode(purchasedPacks) {
      UserDefaults.standard.set(encoded, forKey: "purchasedPacks")
    }
    
    UserDefaults.standard.set(currency, forKey: "currency")
    
    let completedIds = completedLevelIds.map { $0.uuidString }
    UserDefaults.standard.set(completedIds, forKey: "completedLevelIds")
  }
  
  private func loadGameData() {
    // Load from UserDefaults
    if let data = UserDefaults.standard.data(forKey: "purchasedPacks"),
       let packs = try? JSONDecoder().decode([LevelPack].self, from: data) {
      purchasedPacks = packs
      
      // Rebuild available levels
      for pack in packs {
        if let levels = pack.levels {
          availableLevels.append(contentsOf: levels)
        }
      }
    }
    
    currency = UserDefaults.standard.integer(forKey: "currency")
    if currency == 0 {
      currency = 500 // Default starting currency
    }
    
    if let completedIds = UserDefaults.standard.array(forKey: "completedLevelIds") as? [String] {
      completedLevelIds = Set(completedIds.compactMap { UUID(uuidString: $0) })
    }
  }
  
  /// Reset all game data (for testing)
  func resetGameData() {
    purchasedPacks = []
    currency = 500
    availableLevels = []
    completedLevelIds = []
    
    UserDefaults.standard.removeObject(forKey: "purchasedPacks")
    UserDefaults.standard.removeObject(forKey: "currency")
    UserDefaults.standard.removeObject(forKey: "completedLevelIds")
  }
}
