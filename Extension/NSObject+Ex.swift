//
//  NSObject+Ex.swift
//  BiddingTool
//
//  Created by 木子 on 2019/2/18.
//  Copyright © 2019 木子. All rights reserved.
//

import Foundation

extension NSObject {
    
    var className: String {

//        let name = String(describing: type(of: self))
        let name = type(of: self).description()
        if name.contains(".") {
            return name.components(separatedBy: ".")[1]
        } else {
            return name
        }
    }
}
