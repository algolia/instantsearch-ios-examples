//
//  ColorConstants.swift
//  Icebnb
//
//  Created by Robert Mogos on 05/09/2017.
//  Copyright © 2017 Robert Mogos. All rights reserved.
//

import Foundation
import UIKit
struct ColorConstants {
    static let barBackgroundColor = UIColor(red: 249/256, green: 249/256, blue: 249/256, alpha: 1)
    static let barTextColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
    static let tableColor = UIColor.clear
    static let lightYellowColor = UIColor(red: 253/265, green: 253/256, blue: 163/256, alpha: 1)
}

struct PopoverConstants {
  static let popoverWidth:CGFloat = 200
  static let popoverRangeHeight:CGFloat = 200
  static let popoverCellHeight:CGFloat = 50
}

struct Geo {
  static let minimalDistance: Double = 250
  static let startRadius: Double = 100 // 100 m
  static let endRadius: Double = 10000 // 10 Km
  static let defaultRadius: Double = 500 // 500 m
}
