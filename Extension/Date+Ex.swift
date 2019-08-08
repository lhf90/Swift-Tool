//
//  NSDate+Ex.swift
//  BiddingTool
//
//  Created by 木子 on 2019/2/18.
//  Copyright © 2019 木子. All rights reserved.
//

import Foundation.Date

extension Date {
    
    //yyyy:年
    //MM:月  M:1 MMM:Oct MMMM:月份全写(October)
    //dd:日  d
    //HH:时(24)  hh:时(12) h H
    //mm:分  m
    //ss:秒
    //EEEE:星期几(Monday) EEE:Mon
    
    enum DateStyle {
        case all                    //年月日时分秒
        case yearMonthDayHourMinute //年月日时分
        case yearMonthDay           //年月日
        case yearMonth              //年月
        case year                   //年
    }
    
    //MARK:Date转时间字符串
    static func conversionDateToString(date: Date, style: DateStyle) -> String {
        
        let fm = DateFormatter.init()
        switch style {
        case .all:
            fm.dateFormat = "yyyy-MM-dd HH:mm:ss"
        case .yearMonthDayHourMinute:
            fm.dateFormat = "yyyy-MM-dd HH:mm"
        case .yearMonthDay:
            fm.dateFormat = "yyyy-MM-dd"
        case .yearMonth:
            fm.dateFormat = "yyyy-MM"
        case .year:
            fm.dateFormat = "yyyy"
        }
        return fm.string(from: date)
    }
    
    //MARK:时间字符串转Date
    static func conversionStringToDate(time: String) -> Date? {
        
        let fm = DateFormatter.init()
        fm.dateFormat = "yyyy-MM-dd HH:mm:ss"
        if let date = fm.date(from: time) {
            return date
        }
        fm.dateFormat = "yyyy-MM-dd HH:mm"
        if let date = fm.date(from: time) {
            return date
        }
        fm.dateFormat = "yyyy-MM-dd"
        if let date = fm.date(from: time) {
            return date
        }
        fm.dateFormat = "yyyy-MM"
        if let date = fm.date(from: time) {
            return date
        }
        fm.dateFormat = "yyyy"
        if let date = fm.date(from: time) {
            return date
        }
        if let date = fm.date(from: time) {
            return date
        }
        return nil
    }
    
    //MARK:时间戳转时间字符串
    static func conversionStampToString(stamp: TimeInterval, style: DateStyle) -> String {
        
        let date = Date.init(timeIntervalSince1970: stamp)
        return Date.conversionDateToString(date: date, style: style)
    }
    
    //MARK:Date转时间戳
    static func conversionToStamp(from date: Date) -> TimeInterval {
        
        return date.timeIntervalSince1970
    }
    
    //MARK:获取当前时间字符串
    static func getCurrentTime() -> String {
        return Date.conversionDateToString(date: Date(), style: .all)
    }
    
    //MARK:获取当前时间Date
    static func getCurrentDate() -> Date {
        
        let interval = NSTimeZone.system.secondsFromGMT()
        return Date().addingTimeInterval(TimeInterval(interval))
    }
    
    //MARK:获取当前时间戳
    static func getCurrentTimeStamp() -> TimeInterval {
        
        let date = Date()
        return date.timeIntervalSince1970 * 1000
    }
}

