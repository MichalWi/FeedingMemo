//
//  TableViewCell.swift
//  Feeding Memo
//
//  Created by Mich W on 19/01/2019.
//  Copyright © 2019 Mich W. All rights reserved.
//

import Foundation
import UIKit

private struct const {
    public static let feedInterval = 3
    public static let prefferedFeedTime = 60
}

public class TableCellView: UITableViewCell {
    
    @IBOutlet weak var MainHour: UILabel!
    @IBOutlet weak var NextHour: UILabel!
    @IBOutlet weak var ProgressBar: UIProgressView!
    @IBOutlet weak var ProgressLabel: UILabel!
    
    override public func prepareForReuse() {
        MainHour.text = ""
        NextHour.text = ""
        ProgressLabel.text = ""
    }
    
    public func set(feedingSession : FeedingSession){
        MainHour.text = HourFormatter.formatDate(feedingSession.EndTime)
        NextHour.text = HourFormatter.formatDate(feedingSession.EndTime.addingTimeInterval(TimeInterval(exactly: 60 * 60 * const.feedInterval) ?? 0 ))
        
        if(feedingSession.Duration > 10) {
            ProgressBar.tintColor = .green
        }else{
            ProgressBar.tintColor = .red
        }
        
        ProgressBar.progress = getProgressFloat(duration: feedingSession.Duration)
        
        ProgressLabel.text = "\(feedingSession.Duration) min"
        
    }
    
    private func getProgressFloat(duration : Int) -> Float{
         
        return (Float(duration) / Float(const.prefferedFeedTime))
        
    }
}
