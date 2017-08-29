//
//  LoginDataMangerViewController.swift
//  kangfuba
//
//  Created by lvxin on 2016/10/27.
//  Copyright © 2016年 Xunqiu. All rights reserved.
//

import UIKit
import AFNetworking
import SwiftyJSON
import ObjectMapper
private let sharedKraken = LoginDataManger()
class LoginDataManger: KFBRequestViewController {
    var manager : AFHTTPSessionManager!
    var confi : URLSessionConfiguration!
    override init() {
        confi = URLSessionConfiguration.default
        manager = AFHTTPSessionManager.init(sessionConfiguration: confi)
    }
    class var sharedInstance: LoginDataManger {
        return sharedKraken
    }

    /// 获取验证码接口
    ///
    /// - parameter phoneNum:   手机号
    /// - parameter completion: 返回数据模型
    func getPhoneCodeData(phoneNum : String, completion :  @escaping (_ codeData : GetCodeModel) ->(),failure : @escaping (_ error : Any) ->()) {
        let url = BASER_API + GETCODE_API
        let dict = [
            "telphone":phoneNum,
            "version":self.getAppVersion(),
            "deviceId":self.getPhoneUUID()
            ]
        var model:GetCodeModel = GetCodeModel()

        manager.get(url, parameters: dict, progress: { (pro) in

            }, success: { (task, data) in
                KFBLog(message: task.response?.url)
                KFBLog(message: data)
                model = Mapper<GetCodeModel>().map(JSON: data as! [String : Any])!
                KFBLog(message: "模型msg" + (model.msg)!)
                completion(model)
        }) { (task, erro) in
            KFBLog(message: "访问链接\( task?.response?.url)失败\( erro)")
            failure(erro.localizedDescription.debugDescription)
        }
    }


    /// 找回密码时候的获取验证码
    ///
    /// - Parameters:
    ///   - phoneNum: <#phoneNum description#>
    ///   - completion: <#completion description#>
    ///   - failure: <#failure description#>
    func getPhoneCodeFindKeyData(phoneNum : String, completion :  @escaping (_ codeData : GetCodeModel) ->(),failure : @escaping (_ error : Any) ->()) {
        let url = BASER_API + GETCODERESET_API
        let dict = [
            "telphone":phoneNum,
            "version":self.getAppVersion(),
            "deviceId":self.getPhoneUUID()
        ]
        var model:GetCodeModel = GetCodeModel()

        manager.get(url, parameters: dict, progress: { (pro) in

        }, success: { (task, data) in
            KFBLog(message: task.response?.url)
            KFBLog(message: data)
            model = Mapper<GetCodeModel>().map(JSON: data as! [String : Any])!
            KFBLog(message: "模型msg" + (model.msg)!)
            completion(model)
        }) { (task, erro) in
            KFBLog(message: "访问链接\( task?.response?.url)失败\( erro)")
            failure(erro.localizedDescription.debugDescription)
        }
    }



    /// 上传头像
    ///
    /// - parameter image:      头像
    /// - parameter completion: 完成返回数据
    /// - parameter failure:    失败返回数据
    func upLoadUserIcon(image : UIImage, completion :@escaping (_ data : Any) ->(), failure : @escaping (_ error : Any) ->()){
        let  str = "?deviceId=\(self.getPhoneUUID())&version=\(self.getAppVersion())"
        let url = BASER_API + UPLOAD_USERICON + str

        let imageData = UIImageJPEGRepresentation(image, 0.0)
        KFBLog(message: imageData)
        KFBLog(message: manager.requestSerializer.httpRequestHeaders)
        
        manager.requestSerializer = AFHTTPRequestSerializer.init()
//        manager.responseSerializer = AFJSONResponseSerializer()

        manager.requestSerializer.setValue("application/octet-stream", forHTTPHeaderField: "Content-Type")
        
        var model :UpLoadIconModel = UpLoadIconModel()

        KFBLog(message: manager.requestSerializer.httpRequestHeaders)
        manager.post(url, parameters: nil, constructingBodyWith: { (formadata) in
            
            
            formadata.appendPart(withFileData: imageData!, name: "img", fileName: "imageName", mimeType: "image/jpg")
            }, progress: { (pro) in

            }, success: { (task, data) in
                KFBLog(message: task.response?.url)
                KFBLog(message: data)
                model = Mapper<UpLoadIconModel>().map(JSON: data as! [String : Any])!
                completion(model)
            }) { (task, erro) in

                KFBLog(message: "上传失败\(erro)")
                failure(erro.localizedDescription.debugDescription)
        }
    }

