//
//  ContentView.swift
//  PuzzleGotchi
//
//  Created by Hugo Peyron on 05/12/2025.
//

import SwiftUI

struct ContentView: View {
  @State private var selectedTab = 1 // Start with Puzzle tab (middle)
  @State private var gameManager = GameManager()
  
  var body: some View {
    VStack {
      
      Spacer()
      
      selectedTabContent
      
      Spacer()
      
      TabBar
      
    }
    .environment(gameManager)
  }
  
  @ViewBuilder
  private var selectedTabContent: some View {
    switch selectedTab {
    case 0:
      ShopView()
    case 1:
      PuzzleView()
    case 2:
      LibraryView()
    default:
      PuzzleView()
    }
  }
  
  
  private var TabBar : some View {
    GlassEffectContainer(spacing: 20) {
      HStack(spacing: 40) {
        // Shop Tab (Left)
        TabBarButton(
          icon: "cart.fill",
          title: "Shop",
          isSelected: selectedTab == 0
        ) {
          selectedTab = 0
        }
        
        // Puzzle Tab (Middle)
        TabBarButton(
          icon: "puzzlepiece.fill",
          title: "Puzzle",
          isSelected: selectedTab == 1
        ) {
          selectedTab = 1
        }
        
        // Library Tab (Right)
        TabBarButton(
          icon: "books.vertical.fill",
          title: "Library",
          isSelected: selectedTab == 2
        ) {
          selectedTab = 2
        }
      }
      .padding(.horizontal, 30)
      .padding(.vertical, 15)
      .glassEffect(.regular.tint(.primary.opacity(0.1)).interactive(), in: .rect(cornerRadius: 25))
    }
    .padding()
  }
}

#Preview {
  ContentView()
}
