//
//  RatingPicker.swift
//  DemoEcommerce
//
//  Created by Vladislav Fitc on 16/04/2021.
//

import Foundation
import SwiftUI

struct RatingPicker: View {
  
  @ObservedObject var ratingController: RatingController

  let numberFormatter: NumberFormatter = {
    let formatter = NumberFormatter()
    formatter.numberStyle = .decimal
    formatter.groupingSeparator = ","
    return formatter
  }()
  
  
  var body: some View {
    VStack(spacing: 9) {
      ForEach(1..<ratingController.maxRating) { row in
        let minRating = ratingController.maxRating-row
        let noSelection = ratingController.selectedRating == -1
        let isSelected = minRating == ratingController.selectedRating
        let isHighlighted = noSelection || isSelected
        let itemsCount = ratingController.itemsCountPerRating[minRating] ?? 0
        Button(action: { ratingController.select(minRating: minRating) },
               label: {
                HStack {
                  ForEach(0..<minRating) { _ in
                    Image(systemName: "star.fill")
                      .foregroundColor(Color.accentColor.opacity(isHighlighted ? 1 : 0.3))
                  }
                  ForEach(0..<row) { _ in
                    Image(systemName: "star")
                      .foregroundColor(Color.accentColor.opacity(isHighlighted ? 1 : 0.3))
                  }
                  Spacer()
                  Text(numberFormatter.string(from: NSNumber(value: itemsCount))!)
                    .foregroundColor(.black)
                    .background(Rectangle()
                                  .fill(Color.gray.opacity(isHighlighted ? 0.6 : 0.3))
                                  .cornerRadius(10)
                                  .padding(.horizontal, -5)
                                  .padding(.vertical, -2)
                    )
                    .padding(.trailing, 5)
                }
               })
      }
    }
  }
  
}

struct RatingPicker_Previews : PreviewProvider {
  
  static let ratingSource = RatingController()
    
  static var previews: some View {
    RatingPicker(ratingController: ratingSource).accentColor(.yellow)
  }
  
}
