//
//  FeedingSessionRepository.swift
//  Feeding Memo
//
//  Created by Mich W on 19/01/2019.
//  Copyright © 2019 Mich W. All rights reserved.
//

import Foundation
import Disk

public class FeedingSessionService {
    
    private var feedingSessions : [FeedingSession] = []
    
    
    init() {
        let data = try? Disk.retrieve("feedingSessions.json", from: Disk.Directory.documents, as: [FeedingSession].self)
        
        if data != nil {
            feedingSessions = data!
        }
    }
    
    public func GetFeedingSessions() -> [FeedingSession] {
       
        return feedingSessions.sorted() {
            $1.EndTime < $0.EndTime
        }
    }
    
    public func AddFeedingSession(_ sessionToAdd : FeedingSession) {
        
       
        
        feedingSessions.append(sessionToAdd)
        
        try? Disk.save(feedingSessions, to: .documents, as: "feedingSessions.json")
    }
    
    public func RemoveFeedingSession(_ withId : FeedingSessionId){
        
        let toDeleteIdx = feedingSessions.index { (f) -> Bool in
            f.Id == withId
        }
        
        feedingSessions.remove(at: toDeleteIdx!)
        
        try! Disk.save(feedingSessions, to: .documents, as: "feedingSessions.json")
    }
    
}
