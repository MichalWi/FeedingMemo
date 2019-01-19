//
//  HourFormatter.swift
//  Feeding Memo
//
//  Created by Mich W on 19/01/2019.
//  Copyright © 2019 Mich W. All rights reserved.
//

import Foundation

public class HourFormatter {
    
    private static let dateFormatter = DateFormatter()
    private static var isInitialized : Bool = false
    
    public static func formatDate(_ date : Date) -> String {
        
        if(!isInitialized){
            dateFormatter.dateFormat = "HH:mm"
            isInitialized = true
        }
        
        return dateFormatter.string(from: date)
    }
}
