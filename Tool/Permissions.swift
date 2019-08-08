//
//  Permissions.swift
//  ChinaBidding
//
//  Created by 木子 on 2019/6/6.
//  Copyright © 2019 木子. All rights reserved.
//

import Foundation
import UIKit
import Photos
import AVFoundation
import AssetsLibrary
import UserNotifications
import Contacts
import CoreLocation
import CoreTelephony

//MARK:通知权限
final class Permissions: NSObject {

    typealias authorizeCompletion = (Bool) -> Void

    //MARK:跳转系统设置
    private static func jumpToSystemPrivacySetting() {
        
        if let appSetting = URL(string: UIApplication.openSettingsURLString) {
            if #available(iOS 10.0, *) {
                UIApplication.shared.open(appSetting, options: [:], completionHandler: nil)
            } else {
                UIApplication.shared.openURL(appSetting)
            }
        }
    }
    //MARK:提示用户打开设置
    static func alertUserOpenSetting(_ title: String?, message: String?) {
        
        let alertVC = UIAlertController.init(title: title, message: message, preferredStyle: .alert)
        alertVC.addAction(UIAlertAction.init(title: "取消", style: .cancel, handler: nil))
        alertVC.addAction(UIAlertAction.init(title: .openSetting, style: .destructive, handler: { (UIAlertAction) in
            Permissions.jumpToSystemPrivacySetting()
        }))
        let delegate = UIApplication.shared.delegate as! AppDelegate
        delegate.window?.rootViewController?.present(alertVC, animated: true, completion: nil)
        
    }
    //MARK:通知权限
    static func authorizeNotificationPermissions(completion: @escaping authorizeCompletion) {
        
        if #available(iOS 10.0, *) {
            UNUserNotificationCenter.current().getNotificationSettings { (setting) in
                
                switch setting.authorizationStatus {
                case .authorized:
                    completion(true)
                case .denied:
                    alertUserOpenSetting(.notificationTitle, message: .notificationMessage)
                    completion(false)
                case .notDetermined:
                    UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound, .badge], completionHandler: { (granted, error) in
                        completion(granted)
                    })
                case .provisional:
                    completion(true)
                @unknown default:
                    completion(false)
                }
            }
        }
    }
    //MARK:相册权限     Privacy - Photo Library Usage Description APP上传照片需要使用您的相册
    static func authorizePhoto(completion: @escaping authorizeCompletion) {
        
        let granted:PHAuthorizationStatus = PHPhotoLibrary.authorizationStatus()
        switch granted {
        case .authorized:
            completion(true)
        case .denied, .restricted:
            alertUserOpenSetting(.photoTitle, message: .photoMessage)
            completion(false)
        case .notDetermined:
            PHPhotoLibrary.requestAuthorization { (status) in
                DispatchQueue.main.async {
                    completion(status == .authorized)
                }
            }
        @unknown default:
            completion(false)
        }
    }
    //MARK:相机权限     Privacy - Camera Usage Description APP扫一扫需要使用您的相机
    static func authorizeCamera(completion: @escaping authorizeCompletion) {
        
        let granted = AVCaptureDevice.authorizationStatus(for: .video)
        switch granted {
        case .authorized:
            completion(true)
        case .denied, .restricted:
            alertUserOpenSetting(.caremaTitle, message: .caremaMessage)
            completion(false)
        case .notDetermined:
            AVCaptureDevice.requestAccess(for: .video) { (granted) in
                DispatchQueue.main.async {
                    completion(granted)
                }
            }
        @unknown default:
            completion(false)
        }
    }
    //MARK:麦克风权限     Privacy - Microphone Usage Description
    static func authorizeAudio(completion: @escaping authorizeCompletion) {
        
        let granted = AVAudioSession.sharedInstance().recordPermission
        switch granted {
        case .granted:
            completion(true)
        case .denied:
            alertUserOpenSetting(.microphoneTitle, message: .microphoneMessage)
            completion(false)
        case .undetermined:
            AVAudioSession.sharedInstance().requestRecordPermission { (granted) in
                DispatchQueue.main.async {
                    completion(granted)
                }
            }
        @unknown default:
            completion(false)
        }
    }
    //MARK:通讯录权限        Privacy - Contacts Usage Description
    static func authorizeContact(completion: @escaping authorizeCompletion) {
        
        let granted = CNContactStore.authorizationStatus(for: .contacts)
        switch granted {
        case .authorized:
            completion(true)
        case .denied, .restricted:
            alertUserOpenSetting(.contactTitle, message: .contactMessage)
            completion(false)
        case .notDetermined:
            CNContactStore().requestAccess(for: .contacts) { (granted, error) in
                completion(granted)
            }
        @unknown default:
            completion(false)
        }
    }
    //MARK:Face ID权限     Privacy - Face ID Usage Description
    static func authorizeFaceID(completion: @escaping authorizeCompletion) {
        
        let granted = AVCaptureDevice.authorizationStatus(for: .audio)
        switch granted {
        case .authorized:
            completion(true)
        case .denied, .restricted:
            alertUserOpenSetting(.microphoneTitle, message: .microphoneMessage)
            completion(false)
        case .notDetermined:
            AVCaptureDevice.requestAccess(for: .audio) { (granted) in
                DispatchQueue.main.async {
                    completion(granted)
                }
            }
        @unknown default:
            completion(false)
        }
    }
    //MARK:开启定位权限 BUG Privacy - Location Always Usage Description | Privacy - Location When In Use Usage Description
    static func authorizeLocationService(completion: @escaping authorizeCompletion) {
        
        if !CLLocationManager.locationServicesEnabled() {
            print("not turn on the location")
            completion(false)
            return
        }
        let granted = CLLocationManager.authorizationStatus()
        switch granted {
        case .authorizedAlways:
            completion(true)
        case .authorizedWhenInUse:
            completion(true)
        case .denied, .restricted:
            completion(false)
        case .notDetermined:
            CLLocationManager.init().requestAlwaysAuthorization()
            CLLocationManager.init().requestWhenInUseAuthorization()
        @unknown default:
            completion(false)
        }
    }
    //MARK:联网权限
    static func authorizeNetworkService(completion: @escaping authorizeCompletion) {
        
        CTCellularData().cellularDataRestrictionDidUpdateNotifier = {(state) in
            
            switch state {
            case .restricted, .restrictedStateUnknown:
                completion(false)
            case .notRestricted:
                completion(true)
            @unknown default:
                completion(false)
            }
        }
    }
    //MARK:联网功能
    static func networking(completion: @escaping authorizeCompletion) {
        
        let state = CTCellularData().restrictedState
        switch state {
        case .notRestricted, .restricted:
            completion(false)
        case .restrictedStateUnknown:
            completion(true)
        @unknown default:
            completion(false)
        }
    }
    
}

extension String {
    
    static let openSetting         = "前往设置"
    static let caremaTitle         = "无法使用相机"
    static let caremaMessage       = "请在iPhone的\"设置-隐私-相机\"中允许访问相机"
    static let photoTitle          = "无法查看照片"
    static let photoMessage        = "请在iPhone的\"设置-隐私-照片\"中允许访问照片"
    static let notificationTitle   = "您未打开通知"
    static let notificationMessage = "请在iPhone的\"设置-隐私-通知\"中允许通知"
    static let contactTitle        = "无法访问通讯录"
    static let contactMessage      = "请在iPhone的\"设置-隐私-通讯录\"中允许访问通讯录"
    static let microphoneTitle     = "无法使用麦克风"
    static let microphoneMessage   = "请在iPhone的\"设置-隐私-麦克风\"中允许使用麦克风"
    static let faceIDTitle         = "无法使用FaceID"
    static let faceIDMessage       = "请在iPhone的\"设置-隐私-FaceID\"中允许使用FaceID"
}
