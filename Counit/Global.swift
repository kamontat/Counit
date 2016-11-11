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
    static var colorDiff: Int = 5
    static var isAuto: Bool = true;
    static var increase: Int = 1;
    
    static private let most: UIColor = UIColor.blue
    static private let more: UIColor = UIColor.green
    static private let normal: UIColor = UIColor.black
    static private let less: UIColor = UIColor.yellow
    static private let least: UIColor = UIColor.red
    
    class func setColor(first: Int, second: Int) -> [UIColor] {
        let between = first - second;
        
        if between > colorDiff*2 {
            return [most, least]
        } else if between > colorDiff {
            return [more, less]
        } else if between < -colorDiff*2 {
            return [least, most]
        } else if between < -colorDiff {
            return [less, more]
        } else {
            return [normal, normal]
        }
    }
}
