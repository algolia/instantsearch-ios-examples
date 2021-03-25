//
//  QueryInput+SwiftUI.swift
//  DemoDirectory
//
//  Created by Vladislav Fitc on 25/03/2021.
//  Copyright © 2021 Algolia. All rights reserved.
//

import Foundation
import SwiftUI
import InstantSearchCore

class QueryDispatcher: ObservableObject {
  
  @Published var query: String = "" {
    didSet {
      searcher?.query = query
      searcher?.search()
    }
  }
  
  weak var searcher: Searcher?
  
}

struct SearchBar: View {
  
  @State private var isEditing = false
  @Binding var text: String

  var body: some View {
    HStack {
      ZStack {
        TextField("Search ...", text: $text)
          .padding(7)
          .padding(.horizontal, 25)
          .background(Color(.systemGray5))
          .cornerRadius(8)
          .overlay(
            HStack {
              Image(systemName: "magnifyingglass")
                .foregroundColor(.gray)
                .frame(minWidth: 0, maxWidth: .infinity, alignment: .leading)
                .padding(.leading, 8)
                .disabled(true)
              if isEditing && !text.isEmpty {
                Button(action: {
                  self.text = ""
                }) {
                  Image(systemName: "multiply.circle.fill")
                    .foregroundColor(.gray)
                    .padding(.trailing, 8)
                }
              }
            }
          )
          .padding(.horizontal, 10)
          .onTapGesture {
            self.isEditing = true
          }

      }
      if isEditing {
        Button(action: {
          self.isEditing = false
          self.text = ""
          self.hideKeyboard()
        }) {
          Text("Cancel")
        }
        .padding(.trailing, 10)
        .transition(.move(edge: .trailing))
        .animation(.default)
      }
    }
    .background(Color(.systemBackground))
  }
  
}

#if canImport(UIKit)
extension View {
    func hideKeyboard() {
        UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
    }
}
#endif
