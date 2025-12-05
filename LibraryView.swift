//
//  LibraryView.swift
//  PuzzleGotchi
//
//  Created by Hugo Peyron on 05/12/2025.
//

import SwiftUI

struct LibraryView: View {
  @Environment(GameManager.self) private var gameManager
  
  var body: some View {
    ScrollView {
      VStack(spacing: 20) {
        // Statistics Header
        statisticsHeader
        
        if gameManager.purchasedPacks.isEmpty {
          emptyStateView
        } else {
          // Purchased Packs
          ForEach(gameManager.purchasedPacks) { pack in
            LibraryPackView(pack: pack, gameManager: gameManager)
          }
        }
      }
      .padding()
    }
  }
  
  private var statisticsHeader: some View {
    VStack(spacing: 15) {
      HStack(spacing: 20) {
        StatCard(
          title: "Packs Owned",
          value: "\(gameManager.purchasedPacks.count)",
          icon: "shippingbox.fill",
          color: .blue
        )
        
        StatCard(
          title: "Levels Completed",
          value: "\(gameManager.completedLevelIds.count)",
          icon: "checkmark.circle.fill",
          color: .green
        )
      }
      
      HStack(spacing: 20) {
        StatCard(
          title: "Total Levels",
          value: "\(gameManager.availableLevels.count)",
          icon: "puzzlepiece.fill",
          color: .orange
        )
        
        StatCard(
          title: "Coins Earned",
          value: "\(gameManager.currency)",
          icon: "dollarsign.circle.fill",
          color: .yellow
        )
      }
    }
  }
  
  private var emptyStateView: some View {
    VStack(spacing: 20) {
      Image(systemName: "books.vertical.fill")
        .font(.system(size: 80))
        .foregroundStyle(.secondary)
      
      Text("Library Empty")
        .font(.title2)
        .fontWeight(.bold)
        .foregroundStyle(.primary)
      
      Text("Purchase level packs from the Shop to build your collection")
        .font(.subheadline)
        .foregroundStyle(.secondary)
        .multilineTextAlignment(.center)
    }
    .padding()
    .glassEffect(.regular.interactive(), in: .rect(cornerRadius: 20))
  }
}

struct StatCard: View {
  let title: String
  let value: String
  let icon: String
  let color: Color
  
  var body: some View {
    VStack(spacing: 10) {
      Image(systemName: icon)
        .font(.title2)
        .foregroundStyle(color)
      
      Text(value)
        .font(.title)
        .fontWeight(.bold)
        .foregroundStyle(.primary)
      
      Text(title)
        .font(.caption)
        .foregroundStyle(.secondary)
    }
    .frame(maxWidth: .infinity)
    .padding()
    .glassEffect(.regular.interactive(), in: .rect(cornerRadius: 15))
  }
}

struct LibraryPackView: View {
  let pack: LevelPack
  let gameManager: GameManager
  
  var body: some View {
    VStack(alignment: .leading, spacing: 15) {
      // Header
      HStack {
        Image(systemName: pack.iconName)
          .font(.title2)
          .foregroundStyle(difficultyColor)
        
        VStack(alignment: .leading) {
          Text(pack.name)
            .font(.headline)
            .foregroundStyle(.primary)
          
          Text(pack.difficulty.rawValue)
            .font(.caption)
            .foregroundStyle(.secondary)
        }
        
        Spacer()
      }
      
      // Progress
      VStack(alignment: .leading, spacing: 8) {
        HStack {
          Text("Progress")
            .font(.caption)
            .foregroundStyle(.secondary)
          
          Spacer()
          
          Text("\(completedCount)/\(pack.levelCount)")
            .font(.caption)
            .fontWeight(.bold)
            .foregroundStyle(.primary)
        }
        
        ProgressView(value: Double(completedCount), total: Double(pack.levelCount))
          .tint(difficultyColor)
      }
      
      // Stats
      HStack(spacing: 20) {
        Label("\(pack.levelCount) Levels", systemImage: "puzzlepiece.fill")
          .font(.caption)
          .foregroundStyle(.secondary)
        
        Label("\(pack.difficulty.gridSize)×\(pack.difficulty.gridSize)", systemImage: "square.grid.3x3")
          .font(.caption)
          .foregroundStyle(.secondary)
        
        if completedCount == pack.levelCount {
          Label("Complete", systemImage: "checkmark.seal.fill")
            .font(.caption)
            .foregroundStyle(.green)
        }
      }
    }
    .padding()
    .glassEffect(.regular.interactive(), in: .rect(cornerRadius: 20))
  }
  
  private var completedCount: Int {
    let levels = gameManager.getLevelsForPack(pack)
    return levels.filter { gameManager.completedLevelIds.contains($0.id) }.count
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