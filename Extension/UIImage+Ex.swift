//
//  UIImage+Ex.swift
//  BiddingTool
//
//  Created by 木子 on 2019/6/18.
//  Copyright © 2019 木子. All rights reserved.
//

import UIKit.UIImage

extension UIImage {
    
    static func fixOrientation(image: UIImage) -> UIImage? {

        switch image.imageOrientation {
        case .up, .upMirrored:
            return image
        default:
            UIGraphicsBeginImageContext(image.size)
            image.draw(in: CGRect(origin: .zero, size: image.size))
            if let newImage = UIGraphicsGetImageFromCurrentImageContext() {
                return newImage
            }
            return nil
        }
    }
    
    /// 压缩图片大小
    static func compress(image: UIImage, maxByte: Int) -> UIImage? {
        
        let maxBytes = maxByte * 1000
        var compression: CGFloat = 1
        guard var data = image.jpegData(compressionQuality: compression) else {
            return nil
        }
        if data.count < maxBytes {
            return image
        }
        var max: CGFloat = 1
        var min: CGFloat = 0
        compression = pow(2, -6)
        for _ in 0..<6 {
            compression = (max + min) / 2
            data = image.jpegData(compressionQuality: compression)!
            if CGFloat(data.count) < CGFloat(maxBytes) * 0.9 {
                min = compression
            } else if data.count > maxBytes {
                max = compression
            } else {
                break
            }
        }
        var resultImage: UIImage = UIImage(data: data)!
        if data.count < maxBytes {
            return resultImage
        }
        // Compress by size
        var lastDataLength: Int = 0
        while data.count > maxBytes, data.count != lastDataLength {
            lastDataLength = data.count
            let ratio: CGFloat = CGFloat(maxBytes) / CGFloat(data.count)
            let size: CGSize = CGSize(width: Int(resultImage.size.width * sqrt(ratio)),
                                      height: Int(resultImage.size.height * sqrt(ratio)))
            UIGraphicsBeginImageContext(size)
            resultImage.draw(in: CGRect(x: 0, y: 0, width: size.width, height: size.height))
            resultImage = UIGraphicsGetImageFromCurrentImageContext()!
            UIGraphicsEndImageContext()
            data = resultImage.jpegData(compressionQuality: compression)!
        }
        return resultImage
    }
    
    /// 压缩图片尺寸
    static func resetSize(image: UIImage, size: CGSize) -> UIImage? {
        
        UIGraphicsBeginImageContext(size)
        image.draw(in: CGRect(origin: .zero, size: size))
        if let newImage = UIGraphicsGetImageFromCurrentImageContext() {
            UIGraphicsEndImageContext()
            return newImage
        }
        return nil
    }
    
    /// 根据用户名生成头像Img
    static func acquireNameImage(name: String, size: CGSize) -> UIImage? {
        return UIImage.drawNameImage(name: UIImage.deal(nikeName: name), size: size)
    }
    
    ///根据颜色生成图片
    static func image(with color: UIColor, size: CGSize, cornerRadius: CGFloat) -> UIImage? {
        
        var imgSize = size
        if imgSize.equalTo(.zero) {
            imgSize = CGSize(width: 1, height: 1)
        }
        let rect = CGRect.init(origin: CGPoint.zero, size: imgSize)
        UIGraphicsBeginImageContextWithOptions(imgSize, false, UIScreen.main.scale)
        color.set()
        UIRectFill(rect)
        guard let img = UIGraphicsGetImageFromCurrentImageContext() else { return nil }
        UIGraphicsEndImageContext()
        
        UIGraphicsBeginImageContextWithOptions(imgSize, false, UIScreen.main.scale)
        UIBezierPath.init(roundedRect: rect, cornerRadius: cornerRadius).addClip()
        img.draw(in: rect)
        guard let newImg = UIGraphicsGetImageFromCurrentImageContext() else { return nil }
        UIGraphicsEndImageContext();
        return newImg
    }
    
    /// 根据名字绘制图片
    private static func drawNameImage(name: String, size: CGSize) -> UIImage? {
        
        let colors = ["17c295", "b38979", "f2725e", "f7b55e", "4da9eb", "5f70a7", "568aad"]
        guard let image = UIImage.image(with: UIColor.hex(colors[abs(name.hashValue % colors.count)]), size: size, cornerRadius: size.width / 2) else {
            return nil
        }
        UIGraphicsBeginImageContextWithOptions(size, false, 0)
        image.draw(at: .init(x: 0, y: 0))
        let contextRef = UIGraphicsGetCurrentContext()
        contextRef?.drawPath(using: .stroke)
        //画名字
        let names = NSString.init(string: name)
        let nameSize = names.size(withAttributes: [NSAttributedString.Key.font : UIFont.systemFont(ofSize: 14)])
        names.draw(at: CGPoint(x: (size.width - nameSize.width) / 2, y: (size.height - nameSize.height) / 2), withAttributes: [NSAttributedString.Key.font : UIFont.systemFont(ofSize: 14), NSAttributedString.Key.foregroundColor : UIColor.hex("ffffff")])
        guard let newImg = UIGraphicsGetImageFromCurrentImageContext() else { return nil }
        UIGraphicsEndImageContext()
        return newImg
    }
    
    /// 切割用户名
    private static func deal(nikeName: String) -> String {
        
        let set = CharacterSet.init(charactersIn: "【】")
        var name = nikeName.trimmingCharacters(in: set)
        if let range = name.range(of: "-") {
            name = String(name.prefix(upTo: range.lowerBound))
        }
        if let range = name.range(of: "(") {
            name = String(name.prefix(upTo: range.lowerBound))
        }
        if let regular = try? NSRegularExpression.init(pattern: "[A-Za-z]", options: .caseInsensitive),
            regular.numberOfMatches(in: name, options: .reportProgress, range: NSMakeRange(0, name.count)) > 0 {
            //含有字母
            return String(name.prefix(2))
        } else {
            //不含字母
            switch name.count {
            case 0, 1, 2:
                return name
            default:
                return String(name.suffix(2))
            }
        }
    }
}


