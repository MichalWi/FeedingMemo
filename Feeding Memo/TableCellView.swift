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
   
    @IBOutlet weak var trailingProgressConstraint: NSLayoutConstraint!
    @IBOutlet weak var MainHour: UILabel!
    @IBOutlet weak var NextHour: UILabel!
    @IBOutlet weak var ProgressView: UIView!
    @IBOutlet weak var ProgressLabel: UILabel!
    
    override public func prepareForReuse() {
        MainHour.text = ""
        NextHour.text = ""
        ProgressView.backgroundColor = .white
        ProgressLabel.text = ""
    }
    
    public func set(feedingSession : FeedingSession){
        MainHour.text = HourFormatter.formatDate(feedingSession.EndTime)
        NextHour.text = HourFormatter.formatDate(feedingSession.EndTime.addingTimeInterval(TimeInterval(exactly: 60 * 60 * const.feedInterval) ?? 0 ))
        
        if(feedingSession.Duration > 10) {
            ProgressView.backgroundColor = .green
        }else{
            ProgressView.backgroundColor = .red
        }
         
        ProgressLabel.text = "\(feedingSession.Duration) min"
        
        adujstBar(duration: feedingSession.Duration)
    }
    
    private func adujstBar(duration : Int){
        
        
        let maxSubtractValue = CGFloat(ProgressView.frame.width)
        
        let ratio = (CGFloat(duration) / CGFloat(const.prefferedFeedTime))
      
        
        let valToSubtract =  maxSubtractValue - (maxSubtractValue * ratio)
        
        
        trailingProgressConstraint.constant = (valToSubtract) + 16;
        
         self.updateConstraints()
    }
}
