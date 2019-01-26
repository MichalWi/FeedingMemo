//
//  UITitSelector.swift
//  Feeding Memo
//
//  Created by Mich W on 26/01/2019.
//  Copyright © 2019 Mich W. All rights reserved.
//

import Foundation

import UIKit
import CircleMenu

import fluid_slider

class UITitSelector : CircleMenu {
    
    public init(frame: CGRect) {
        super.init(
            frame: frame,
            normalIcon:"plus",
            selectedIcon:"plus_filled",
            buttonsCount: 2,
            duration: 0.2,
            distance: 100)
        
        self.subButtonsRadius = 25
        self.startAngle = -50
        self.endAngle = 50
        self.layer.cornerRadius = self.frame.size.width / 2.0
        
        
    }
    
    public required convenience init?(coder aDecoder: NSCoder) {
        self.init(coder: aDecoder)
        
    }
    
    
}

class MaskView : UIView {
    
    public required convenience init?(coder aDecoder: NSCoder) {
        self.init(coder: aDecoder)
        
    }
    public override init(frame: CGRect) {
        
        super.init(frame: frame)
        
        self.frame = frame
        
        self.backgroundColor = UIColor(red: 0.95, green: 0.95, blue: 0.95, alpha: 1)
        self.isUserInteractionEnabled = false
        self.alpha = 0
        
    }
    
    
}

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
