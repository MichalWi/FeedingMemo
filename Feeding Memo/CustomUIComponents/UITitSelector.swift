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

class UITitSelector : CircleMenu {
    
    public init(frame: CGRect) {
        super.init(
            frame: frame,
            normalIcon:"plus",
            selectedIcon:"plusFilled",
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
