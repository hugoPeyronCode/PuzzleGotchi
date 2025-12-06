import SwiftUI
import SwiftUI

@Observable
class ShopViewModel {
  var packs: [LevelPack] = []
  var purchasingPack: LevelPack? = nil
  var showPurchaseSuccess = false
  
  init() {
    generatePacks()
  }
  
  private func generatePacks() {
    packs = PuzzleType.allCases.map { type in
      LevelPack(
        type: type,
        cardCount: Int.random(in: 3...6),
        price: [50, 100, 150, 200].randomElement()!,
        difficulty: [.easy, .medium, .hard, .expert].randomElement()!
      )
    }
  }
  
  func purchase(_ pack: LevelPack) {
    purchasingPack = pack
    
    DispatchQueue.main.asyncAfter(deadline: .now() + 0.8) {
      if let index = self.packs.firstIndex(where: { $0.id == pack.id }) {
        self.packs[index].isPurchased = true
      }
      self.showPurchaseSuccess = true
      
      DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
        self.purchasingPack = nil
        self.showPurchaseSuccess = false
      }
    }
  }
}