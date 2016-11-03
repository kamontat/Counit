//
//  Time.swift
//  Counit
//
//  Created by kamontat chantrachirathumrong on 11/4/2559 BE.
//  Copyright © 2559 kamontat chantrachirathumrong. All rights reserved.
//

import Foundation

class Time {
    class func getCurrentTime() -> String {
        let currentDateTime = Date()
        
        let formatter = DateFormatter()
        
        formatter.timeStyle = .short
        formatter.dateStyle = .short
        
        return formatter.string(from: currentDateTime)
    }
}
