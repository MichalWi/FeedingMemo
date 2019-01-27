//
//  ReminderService.swift
//  Feeding Memo
//
//  Created by Mich W on 26/01/2019.
//  Copyright © 2019 Mich W. All rights reserved.
//

import Foundation

import UserNotifications

import SwiftDate

class FeedingTime {
    
    let feedingSession : FeedingSession
    
    init(feedingSession : FeedingSession) {
        self.feedingSession = feedingSession
    }
    
    public func nextFeedingInterval() -> TimeInterval {
        return self.feedingSession.EndTime.addingTimeInterval(3.hours.timeInterval).timeIntervalSinceNow
    }
    
    public func redableNextFeedingInterval() -> String {
        
        let interval = nextFeedingInterval()
        
        return interval.toString {
            $0.maximumUnitCount = 4
            $0.allowedUnits = [.day, .hour, .minute]
            $0.collapsesLargestUnit = true
            $0.unitsStyle = .short
        }
        
    }
    
    public static func defaultNextFeedingTime() -> TimeInterval {
        return FeedingTime(feedingSession: FeedingSession.Create(side: .DontRemember, duration: 0, endTime: Date())).nextFeedingInterval()
    }
    
    public static func defaultRedableNextFeedingTime() -> String {
        return FeedingTime(feedingSession: FeedingSession.Create(side: .DontRemember, duration: 0, endTime: Date())).redableNextFeedingInterval()
    }
}

class ReminderService {
    
    
    public func getNextReminderTime(found : @escaping (String?)-> ())  {
        
        UNUserNotificationCenter.current().getPendingNotificationRequests(completionHandler: {
            let reminderPending = $0.first{
                $0.identifier == "FeedingReminder"
            }
            if(reminderPending != nil) {
                
                let localTrigger = reminderPending?.trigger  as! UNTimeIntervalNotificationTrigger
                
                let interval = localTrigger.timeInterval.toString {
                    $0.maximumUnitCount = 4
                    $0.allowedUnits = [.day, .hour, .minute]
                    $0.collapsesLargestUnit = true
                    $0.unitsStyle = .short
                }
                found(interval)
            }else {
                found(nil)
                
            }
            
        })
        
    }
    
    public func addFeedingReminder(fromSession session: FeedingSession?) {
        removeReminder()
        if(session != nil){
            var interval = FeedingTime(feedingSession: session!).nextFeedingInterval()
            
            if interval < 0 {
                interval = FeedingTime.defaultNextFeedingTime()
            }
            
            addReminder(remindMeIn: interval)
        }  else{
            let interval = FeedingTime.defaultNextFeedingTime()
            addReminder(remindMeIn: interval)
        }
        
    }
    public func removeReminder() {
        UNUserNotificationCenter.current().removePendingNotificationRequests(withIdentifiers: ["FeedingReminder"])
    }
    private func addReminder(remindMeIn interval : TimeInterval) {
        
        
        //Seeking permission of the user to display app notifications
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert,.sound,.badge], completionHandler: {didAllow,Error in })
        
        let content = UNMutableNotificationContent()
        content.title = "Feeding Memo!".localized
        content.body = "3 hours passed since last feeding sesion".localized
        content.categoryIdentifier = "message"
        
        
        
        
        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: interval, repeats: false)
        
        
        let request = UNNotificationRequest.init(identifier: "FeedingReminder", content: content, trigger: trigger)
        // Schedule the notification.
        
        UNUserNotificationCenter.current().add(request, withCompletionHandler: {(_ error: Error?) -> Void in
            if error == nil {
                
                
            }
        })
        
    }
    
}
