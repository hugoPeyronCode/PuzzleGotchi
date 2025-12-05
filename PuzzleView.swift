//
//  PuzzleView.swift
//  PuzzleGotchi
//
//  Created by Hugo Peyron on 05/12/2025.
//

import SwiftUI

struct PuzzleView: View {
  @Environment(GameManager.self) private var gameManager
  @State private var gameViewModel = BinarioGameViewModel()
  @State private var showingLevelSelection = false
  
  var body: some View {
    VStack(spacing: 20) {
      if let currentLevel = gameViewModel.currentLevel {
        // Active game view
        BinarioGameView(viewModel: gameViewModel)
      } else {
        // No level loaded - show level selection
        emptyStateView
      }
    }
    .padding()
    .sheet(isPresented: $showingLevelSelection) {
      LevelSelectionView(gameManager: gameManager, gameViewModel: gameViewModel)
    }
  }
  
  private var emptyStateView: some View {
    VStack(spacing: 20) {
      Image(systemName: "puzzlepiece.fill")
        .font(.system(size: 80))
        .foregroundStyle(.primary)
      
      Text("Ready to Play?")
        .font(.largeTitle)
        .fontWeight(.bold)
        .foregroundStyle(.primary)
      
      Text("Select a level to start playing")
        .font(.headline)
        .foregroundStyle(.secondary)
      
      Button {
        if let nextLevel = gameManager.getNextLevel() {
          gameViewModel.loadLevel(nextLevel)
        } else {
          showingLevelSelection = true
        }
      } label: {
        Text("Start Playing")
          .font(.headline)
          .foregroundStyle(.primary)
          .padding(.horizontal, 30)
          .padding(.vertical, 15)
      }
      .buttonStyle(.glass)
      
      Button {
        showingLevelSelection = true
      } label: {
        Text("Browse Levels")
          .font(.subheadline)
          .foregroundStyle(.secondary)
      }
    }
    .padding()
    .glassEffect(.regular.interactive(), in: .rect(cornerRadius: 20))
  }
}