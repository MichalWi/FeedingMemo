//
//  FeedingSession.swift
//  Feeding Memo
//
//  Created by Mich W on 19/01/2019.
//  Copyright © 2019 Mich W. All rights reserved.
//

import Foundation

public enum Side : String, Codable{
    case Left
    case Right
    case DontRemember
}



public struct FeedingSession: Codable {
    
    
    let Id : FeedingSessionId
    let Side : Side
    let Duration : Int
    
    let StartTime : Date
    let EndTime : Date
    
    
    
    init(Id : FeedingSessionId, side : Side, duration: Int, endTime : Date){
        self.Id = Id
        
        self.EndTime = endTime
        self.StartTime = endTime.addingTimeInterval(TimeInterval.init(-60 * duration))
        self.Side = side
        
        if(duration == 0)
        {
            self.Duration = 1
        }else{ 
            self.Duration = duration
        }
   }
    
    public static func Create(side : Side, duration: Int, endTime : Date) -> FeedingSession{
        return FeedingSession(Id: FeedingSessionId(Id: Date()), side: side, duration: duration, endTime: endTime)
    }
    
    public func toTextRepresentation() -> String {
        
        return "From \(HourFormatter.formatDate(StartTime)) To \(HourFormatter.formatDate(EndTime)) (\(Duration) min) on \(Side) side"
    }
}

public struct FeedingSessionId : Codable{
    private let Id : Date
    
    init(Id : Date) {
        self.Id = Id
    }
    
    static func ==(A : FeedingSessionId, B : FeedingSessionId) -> Bool {
        return A.Id == B.Id;
    }

    
}
 
