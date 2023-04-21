//
//  ReverseMask.swift
//  MarvelWeather
//
//  Created by Waliok on 18/04/2023.
//

import SwiftUI

extension View {
  @inlinable
  public func reverseMask<Mask: View>(
    alignment: Alignment = .center,
    @ViewBuilder _ mask: () -> Mask
  ) -> some View {
    self.mask {
      Rectangle()
        .overlay(alignment: alignment) {
          mask()
            .blendMode(.destinationOut)
        }
    }
  }
}



//MARK: - Another Way

extension View {
  // 1
  func inverseMask<Mask>(_ mask: Mask) -> some View where Mask: View {
    // 2
    self.mask(mask
      // 3
      .foregroundColor(.black)
      // 4
      .background(Color.white)
      // 5
      .compositingGroup()
      // 6
      .luminanceToAlpha()
    )
  }
}

