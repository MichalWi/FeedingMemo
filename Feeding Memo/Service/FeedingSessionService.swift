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
            FeedingSession.Create(side: .Left, duration: 60, endTime: Date()),
            FeedingSession.Create(side: .Left, duration: 60, endTime: Date())
        ]
    }
    
    private var feedingSessions : [FeedingSession] = []
    
    public func GetFeedingSessions() -> [FeedingSession] {
       
        return feedingSessions
    }
    
    public func AddFeedingSession(_ sessionToAdd : FeedingSession) {
        feedingSessions.append(sessionToAdd)
    }
    
    public func RemoveFeedingSession(_ withId : FeedingSessionId){
        
        feedingSessions.removeAll(where: { $0.Id == withId })
    }
    
}
