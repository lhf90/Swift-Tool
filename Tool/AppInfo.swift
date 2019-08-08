//
//  AppInfo.swift
//  BiddingTool
//
//  Created by 木子 on 2019/6/20.
//  Copyright © 2019 木子. All rights reserved.
//

import Foundation

struct AppInfo {

    static let infoDictionary   = Bundle.main.infoDictionary
    static let appDisplayName   = Bundle.main.infoDictionary?["CFBundleDisplayName"] as? String ?? ""//App 名称
    static let bundleIdentifier = Bundle.main.bundleIdentifier ?? ""// Bundle Identifier
    static let appVersion       = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String ?? ""// App 版本号
    static let buildVersion     = Bundle.main.infoDictionary?["CFBundleVersion"] as? String ?? ""//Bulid 版本号
    
    // MARK: Device
    static let uuid             = UIDevice.current.identifierForVendor?.uuidString ?? ""//设备 udid

}
