//
//  FeedingSessionRepository.swift
//  Feeding Memo
//
//  Created by Mich W on 19/01/2019.
//  Copyright © 2019 Mich W. All rights reserved.
//

import Foundation

public class FeedingSessionService {
    
    init() {
        feedingSessions = [
            FeedingSession.Create(side: .Left, duration: 45, endTime: Date().addingTimeInterval(-TimeInterval(60*60*3))) ,
            FeedingSession.Create(side: .Right, duration: 45, endTime: Date().addingTimeInterval(-TimeInterval(60*60*2))) ,
        
        ]
    }
    
    private var feedingSessions : [FeedingSession] = []
    
    public func GetFeedingSessions() -> [FeedingSession] {
       
        return feedingSessions.sorted() {
            $1.StartTime < $0.StartTime
        }
    }
    
    public func AddFeedingSession(_ sessionToAdd : FeedingSession) {
        feedingSessions.append(sessionToAdd)
    }
    
    public func RemoveFeedingSession(_ withId : FeedingSessionId){
        
        feedingSessions.removeAll(where: { $0.Id == withId })
    }
    
}
