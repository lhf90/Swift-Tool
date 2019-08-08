//
//  RegularTool.swift
//  ChinaBidding
//
//  Created by 木子 on 2019/6/6.
//  Copyright © 2019 木子. All rights reserved.
//

import Foundation

class RegularTool {
    
    static func isEmail(email: String) -> Bool {
        
        let regex = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}"
        let pre = NSPredicate.init(format: "SELF MATCHES %@" , regex)
        return pre.evaluate(with:email)
    }
    
    static func isPhoneNum(phone: String) -> Bool {
        
        let regex = "^((\\d{3,4})|\\d{3,4}-|\\s)?\\d{7,14}$"
        let pre = NSPredicate.init(format: "SELF MATCHES %@" , regex)
        return pre.evaluate(with:phone)
    }
 
    static func isTelephone(tel: String) ->  Bool {
        
        let regex = "^1[0-9]{10}$"
        let pre = NSPredicate.init(format: "SELF MATCHES %@" , regex)
        return pre.evaluate(with:tel)
    }
    
    static func isIdCard(idCard: String) -> Bool {
        
        let regex = "(^\\d{15}$)|(^\\d{18}$)|(^\\d{17}(\\d|X|x)$)"
        let pre = NSPredicate.init(format: "SELF MATCHES %@" , regex)
        return pre.evaluate(with:idCard)
    }
    
    static func isOrganizationCode(origanization: String) -> Bool {
        
        let regex = "[1-9A-GY]{1}[1239]{1}[1-5]{1}[0-9]{5}[0-9A-Z]{10}"
        let pre = NSPredicate.init(format: "SELF MATCHES %@" , regex)
        return pre.evaluate(with:origanization)
    }
    
}
