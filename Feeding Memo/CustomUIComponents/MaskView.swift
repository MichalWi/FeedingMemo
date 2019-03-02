//
//  MaskView.swift
//  Feeding Memo
//
//  Created by Mich W on 26/01/2019.
//  Copyright © 2019 Mich W. All rights reserved.
//

import Foundation

import UIKit

class MaskView : UIImageView {
    
    public required convenience init?(coder aDecoder: NSCoder) {
        self.init(coder: aDecoder)
        
    }
    public override init(frame: CGRect) {
        
        super.init(frame: frame)
        
        self.frame = frame
         
        self.image = #imageLiteral(resourceName: "mask")
        self.isUserInteractionEnabled = false
        self.alpha = 0
        
    }
    
    
}
public extension UIView {
    
    /// Fade in a view with a duration
    ///
    /// Parameter duration: custom animation duration
    func fadeIn(withDuration duration: TimeInterval = 0.2) {
        UIView.animate(withDuration: duration, animations: {
            self.alpha = 1.0
        })
    }
    
    /// Fade out a view with a duration
    ///
    /// - Parameter duration: custom animation duration
    func fadeOut(withDuration duration: TimeInterval = 0.2) {
        UIView.animate(withDuration: duration, animations: {
            self.alpha = 0.0
        })
    }
    
}
