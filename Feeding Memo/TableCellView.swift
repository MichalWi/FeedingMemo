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
    @IBOutlet weak var NextHour: UILabel!
    @IBOutlet weak var ProgressBar: UIProgressView!
    @IBOutlet weak var ProgressLabel: UILabel!
    @IBOutlet weak var NextLabel: UILabel!
    
    @IBOutlet weak var DurationLabel: UILabel!
    override public func prepareForReuse() {
        MainHour.text = ""
        NextHour.text = ""
        ProgressLabel.text = ""
    }
    
    public func set(feedingSession : FeedingSession, prevFeeding : Date){
        MainHour.text = HourFormatter.formatDate(feedingSession.EndTime)
        
        if(feedingSession.Duration > 10) {
            ProgressBar.tintColor = UIColor(named : "SoftGeen")
            ProgressLabel.textColor = UIColor(named: "SoftGreenText")
        }else{
            ProgressBar.tintColor = UIColor(named: "SoftRed")
            ProgressLabel.textColor = UIColor(named: "SoftRedText")
        }
        
        
        DurationLabel.text = "\(feedingSession.colloquialTimeDistance(date: prevFeeding))"
        
        NextLabel.text = feedingSession.colloquialTimeAgo()
        
        ProgressBar.progress = getProgressFloat(duration: feedingSession.Duration)
        
        ProgressLabel.text = "Duration".localized + ": \(feedingSession.Duration) min"
        
        RightArrow.alpha = feedingSession.Side == .Left ? 0.3 : 1
        LeftArrow.alpha = feedingSession.Side == .Right  ? 0.3 : 1
        
    }
    
   
    
    private func getProgressFloat(duration : Int) -> Float{
         
        return (Float(duration) / Float(const.prefferedFeedTime))
        
    }
}
