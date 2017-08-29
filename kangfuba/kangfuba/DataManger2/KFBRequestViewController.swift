//
//  KFBRequestViewController.swift
//  kangfuba
//
//  Created by lvxin on 2016/10/25.
//  Copyright © 2016年 Xunqiu. All rights reserved.
//

import UIKit
import AFNetworking
import SwiftyJSON
import ObjectMapper

class KFBRequestViewController: NSObject {

    // MARK: 网络状态部分
    /// 获取当前网络状态
    func startMonitoring(compate:@escaping (_ data:Any)->()) {
        AFNetworkReachabilityManager.shared().startMonitoring()
        AFNetworkReachabilityManager.shared().setReachabilityStatusChange { (states) in
            KFBLog(message: "检查网络状态\(states.rawValue)----\(AFStringFromNetworkReachabilityStatus(states))")
            //compate(AFStringFromNetworkReachabilityStatus(AFNetworkReachabilityStatus(rawValue: states.rawValue)!))
            compate(states.rawValue)
        }
    }

    /// 关闭获取当前网络状态
    func stopMonitoring()  {
         AFNetworkReachabilityManager.shared().stopMonitoring()
    }


    // MARK: 公共部分
    /// 获取版本号
    ///
    /// - returns: 版本号
    func getAppVersion() -> String  {
        let infoDict = Bundle.main.infoDictionary
        if let info = infoDict {
            let appVersion = info["CFBundleShortVersionString"] as! String!
            return ("ios_" + appVersion!)
        } else {
            return ""
        }
    }

    /// 获取手机uuid
    ///
    /// - returns: uuid
    func getPhoneUUID() -> String {
        let uid = UIDevice.current.identifierForVendor?.uuidString
        return uid!
    }

    func addBaseUrlInfo(dict : NSDictionary)  {

    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
