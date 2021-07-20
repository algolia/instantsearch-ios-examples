//
//  ExpandableView.swift
//  DemoEcommerce
//
//  Created by Vladislav Fitc on 11/04/2021.
//

import Foundation
import SwiftUI

struct ExpandableView<Child: View>: View {
  
  let title: String
  let child: () -> Child
  @State private var isExpanded: Bool = true
  
  init(title: String, @ViewBuilder child: @escaping () -> Child) {
    self.title = title
    self.child = child
  }
  
  var body: some View {
    VStack(alignment: .leading, spacing: 10) {
      HStack {
        Button(action: { withAnimation { isExpanded.toggle() } },
               label: {
                  Text(title)
                    .font(.headline)
                  Spacer()
                  Image(systemName: "chevron.right")
                    .rotationEffect(.degrees(isExpanded ? 90 : 0))
                    .animation(.linear)
               }).padding(.trailing, 20)
      }
      if isExpanded {
        child().transition(.opacity)
      }
    }
  }
  
}

struct ExpandableView_Previews : PreviewProvider {
    
  static var previews: some View {
    VStack(spacing: 20) {
      ExpandableView(title: "Text1") {
        Text("Enjoy the exceptional display and all-day power of the Samsung Galaxy S7 smartphone. A 12MP rear-facing camera and 5MP front-facing camera capture memories as they happen, and the 5.1-inch display uses dual-pixel technology to display them with superior clarity. The Samsung Galaxy S7 smartphone features durable housing and a water-resistant design.")
      }.frame(alignment: .top).padding(.horizontal, 10)
      ExpandableView(title: "Text2") {
        Text("Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum.")
      }.frame(alignment: .top).padding(.horizontal, 10)
    }.frame(maxHeight: .infinity, alignment: .top)
  }
}
