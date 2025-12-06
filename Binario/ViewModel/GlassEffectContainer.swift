//
//  GlassEffectContainer.swift
//  PuzzleGotchi
//
//  Created by Hugo Peyron on 06/12/2025.
//

import SwiftUI

struct GlassEffectContainer<Content: View>: View {
  let spacing: CGFloat
  let content: Content
  
  init(spacing: CGFloat = 0, @ViewBuilder content: () -> Content) {
    self.spacing = spacing
    self.content = content()
  }
  
  var body: some View {
    content
  }
}
