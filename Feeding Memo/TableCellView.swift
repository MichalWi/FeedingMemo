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
        NextHour.text = HourFormatter.formatDate(feedingSession.EndTime.addingTimeInterval(TimeInterval(exactly: 60 * 60 * const.feedInterval) ?? 0 ))
        
        if(feedingSession.Duration > 10) {
            ProgressBar.tintColor = .green
        }else{
            ProgressBar.tintColor = .red
        }
        
        let a = DateInRegion(feedingSession.EndTime)
        let b = DateInRegion(prevFeeding)
    
        let interval = (b - a).toString {
            $0.maximumUnitCount = 4
            $0.allowedUnits = [.day, .hour, .minute]
            $0.collapsesLargestUnit = true
            $0.unitsStyle = .short
        }
        DurationLabel.text = "\(interval) gap"
        
        NextLabel.text = a.toRelative()
        
        ProgressBar.progress = getProgressFloat(duration: feedingSession.Duration)
        
        ProgressLabel.text = "Duration: \(feedingSession.Duration) min"
        
        RightArrow.alpha = feedingSession.Side == .Left ? 0.3 : 1
        LeftArrow.alpha = feedingSession.Side == .Right  ? 0.3 : 1
        
    }
    
    private func getProgressFloat(duration : Int) -> Float{
         
        return (Float(duration) / Float(const.prefferedFeedTime))
        
    }
}
