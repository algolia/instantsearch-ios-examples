//
//  InstantSearchStats.swift
//  ecommerce
//
//  Created by Guy Daher on 17/02/2017.
//  Copyright © 2017 Guy Daher. All rights reserved.
//

import Foundation
import UIKit

protocol InstantSearchStats {
    var text: String? { get set }
}

// TODO: UITextView also has a text property, but it is not optional.
// We can solve this by creating a new property nbHits that will change text, but
// will have to add stored property in order to achieve that.
extension UILabel: InstantSearchStats {}
extension UITextField: InstantSearchStats {}

extension InstantSearch {
    func addWidget(stats: InstantSearchStats) {
        self.stats.append(stats)
    }
}

// TODO: We want to be able to observe when elements are added to act on them. 
// The proper way is use something like Bond but it is a bit advanced. So for now, use this temp workaround.
// http://five.agency/solving-the-binding-problem-with-swift/
struct ArrayAppendObserver<T> {
    
    var elementChangedHandler: (() -> ())?
    var array: [T] = []
    
    mutating func append(_ newElement: T) {
        self.array.append(newElement)
        elementChangedHandler?()
    }
    
    mutating func removeAtIndex(index: Int) {
        self.array.remove(at: index)
        elementChangedHandler?()
    }
    
    subscript(index: Int) -> T {
        set {
            print("Set object from \(self.array[index]) to \(newValue) at index \(index)")
            self.array[index] = newValue
        }
        get {
            return self.array[index]
        }
    }
}
