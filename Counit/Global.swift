//
//  Global.swift
//  Counit
//
//  Created by kamontat chantrachirathumrong on 11/11/2559 BE.
//  Copyright © 2559 kamontat chantrachirathumrong. All rights reserved.
//

import Foundation
import UIKit

class Global {
    static var diff: Int = 5
    static var autoSave = true
    
    static private let most: UIColor = UIColor.blue
    static private let more: UIColor = UIColor.green
    static private let normal: UIColor = UIColor.black
    static private let less: UIColor = UIColor.yellow
    static private let least: UIColor = UIColor.red
    
    class func setColor(first: Int, second: Int) -> [UIColor] {
        let between = first - second;
        
        print("between: \(between), diff: \(diff)")
        
        if between > diff*2 {
            return [most, least]
        } else if between > diff {
            return [more, less]
        } else if between < -diff*2 {
            return [least, most]
        } else if between < -diff {
            return [less, more]
        } else {
            return [normal, normal]
        }
    }
}
