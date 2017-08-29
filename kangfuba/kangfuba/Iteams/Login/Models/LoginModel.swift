//
//  LoginModel.swift
//  kangfuba
//
//  Created by lvxin on 2016/10/27.
//  Copyright © 2016年 Xunqiu. All rights reserved.
//  登录接口 (也是返回基础数据统一的模型)

import UIKit
import ObjectMapper
let TOKENUDSTR = "LOGININTOKEN"
let LOGINUDSTR = "LOGININLOGINID"
let ISLOGINSTR = "ISHAVELOGIN"
class LoginModel: Mappable {
    var status: Int!//状态码
    var msg : String!//提示

    init() {}
    required init?(map: Map){
        mapping(map: map)
    }
    // Mappable
    func mapping(map: Map) {
        status <- map["status"]
        msg <- map["msg"]
    }

    /// 存贮登录的信息
    ///
    /// - parameter loginUserId: 登录id
    /// - parameter token:       登录token
    class func setLoginIdAndTokenInUD(loginUserId : String , token : String, complate:(_ data : Any) ->() ){
        UserDefaults.standard.set("1", forKey: ISLOGINSTR)
        UserDefaults.standard.set(token, forKey: TOKENUDSTR)
        UserDefaults.standard.set(loginUserId, forKey: LOGINUDSTR)
        let ok = UserDefaults.standard.synchronize()
        if ok {
            KFBLog(message: "存储成功")
            complate("1")
        } else {
            KFBLog(message: "存储失败")
            complate("0")
        }
    }

    /// 返回当前登录用户的 loginid tokenid
    ///
    /// - returns: 返回元组loginid tokenid
    class func getLoginIdAndTokenInUD() -> (loginId : String, tokenId : String, isHaveLogin : String) {
        var isloginStr :String? = UserDefaults.standard.value(forKey: ISLOGINSTR) as! String?
        if isloginStr == nil {
            isloginStr = "0"
        }
        var loginStr :String? = UserDefaults.standard.value(forKey: LOGINUDSTR) as! String?
        if loginStr == nil {
            loginStr = ""
        }
        var tokenStr :String? = UserDefaults.standard.value(forKey: TOKENUDSTR) as! String?
        if tokenStr == nil {
            tokenStr = ""
        }
        return (loginStr!,tokenStr!,isloginStr!)
    }
}
