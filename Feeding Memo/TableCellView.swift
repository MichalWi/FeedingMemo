//
//  TableViewCell.swift
//  Feeding Memo
//
//  Created by Mich W on 19/01/2019.
//  Copyright © 2019 Mich W. All rights reserved.
//

import Foundation
import UIKit
import SwiftDate

private struct const {
    public static let feedInterval = 3
    public static let prefferedFeedTime = 60
}

public class TableCellView: UITableViewCell {
    
    @IBOutlet weak var LeftArrow: UIImageView!
    @IBOutlet weak var RightArrow: UIImageView!
    @IBOutlet weak var MainHour: UILabel!
    @IBOutlet weak var ProgressBar: UIProgressView!
    @IBOutlet weak var ProgressLabel: UILabel!
    @IBOutlet weak var NextLabel: UILabel!
    
    @IBOutlet weak var cellCellBgView: UIImageView!
    @IBOutlet weak var cellCellHeight: NSLayoutConstraint!
    override public func prepareForReuse() {
        MainHour?.text = "" 
        ProgressLabel?.text = ""
    }
    
    public func set(feedingSession : FeedingSession, prevFeeding : Date, isOnTop : Bool){
        MainHour.text = HourFormatter.formatDate(feedingSession.EndTime)
        
        NextLabel.text = feedingSession.colloquialTimeAgo()
        
        ProgressBar.progress = getProgressFloat(duration: feedingSession.Duration)
        
        ProgressLabel.text = "Duration".localized + ": \(feedingSession.Duration) min"
        
 
        if feedingSession.Side == .Left {
            LeftArrow.tintColor = UIColor(named : "pinkishTan")
            RightArrow.tintColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
        } else if feedingSession.Side == .Right {
            LeftArrow.tintColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
            RightArrow.tintColor = UIColor(named : "pinkishTan")
            
        }
        
        NextLabel.isHidden = !isOnTop
        cellCellHeight.constant = isOnTop ? 47 : 35
       
        cellCellBgView.image = UIImage(named:  (isOnTop ? "buttonBgLarge" : "buttonBg"))
        
        
        self.backgroundColor = UIColor.clear
        RightArrow.transform = CGAffineTransform(scaleX: -1, y: 1);
    }
    
   
    private func getProgressFloat(duration : Int) -> Float{
         
        return (Float(duration) / Float(const.prefferedFeedTime))
        
    }
}
