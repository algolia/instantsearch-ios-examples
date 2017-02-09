//
//  FacetRecord.swift
//  ecommerce
//
//  Created by Guy Daher on 09/02/2017.
//  Copyright © 2017 Guy Daher. All rights reserved.
//

import Foundation

public class FacetRecord: NSObject {
    public var value: String
    public var count: Int
    public var highlighted: String
    
    init(value: String, count: Int, highlighted: String) {
        self.value = value
        self.count = count
        self.highlighted = highlighted
    }
}
