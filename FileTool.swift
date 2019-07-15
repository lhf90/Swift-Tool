//
//  FileTool.swift
//  BiddingTool
//
//  Created by 木子 on 2019/6/19.
//  Copyright © 2019 木子. All rights reserved.
//

import Foundation

enum FileType:String {
    case other = ""
    case pdf   = "pdf"
    case epub  = "epub"
    case zip   = "zip"
    case rar   = "rar"
    case png   = "png"
    case jpg   = "jpg"
    case jpeg  = "jpeg"
    case txt   = "txt"
    case doc   = "doc"
    case docx  = "docx"
    case xlsx  = "xlsx"
    case xls   = "xls"
    case ppt   = "ppt"
    case wps   = "wps"
    
}

class FileTool: NSObject {
    
    //MARK: 创建文件夹📁
    static func createDirectory(atPath path: String) -> Bool {
        
        let document = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0]
        let fileM = FileManager.default
        let dicPath = document.appending("/\(path)")
        do {
            try fileM.createDirectory(atPath: dicPath, withIntermediateDirectories: true, attributes: nil)
            return true
        } catch {
            return false
        }
    }
    
    //MARK: 创建文件📃
    static func createFile(filename: String, atPath path: String?) -> (Bool, String){
        
        var filePath = ""
        if path == nil {
            let document = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0]
            filePath = document.appending("/\(filename)")
        } else {
            filePath = path!.appending("/\(filename)")
        }
        let fileM = FileManager.default
        if !fileM.fileExists(atPath: filePath) {
            let isSuccess = fileM.createFile(atPath: filePath, contents: nil, attributes: nil)
            return (isSuccess, filePath)
        } else {
            return (true, filePath)
        }
    }
    
    //MARK: 写入文件
    static func writeFile(_ data: AnyObject, atPath path: String) -> Bool {
        return data.write(toFile: path, atomically: true)
    }
    
    //MARK: 读取文件
//    static func readFileContent(atPath path: String) -> AnyObject {
//
//    }
    
    //MARK: 获取指定路径文件size
    static func size(filePath: String) -> CGFloat {
        
        var size: CGFloat = 0
        let fileM = FileManager.default
        var isDirectory: ObjCBool = false
        guard fileM.fileExists(atPath: filePath, isDirectory: &isDirectory) else {
            return size
        }
        if isDirectory.boolValue {
            
            let enumerator = fileM.enumerator(atPath: filePath)
            enumerator?.forEach({ (fileName) in
                
                let subPath = filePath.appending("/\(fileName)")
                do {
                    let attr = try fileM.attributesOfItem(atPath: subPath)
                    size += attr[FileAttributeKey.size] as! CGFloat
                } catch  {
                    print("error: \(error.localizedDescription)")
                }
            })
        } else {
            do {
                let attr = try fileM.attributesOfItem(atPath: filePath)
                size += attr[FileAttributeKey.size] as! CGFloat
            } catch  {
                print("error: \(error.localizedDescription)")
            }
        }
        return size
    }
    
    //MARK: 清除指定路径文件
    static func clear(filePath: String, completion: @escaping () -> Void) {
        
        let fileM = FileManager.default
        DispatchQueue.global().async {
            try? fileM.removeItem(atPath: filePath)
//            var isDirectory: ObjCBool = false
//            if fileM.fileExists(atPath: filePath, isDirectory: &isDirectory) {
//                try? fileM.removeItem(atPath: filePath)
//            }
//            if isDirectory.boolValue {
//                try? fileM.createDirectory(atPath: filePath, withIntermediateDirectories: true, attributes: nil)
//            }
            DispatchQueue.main.async {
                completion()
            }
        }
        
    }
    
    //MARK: Size转换
    static func convert(size: CGFloat) -> String {
        
        assert(size >= 0, "size不能小于0")
        let kb: CGFloat = 1000
        let mb: CGFloat = kb * 1000
        let gb: CGFloat = mb * 1000
        if size >= gb {
            return String(format: "%.1f G", size / gb)
        } else if size >= mb {
            return String.init(format: "%.1f M", size / mb)
        } else if size >= kb {
            return String.init(format: "%.1f K", size / kb)
        } else if size > 0 {
            return "\(size)B"
        } else {
            return "0B"
        }
    }

    //MARK: 获取文件后缀
    static func type(forPath path: String) -> String {
        return NSString.init(string: path).pathExtension
    }
    
    //MARK: 获取文件类型图片
    static func image(of type: FileType) -> UIImage? {
        
        switch type {
        case .doc, .docx:
            return UIImage.init(named: "icon_doc")
        case .xlsx, .xls:
            return UIImage.init(named: "icon_xls")
        case .ppt:
            return UIImage.init(named: "icon_ppt")
        case .wps:
            return UIImage.init(named: "icon_wps")
        case .txt:
            return UIImage.init(named: "icon_txt")
        case .pdf, .epub:
            return UIImage.init(named: "icon_pdf")
        case .zip:
            return UIImage.init(named: "icon_zip")
        case .rar:
            return UIImage.init(named: "icon_rar")
        case .png:
            return UIImage.init(named: "icon_png")
        case .jpg, .jpeg:
            return UIImage.init(named: "icon_jpg")
        default:
            return UIImage.init(named: "icon_file")
        }

    }
}
