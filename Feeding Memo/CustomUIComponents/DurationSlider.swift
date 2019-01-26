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
            
            return NSAttributedString(string: string, attributes: [.font: UIFont.systemFont(ofSize: 10, weight: UIFont.Weight.black), .foregroundColor: UIColor.black])
            
        }
        let labelTextAttributes: [NSAttributedString.Key : Any] = [.font: UIFont.systemFont(ofSize: 12, weight: .bold), .foregroundColor: UIColor.white]
        
        self.fraction = 0.05
        self.shadowOffset = CGSize(width: 0, height: 10)
        self.shadowBlur = 5
        self.shadowColor = UIColor(white: 0, alpha: 0.1)
        self.contentViewColor = .gray
        self.valueViewColor = .white
        self.setMinimumLabelAttributedText(NSAttributedString(string: "", attributes: labelTextAttributes))
        self.setMaximumLabelAttributedText(NSAttributedString(string: "", attributes: labelTextAttributes))
        
        self.imagesColor = UIColor.white
        self.valueViewColor = .white
        self.setMinimumImage(#imageLiteral(resourceName: "past"))
        self.setMaximumImage(#imageLiteral(resourceName: "future"))
        
}


}
