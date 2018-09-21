//
//  topBarView.swift
//  ecommerce
//
//  Created by Guy Daher on 07/02/2017.
//  Copyright © 2017 Guy Daher. All rights reserved.
//

import UIKit

class TopBarView: UIView {
    
    override func draw(_ rect: CGRect) {
        super.draw(rect)
        
        let context = UIGraphicsGetCurrentContext()
        context?.setStrokeColor(UIColor.gray.cgColor)
        context?.setLineWidth(2)
        context?.move(to: CGPoint(x: 0, y: bounds.height))
        context?.addLine(to: CGPoint(x: bounds.width, y: bounds.height))
        context?.strokePath()
    }
}
