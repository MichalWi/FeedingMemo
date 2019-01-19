//
//  FeedingSession.swift
//  Feeding Memo
//
//  Created by Mich W on 19/01/2019.
//  Copyright © 2019 Mich W. All rights reserved.
//

import Foundation

public enum Side : String {
    case Left
    case Right
    case DontRemember
}



public struct FeedingSession {
    
    
    let Id : FeedingSessionId
    let Side : Side
    let Duration : Int
    
    let StartTime : Date
    let EndTime : Date
    
    
    
    init(Id : FeedingSessionId, side : Side, duration: Int, endTime : Date){
        self.Id = Id
        
        self.EndTime = endTime
        self.StartTime = endTime.addingTimeInterval(TimeInterval.init(-60 * duration))
        self.Duration = duration
        self.Side = side
   }
    
    public static func Create(side : Side, duration: Int, endTime : Date) -> FeedingSession{
        return FeedingSession(Id: FeedingSessionId(Id: Date()), side: side, duration: duration, endTime: endTime)
    }
    
    public func toTextRepresentation() -> String {
        
        return "From \(HourFormatter.formatDate(StartTime)) To \(HourFormatter.formatDate(EndTime)) (\(Duration) min) on \(Side) side"
    }
}

public struct FeedingSessionId {
    private let Id : Date
    
    init(Id : Date) {
        self.Id = Id
    }
    
    static func ==(A : FeedingSessionId, B : FeedingSessionId) -> Bool {
        return A.Id == B.Id;
    }

    
}
 
