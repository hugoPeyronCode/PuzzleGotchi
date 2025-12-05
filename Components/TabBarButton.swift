//
//  TabBarButton.swift
//  PuzzleGotchi
//
//  Created by Hugo Peyron on 05/12/2025.
//

import SwiftUI

struct TabBarButton: View {  let icon: String
  let title: String
  let isSelected: Bool
  let action: () -> Void
  
  var body: some View {
    Button(action: action) {
      VStack(spacing: 4) {
        Image(systemName: icon)
          .font(.system(size: 24))
        Text(title)
          .font(.caption2)
      }
      .foregroundStyle(isSelected ? Color.primary : Color.primary.opacity(0.6))
      .frame(maxWidth: .infinity)
    }
  }
}
