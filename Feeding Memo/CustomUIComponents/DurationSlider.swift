//
//  DurationSlider.swift
//  Feeding Memo
//
//  Created by Mich W on 26/01/2019.
//  Copyright © 2019 Mich W. All rights reserved.
//

import Foundation

import fluid_slider
import UIKit

class DurationSlider : Slider {
    
    public required convenience init?(coder aDecoder: NSCoder) {
        self.init(coder: aDecoder)
        
    }
    
    public convenience init(frame: CGRect) {
        
        self.init()
        
        self.attributedTextForFraction = { fraction in
            
            let min = 5 * Int(Double(Double((fraction) * CGFloat(consts.maxFeedingTime))) / 5)
            
            let string = "\(min) min"
            
            return NSAttributedString(string: string, attributes: [.font:  UIFont(name: "Heebo-Bold", size: 10.0)!, .foregroundColor: UIColor.white])
            
        }
        let labelTextAttributes: [NSAttributedString.Key : Any] = [.font:  UIFont(name: "Heebo-Bold", size: 12.0)!, .foregroundColor: UIColor.white]
        
        self.fraction = 0.5
        self.shadowOffset = CGSize(width: 0, height: 10)
        
        // shadow
        self.shadowBlur = 5
        self.shadowColor =  UIColor(red: 71.0 / 255.0, green: 55.0 / 255.0, blue: 69.0 / 255.0, alpha: 0.0)
        
        // content
        self.contentViewColor = UIColor(red: 89.0 / 255.0, green: 45.0 / 255.0, blue: 83.0 / 255.0, alpha: 0.2)
        
        
        
        self.setMinimumLabelAttributedText(NSAttributedString(string: "", attributes: labelTextAttributes))
        self.setMaximumLabelAttributedText(NSAttributedString(string: "", attributes: labelTextAttributes))
        
        self.imagesColor = UIColor.white
        self.valueViewColor = UIColor(red: 176.0 / 255.0, green: 49.0 / 255.0, blue: 76.0 / 255.0, alpha: 1.0)
        self.setMinimumImage(#imageLiteral(resourceName: "minusSign"))
        self.setMaximumImage(#imageLiteral(resourceName: "plusSign"))
        
        
}


}
