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
    
    enum Version: String {
        case ALPHA = "A"
        case BETA = "B"
        case RELEASE_CANDIDATE = "RC"
        case FINAL = "F"
    }
    
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
    
    class func getVersion() -> String {
        return Bundle.main.releaseVersionNumber!;
    }
    
    class func getBuild() -> String {
        return Bundle.main.buildVersionNumber!;
    }
    
    class func getStringVersion(verLabel: Version) -> String {
        return "\(getVersion())-\(verLabel.rawValue)\(getBuild())"
    }
}

extension Bundle {
    var releaseVersionNumber: String? {
        return infoDictionary?["CFBundleShortVersionString"] as? String
    }
    var buildVersionNumber: String? {
        return infoDictionary?["CFBundleVersion"] as? String
    }
}
