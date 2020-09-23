//
//  LineUtils.swift
//  LineDevices
//
//  Created by Nikolay Tkachenko on 22.09.2020.
//

import Foundation
import UIKit

class LineUtils: Any {
    class func randomNumberBetweenOneAndSix() -> Int {
        return Int(arc4random_uniform(UInt32(5))) + 1
    }
}
