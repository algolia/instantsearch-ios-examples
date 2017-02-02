//
//  InstantSearchBar.swift
//  ecommerce
//
//  Created by Guy Daher on 02/02/2017.
//  Copyright © 2017 Guy Daher. All rights reserved.
//

import UIKit

class InstantSearchBar: UISearchBar {

    
    var preferredFont: UIFont!
    var preferredTextColor: UIColor!
    
    override func draw(_ rect: CGRect) {
        
        // Find the index of the search field in the search bar subviews.
        if let index = indexOfSearchFieldInSubviews() {
            // Access the search field
            let searchField: UITextField = (subviews[0] ).subviews[index] as! UITextField
            
            // Set its frame.
            searchField.frame = CGRect(x: 5.0, y: 8, width: frame.size.width - 10.0, height: frame.size.height - 16.0)
            
            // Set the font and text color of the search field.
            searchField.font = preferredFont
            searchField.textColor = preferredTextColor
            
            searchField.clipsToBounds = true
            searchField.layer.cornerRadius = 15.0
            
            searchField.layer.borderWidth = 2
            searchField.layer.borderColor = UIColor(red: 37.0 / 255.0, green: 71.0 / 255.0, blue: 112.0 / 255.0, alpha: 1).cgColor
            
            // Set the background color of the search field.
            searchField.backgroundColor = barTintColor
            
            if let glassIconView = searchField.leftView as? UIImageView {
                //Magnifying glass
                glassIconView.image = glassIconView.image?.withRenderingMode(UIImageRenderingMode.alwaysTemplate)
                glassIconView.tintColor = UIColor(red: 70.0 / 255.0, green: 174.0 / 255.0, blue: 218.0 / 255.0, alpha: 1)
            }
            
        }
        
        let startPoint = CGPoint(x: 0.0, y: frame.size.height)
        let endPoint = CGPoint(x: frame.size.width, y: frame.size.height)
        let path = UIBezierPath()
        path.move(to: startPoint)
        path.addLine(to: endPoint)
        
        let shapeLayer = CAShapeLayer()
        shapeLayer.path = path.cgPath
        shapeLayer.strokeColor = UIColor(red: 70.0 / 255.0, green: 174.0 / 255.0, blue: 218.0 / 255.0, alpha: 1).cgColor
        shapeLayer.lineWidth = 2.5
        
        //layer.addSublayer(shapeLayer)
        
        super.draw(rect)
    }
    
    
    
    init(frame: CGRect, font: UIFont, textColor: UIColor) {
        super.init(frame: frame)
        
        self.frame = frame
        preferredFont = font
        preferredTextColor = textColor
        
        searchBarStyle = UISearchBarStyle.prominent
        isTranslucent = false
    }
    
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    
    private func indexOfSearchFieldInSubviews() -> Int! {
        // Uncomment the next line to see the search bar subviews.
        print(subviews[0].subviews)
        
        var index: Int!
        let searchBarView = subviews[0]
        
        for i in 0..<searchBarView.subviews.count {
            if searchBarView.subviews[i].isKind(of: UITextField.self) {
                index = i
                break
            }
        }
        
        return index
    }
}
