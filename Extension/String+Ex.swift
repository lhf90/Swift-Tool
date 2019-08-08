//
//  String+Ex.swift
//  BiddingTool
//
//  Created by 木子 on 2019/4/11.
//  Copyright © 2019 木子. All rights reserved.
//

import Foundation

extension String {
    
    //base64编码
    func base64Encoding() -> String {
        guard let data = self.data(using: .utf8) else { return "" }
        let base64 = data.base64EncodedString()
        return base64
    }
    //base64解码
    func base64Decoding() -> String {
        guard let data = Data.init(base64Encoded: self, options: .init(rawValue: 0)) else { return "" }
        guard let decoding = String(data: data, encoding: .utf8) else { return "" }
        return decoding
    }
}

extension String {
    
    func translateToNoSecondTime() -> String {
        
        guard !self.isEmpty else {
            return ""
        }
        var temp = self
        if temp.hasSuffix(".0") {
            temp.removeLast()
            temp.removeLast()
        }
        guard let date = Date.conversionToTime(from: temp) else { return temp }
        return Date.conversionToStringNotSecond(date)
    }
}
