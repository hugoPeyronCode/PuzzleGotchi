//
//  ContentView.swift
//  PuzzleGotchi
//
//  Created by Hugo Peyron on 05/12/2025.
//

import SwiftUI

struct ContentView: View {
  @State private var selectedTab = 0 // 0 = Shop, 1 = Library
  
  var body: some View {
    VStack {
      
      Spacer()
      
      selectedTabContent
      
      Spacer()
      
      TabBar
      
    }
  }
  
  @ViewBuilder
  private var selectedTabContent: some View {
    switch selectedTab {
    case 0:
      PuzzleShopView()
    case 1:
      LibraryView()
    default:
      PuzzleShopView()
    }
  }
  
  
  private var TabBar : some View {
    GlassEffectContainer(spacing: 20) {
      HStack(spacing: 40) {
        // Shop Tab
        TabBarButton(
          icon: "cart.fill",
          title: "Shop",
          isSelected: selectedTab == 0
        ) {
          selectedTab = 0
        }
        
        // Library Tab
        TabBarButton(
          icon: "books.vertical.fill",
          title: "Library",
          isSelected: selectedTab == 1
        ) {
          selectedTab = 1
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
