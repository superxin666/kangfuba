//
//  PersonalDataManger.swift
//  kangfuba
//
//  Created by LiChuanmin on 2016/11/1.
//  Copyright © 2016年 Xunqiu. All rights reserved.
//

import UIKit
import AFNetworking
import SwiftyJSON
import ObjectMapper
private let sharedKraken = PersonalDataManger()

class PersonalDataManger: KFBRequestViewController {

    var manager : AFHTTPSessionManager!
    var confi : URLSessionConfiguration!
    
    override init() {
        confi = URLSessionConfiguration.default
        manager = AFHTTPSessionManager.init(sessionConfiguration: confi)
    }

    class var sharedInstance: PersonalDataManger {
        return sharedKraken
    }

    

    func getPersonalData(complate : @escaping (_ data :Any) ->(),faile : @escaping (_ errorData:String) ->()) {
        let url = BASER_API + PersonalInfo_API
//        KFBLog(message: "\(LoginModel.getLoginIdAndTokenInUD().tokenId)\(LoginModel.getLoginIdAndTokenInUD().loginId)")
        let dict = [
            "login_token":LoginModel.getLoginIdAndTokenInUD().tokenId,
            "login_user_id":LoginModel.getLoginIdAndTokenInUD().loginId,
            "version":self.getAppVersion(),
            "deviceId":self.getPhoneUUID()
        ]
        var model:UserInfoModel = UserInfoModel()
        
        manager.get(url, parameters: dict, progress: { (pro) in
            
            }, success: { (task, data) in
                KFBLog(message: task.response?.url)
//                KFBLog(message: data)
                
                model = Mapper<UserInfoModel>().map(JSON: data as! [String : Any])!
                complate(model)
                
        }) { (task, erro) in
//            KFBLog(message: "访问链接\( task?.response?.url)失败\( erro)")
            
            if erro.localizedDescription.description.contains("(403)"){
                faile("403")
            } else {
                faile(erro.localizedDescription.description)
            }

        }
    }
    
    func editUserInfo(userName: String,userImage : String,userGender : Int,userBirthday : String,complate: @escaping (_ data : Any) ->(),faile : @escaping (_ errorData:Any) ->()) {
        let url = BASER_API + EditUserInfo_API
        KFBLog(message: "头像\(userImage.base64())")
        
        let dict:Dictionary<String, Any>
        
        if userBirthday == "0" {
           
            dict = [
                "userName":userName,
                "userImage":userImage,
                "userGender":NSNumber.init(value: userGender),
                "login_token":LoginModel.getLoginIdAndTokenInUD().tokenId,
                "login_user_id":LoginModel.getLoginIdAndTokenInUD().loginId,
                "version":self.getAppVersion(),
                "deviceId":self.getPhoneUUID()
                ] as [String : Any]

            
        }else{
            dict = [
                "userName":userName,
                "userImage":userImage,
                "userGender":NSNumber.init(value: userGender),
                "userBirthday":userBirthday,
                "login_token":LoginModel.getLoginIdAndTokenInUD().tokenId,
                "login_user_id":LoginModel.getLoginIdAndTokenInUD().loginId,
                "version":self.getAppVersion(),
                "deviceId":self.getPhoneUUID()
                ] as [String : Any]

        }
                var editModel:EditUserInfoModel = EditUserInfoModel()
        KFBLog(message: dict)
        manager.post(url, parameters: dict, progress: { (pro) in
            
            }, success: { (task, data) in
                KFBLog(message: task.response?.url)
                KFBLog(message: data)
                editModel = Mapper<EditUserInfoModel>().map(JSON: data as! [String : Any])!
                KFBLog(message: "模型msg" + (editModel.msg)!)
                complate(editModel)
        }) { (task, erro) in
            faile(erro.localizedDescription.debugDescription)

        }
        
    }

    
    func getTrainRecord(start: Int,count : Int,complate: @escaping (_ data : Any) ->(),failure : @escaping (_ error:Any) ->()) {
        let url = BASER_API + MyTrainRecord_API
        let dict = [
            "start":start,
            "count":count,
            
            "login_token":LoginModel.getLoginIdAndTokenInUD().tokenId,
            "login_user_id":LoginModel.getLoginIdAndTokenInUD().loginId,
            "version":self.getAppVersion(),
            "deviceId":self.getPhoneUUID()
            ] as [String : Any]
        var recordModel:MyTrainRecordModel = MyTrainRecordModel()
        
        manager.get(url, parameters: dict, progress: { (pro) in
            
            }, success: { (task, data) in
                KFBLog(message: task.response?.url)
                KFBLog(message: data)
                recordModel = Mapper<MyTrainRecordModel>().map(JSON: data as! [String : Any])!
                KFBLog(message: "模型msg" + (recordModel.msg)!)
                complate(recordModel)
        }) { (task, erro) in
            KFBLog(message: "访问链接\( task?.response?.url)失败\( erro)")
            
            failure(erro.localizedDescription.debugDescription)
        }
        
        
    }


}
