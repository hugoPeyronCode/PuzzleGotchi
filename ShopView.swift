//
//  ShopView.swift
//  PuzzleGotchi
//
//  Created by Hugo Peyron on 05/12/2025.
//

import SwiftUI

struct ShopView: View {
  @Environment(GameManager.self) private var gameManager
  @State private var showingPurchaseConfirmation = false
  @State private var selectedPack: LevelPack?
  @State private var purchaseMessage = ""
  
  var body: some View {
    ScrollView {
      VStack(spacing: 20) {
        // Currency Display
        currencyHeader
        
        // Available Packs
        ForEach(gameManager.getAllPacks()) { pack in
          PackCardView(
            pack: pack,
            onPurchase: {
              attemptPurchase(pack)
            }
          )
        }
      }
      .padding()
    }
    .alert("Purchase Result", isPresented: $showingPurchaseConfirmation) {
      Button("OK") {
        selectedPack = nil
      }
    } message: {
      Text(purchaseMessage)
    }
  }
  
  private var currencyHeader: some View {
    HStack {
      Image(systemName: "dollarsign.circle.fill")
        .font(.title)
        .foregroundStyle(.yellow)
      
      Text("\(gameManager.currency)")
        .font(.title)
        .fontWeight(.bold)
        .foregroundStyle(.primary)
      
      Spacer()
      
      Text("Coins")
        .font(.headline)
        .foregroundStyle(.secondary)
    }
    .padding()
    .glassEffect(.regular.tint(.yellow.opacity(0.1)).interactive(), in: .rect(cornerRadius: 20))
  }
  
  private func attemptPurchase(_ pack: LevelPack) {
    selectedPack = pack
    
    if pack.isPurchased {
      purchaseMessage = "You already own this pack!"
      showingPurchaseConfirmation = true
    } else if gameManager.purchasePack(pack) {
      purchaseMessage = "Successfully purchased \(pack.name)! \(pack.levelCount) levels are now available."
      showingPurchaseConfirmation = true
    } else {
      purchaseMessage = "Not enough coins! You need \(pack.price - gameManager.currency) more coins."
      showingPurchaseConfirmation = true
    }
  }
}

struct PackCardView: View {
  let pack: LevelPack
  let onPurchase: () -> Void
  
  var body: some View {
    VStack(alignment: .leading, spacing: 15) {
      // Header
      HStack {
        Image(systemName: pack.iconName)
          .font(.system(size: 40))
          .foregroundStyle(iconColor)
        
        VStack(alignment: .leading, spacing: 5) {
          Text(pack.name)
            .font(.title3)
            .fontWeight(.bold)
            .foregroundStyle(.primary)
          
          Text(pack.difficulty.rawValue)
            .font(.caption)
            .foregroundStyle(.secondary)
            .padding(.horizontal, 8)
            .padding(.vertical, 4)
            .background(difficultyColor.opacity(0.2))
            .clipShape(Capsule())
        }
        
        Spacer()
      }
      
      // Description
      Text(pack.description)
        .font(.subheadline)
        .foregroundStyle(.secondary)
      
      // Stats
      HStack(spacing: 20) {
        Label("\(pack.levelCount) Levels", systemImage: "puzzlepiece.fill")
          .font(.caption)
          .foregroundStyle(.secondary)
        
        Label("\(pack.difficulty.gridSize)×\(pack.difficulty.gridSize) Grid", systemImage: "square.grid.3x3")
          .font(.caption)
          .foregroundStyle(.secondary)
      }
      
      // Purchase Button
      Button(action: onPurchase) {
        HStack {
          if pack.isPurchased {
            Image(systemName: "checkmark.circle.fill")
            Text("Owned")
          } else {
            Image(systemName: "dollarsign.circle.fill")
            Text("\(pack.price) Coins")
          }
        }
        .font(.headline)
        .foregroundStyle(.primary)
        .frame(maxWidth: .infinity)
        .padding()
        .background(pack.isPurchased ? Color.green.opacity(0.2) : Color.blue.opacity(0.2))
        .clipShape(RoundedRectangle(cornerRadius: 12))
      }
      .disabled(pack.isPurchased)
    }
    .padding()
    .glassEffect(.regular.interactive(), in: .rect(cornerRadius: 20))
  }
  
  private var iconColor: Color {
    switch pack.difficulty {
    case .easy: return .green
    case .medium: return .blue
    case .hard: return .orange
    case .expert: return .red
    }
  }
  
  private var difficultyColor: Color {
    switch pack.difficulty {
    case .easy: return .green
    case .medium: return .blue
    case .hard: return .orange
    case .expert: return .red
    }
  }
}

#Preview {
  @Previewable @State var gameManager = GameManager()
  
  ShopView()
    .environment(gameManager)
}
