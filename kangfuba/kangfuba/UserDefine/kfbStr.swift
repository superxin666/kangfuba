//
//  kfbStr.swift
//  kangfuba
//
//  Created by lvxin on 2016/10/24.
//  Copyright © 2016年 Xunqiu. All rights reserved.
//

import Foundation


extension String {


    /// 测文字的高度
    ///
    /// - parameter width: 宽度限制
    /// - parameter font:  字体
    ///
    /// - returns: 高度
    func heightWithConstrainedWidth(width: CGFloat, font: UIFont) -> CGFloat {
        let constraintRect = CGSize(width: width, height: CGFloat.greatestFiniteMagnitude)
        let boundingBox = self.boundingRect(with: constraintRect, options: NSStringDrawingOptions.usesLineFragmentOrigin, attributes: [NSFontAttributeName: font], context: nil)
        return boundingBox.height
    }
    
    func widthWithConstrainedWidth(height: CGFloat, font: UIFont) -> CGFloat {
        let constraintRect = CGSize(width:  CGFloat.greatestFiniteMagnitude, height: height)
        let boundingBox = self.boundingRect(with: constraintRect, options: NSStringDrawingOptions.usesLineFragmentOrigin, attributes: [NSFontAttributeName: font], context: nil)
        return boundingBox.width
    }

    
//    由字符串获取label高度
    func getLabHeight(labelStr:String,font:UIFont,LabelWidth:CGFloat) -> CGFloat {
        let statusLabelText: NSString = labelStr as NSString
        let size = CGSize(width:LabelWidth,height: 900)
        let dic = NSDictionary(object: font, forKey: NSFontAttributeName as NSCopying)
        let strSize = statusLabelText.boundingRect(with: size, options: .usesLineFragmentOrigin, attributes: dic as? [String : AnyObject], context: nil).size
        return strSize.height
    }
    
//    由字符串获取label宽度
    func getLabWidth(labelStr:String,font:UIFont,LabelHeight:CGFloat) -> CGFloat {
        let statusLabelText: NSString = labelStr as NSString
        let size = CGSize(width:900,height: LabelHeight)
        let dic = NSDictionary(object: font, forKey: NSFontAttributeName as NSCopying)
        let strSize = statusLabelText.boundingRect(with: size, options: .usesLineFragmentOrigin, attributes: dic as? [String : AnyObject], context: nil).size
        return strSize.width
    }
    
    

    /// 判断是否是手机号
    ///
    /// - parameter phoneNum: 手机号
    ///
    /// - returns: 是或者不是
    static func isMobileNumber(phoneNum : String) -> Bool {
        let predicateStr = "^((13[0-9])|(15[0-9])|(17[0-9])|(18[0-9]))\\d{8}$"
        let currObject = phoneNum
        let predicate =  NSPredicate(format: "SELF MATCHES %@" ,predicateStr)
        return predicate.evaluate(with: currObject)
    }

    /// 判断是否为空字符串
    ///
    /// - parameter str: 字符串
    ///
    /// - returns: 是否

    static func isStr(str : String) -> Bool {
        if str.characters.count > 0 {
            return true
        } else {
            return false
        }
    }

    /// sha1加密
    ///
    /// - returns: 加密后的结果
    func sha1() -> String {
        let data = self.data(using: String.Encoding.utf8)!
        var digest = [UInt8](repeating: 0, count:Int(CC_SHA1_DIGEST_LENGTH))
        data.withUnsafeBytes {
            _ = CC_SHA1($0, CC_LONG(data.count), &digest)
        }
        let hexBytes = digest.map { String(format: "%02hhx", $0) }
        return hexBytes.joined()
    }

    /// 64编码
    ///
    /// - returns: 编码后
    func base64() -> String {
        let strdata = self.data(using: .utf8)
        return (strdata?.base64EncodedString())!
    }

    /// 返回图片完整的地址
    ///
    ///
    /// - returns: 完整的地址
    func getImageStr() -> String {
        let str :String =  OSS_API + self
        let urlBase : String = str.addingPercentEncoding(withAllowedCharacters: .urlPathAllowed)!
        KFBLog(message: urlBase)
        return urlBase
    }

    /// 返回当前日子2016-12-23
    static func getDayStr(day : String) -> String{
        var dayStr : String =  ""

        if day.characters.count > 0 {
            let arr :Array = day.components(separatedBy: "-")
            dayStr = arr.last!
        }
        return dayStr
    }

    static func getDayIndex()->Int {
        let currentDate = Date()
        var calendar = Calendar.current
        calendar.timeZone = NSTimeZone(abbreviation: "GMT") as! TimeZone
        let components =  calendar.dateComponents([.year,.month,.day,.weekday,.weekOfMonth,.weekdayOrdinal,.yearForWeekOfYear,.era], from: currentDate)
        KFBLog(message: components.era!)
         KFBLog(message: components.day!)
        KFBLog(message: components.weekday!)
        KFBLog(message: components.weekOfMonth!)
        KFBLog(message: components.yearForWeekOfYear!)
        let weekNum : Int = components.weekday!
        if weekNum == 1 {
            return  6
        } else {
            return   weekNum - 2
        }

    }
}