    /// 注册接口
    ///
    /// - parameter telphone:     <#telphone description#>
    /// - parameter code:         <#code description#>
    /// - parameter userPass:     <#userPass description#>
    /// - parameter token:        <#token description#>
    /// - parameter userName:     <#userName description#>
    /// - parameter userImage:    <#userImage description#>
    /// - parameter userGender:   <#userGender description#>
    /// - parameter userBirthday: <#userBirthday description#>
    /// - parameter complate:     <#complate description#>
    func register(telphone : String, code : String,userPass:String,token : String,userName:String,userImage:String,userGender:Int,userBirthday:String,complate: @escaping (_ data : Any) ->() ,failure : @escaping (_ error : Any) ->()) {
        let url = BASER_API + RESGITER_API
        KFBLog(message: "头像\(userImage)")
        KFBLog(message: "头像\(userImage)")
        manager.requestSerializer = AFHTTPRequestSerializer.init()
        let dict = [
            "telphone":telphone,
            "code":code,
            "userPass":userPass,
            "token":token,
            "userName":userName,
            "userImage":userImage.base64(),
            "userGender":NSNumber.init(value: userGender),
            "userBirthday":userBirthday,
            "version":self.getAppVersion(),
            "deviceId":self.getPhoneUUID()
            ] as [String : Any]
        KFBLog(message: "注册\(dict)")
        var model:LoginModel = LoginModel()
        //manager.requestSerializer = AFHTTPRequestSerializer.init()

        manager.post(url, parameters: dict, progress: { (pro) in

            
            }, success: { (task, data) in
                KFBLog(message: task.response?.url)
                KFBLog(message: data)
                model = Mapper<LoginModel>().map(JSON: data as! [String : Any])!
                KFBLog(message: "模型msg" + (model.msg)!)
                complate(model)
            }) { (task, erro) in
                KFBLog(message: "访问链接\( task?.response?.url)失败\( erro)")
                failure(erro.localizedDescription.debugDescription)
        }

    }


    /// 登录
    ///
    /// - parameter phoneNum:   手机号
    /// - parameter paseWord:   密码（加密）
    /// - parameter completion: 返回数据
    /// - parameter failure:    错误数据
    func login(phoneNum : String, paseWord : String, completion : @escaping (_ data : Any) ->(), failure : @escaping (_ error : Any)->()) {
        let url = BASER_API + LOGIN_API
        let dict = [
            "telphone":phoneNum,
            "userPass":paseWord,
            "version":self.getAppVersion(),
            "deviceId":self.getPhoneUUID()
            ]
        var model:LoginModel = LoginModel()
        manager.get(url, parameters: dict, progress: { (pro) in

            }, success: { (task, data) in
                KFBLog(message: task.response?.url)
                KFBLog(message: data)
                model = Mapper<LoginModel>().map(JSON: data as! [String : Any])!
                KFBLog(message: "模型msg" + (model.msg)!)
                completion(model)
        }) { (task, erro) in
            KFBLog(message: "访问链接\( task?.response?.url)失败\( erro)")
            failure(erro.localizedDescription.debugDescription)
        }
    }

    func registerPass(telphone : String,code : String,token : String,passStr : String, completion : @escaping (_ data : Any) ->(),faile:@escaping (_ erro:Any) ->()) {
        let url = BASER_API + RESGITPASS_API
        let dict = [
            "telphone":telphone,
            "code":code,
            "token":token,
            "newUserPass":passStr,
            "version":self.getAppVersion(),
            "deviceId":self.getPhoneUUID()
        ]
        var model:LoginModel = LoginModel()
        manager.post(url, parameters: dict, progress: { (pro) in

            }, success: { (task, data) in
                KFBLog(message: task.response?.url)
                KFBLog(message: data)
                model = Mapper<LoginModel>().map(JSON: data as! [String : Any])!
                KFBLog(message: "模型msg" + (model.msg)!)
                completion(model)
            }) { (task, erro) in
                KFBLog(message: "访问链接\( task?.response?.url)失败\( erro)")
                faile(erro.localizedDescription.debugDescription)
        }
    }

    /// 获取用户协议链接
    ///
    /// - Returns: <#return value description#>
    func getUserAgreement() -> String{
        let  str = "deviceId=\(self.getPhoneUUID())&version=\(self.getAppVersion())"
        let url = BASER_API + USERAGREEMENT_API + str
        KFBLog(message: "链接\(url)")
        return url
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
