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

public class TablePlaceholderCellView: UITableViewCell {
     
    @IBOutlet weak var MainHour: UILabel!
    
    
    
    public func set(feedingSession : FeedingSession, timeSinceLast : Int){
        MainHour.text = HourFormatter.formatDate(feedingSession.EndTime)
//        NextHour.text = HourFormatter.formatDate(feedingSession.EndTime.addingTimeInterval(TimeInterval(exactly: 60 * 60 * const.feedInterval) ?? 0 ))
//        
      
     
    }
    
    private func getProgressFloat(duration : Int) -> Float{
         
        return (Float(duration) / Float(const.prefferedFeedTime))
        
    }
}
