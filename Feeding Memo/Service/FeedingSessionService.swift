//
//  FeedingSessionRepository.swift
//  Feeding Memo
//
//  Created by Mich W on 19/01/2019.
//  Copyright © 2019 Mich W. All rights reserved.
//

import Foundation

public class FeedingSessionService {
    
    private var feedingSessions : [FeedingSession] = []
    
    
    init() {
        feedingSessions = [
      
        ]
    }
     
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
