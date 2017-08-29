//
//  InguryDataManger.swift
//  kangfuba
//
//  Created by LiChuanmin on 2016/10/31.
//  Copyright © 2016年 Xunqiu. All rights reserved.
//

import UIKit
import AFNetworking
import SwiftyJSON
import ObjectMapper
private let sharedKraken = InguryDataManger()
class InguryDataManger: KFBRequestViewController {

    var manager : AFHTTPSessionManager!
    var confi : URLSessionConfiguration!
    
    override init() {
        confi = URLSessionConfiguration.default
        manager = AFHTTPSessionManager.init(sessionConfiguration: confi)
    }
    
    class var sharedInstance: InguryDataManger {
        return sharedKraken
    }

//    是否损伤
    func getFirstGuideMenu(complate : @escaping (_ data :Any) ->(),faile : @escaping (_ errorData:String) ->()) {
        let url = BASER_API + getFirstGuideMenu_API
        KFBLog(message: "\(LoginModel.getLoginIdAndTokenInUD().tokenId)\(LoginModel.getLoginIdAndTokenInUD().loginId)")
        let dict = [
            "login_token":LoginModel.getLoginIdAndTokenInUD().tokenId,
            "login_user_id":LoginModel.getLoginIdAndTokenInUD().loginId,
            "version":self.getAppVersion(),
            "deviceId":self.getPhoneUUID()
        ]
        var model:guide1Model = guide1Model()
        
        manager.get(url, parameters: dict, progress: { (pro) in
            
        }, success: { (task, data) in
            KFBLog(message: task.response?.url)
            //                KFBLog(message: data)
            model = Mapper<guide1Model>().map(JSON: data as! [String : Any])!
            complate(model)
            
        }) { (task, erro) in
            faile(erro.localizedDescription.debugDescription)

        }
    }

    
    //   运动种类
    func getSecondGuideMenu(complate : @escaping (_ data :Any) ->(),faile : @escaping (_ errorData:String) ->()) {
        let url = BASER_API + getSecondGuideMenu_API
        KFBLog(message: "\(LoginModel.getLoginIdAndTokenInUD().tokenId)\(LoginModel.getLoginIdAndTokenInUD().loginId)")
        let dict = [
            "login_token":LoginModel.getLoginIdAndTokenInUD().tokenId,
            "login_user_id":LoginModel.getLoginIdAndTokenInUD().loginId,
            "version":self.getAppVersion(),
            "deviceId":self.getPhoneUUID()
        ]
        var model:SportsModel = SportsModel()
        
        manager.get(url, parameters: dict, progress: { (pro) in
            
        }, success: { (task, data) in
            KFBLog(message: task.response?.url)
            //                KFBLog(message: data)
            model = Mapper<SportsModel>().map(JSON: data as! [String : Any])!
            complate(model)
            
        }) { (task, erro) in
            faile(erro.localizedDescription.debugDescription)

        }
    }

    //   设置用户最常参加的体育运动
    func getUserFavouriteSport(favouriteSportId: Int,complate : @escaping (_ data : Any) ->(),failure : @escaping (_ error:Any) ->()) {
        
        confi = URLSessionConfiguration.default
        manager = AFHTTPSessionManager.init(sessionConfiguration: confi)

        let url = BASER_API + getUserFavouriteSport_API
        KFBLog(message: "\(LoginModel.getLoginIdAndTokenInUD().tokenId)\(LoginModel.getLoginIdAndTokenInUD().loginId)")
        let dict = [
            "login_token":LoginModel.getLoginIdAndTokenInUD().tokenId,
            "login_user_id":LoginModel.getLoginIdAndTokenInUD().loginId,
            "version":self.getAppVersion(),
            "deviceId":self.getPhoneUUID(),
            "favouriteSportId":favouriteSportId
        ] as [String : Any]
        var model:CreateProgramModel = CreateProgramModel()
        
        manager.post(url, parameters: dict, progress: { (pro) in
            
        }, success: { (task, data) in
            KFBLog(message: task.response?.url)
            KFBLog(message: data)
            model = Mapper<CreateProgramModel>().map(JSON: data as! [String : Any])!
            KFBLog(message: "模型msg---" + (model.msg)!)
            complate(model)
        }) { (task, erro) in
            KFBLog(message: "访问链接\( task?.response?.url)失败\( erro)")
            failure(erro.localizedDescription.debugDescription)
        }
    }

    
    
    func getInguryData(complate : @escaping (_ data :Any) ->(),faile : @escaping (_ errorData:String) ->()) {
        let url = BASER_API + InjuryPosition_API
        KFBLog(message: "\(LoginModel.getLoginIdAndTokenInUD().tokenId)\(LoginModel.getLoginIdAndTokenInUD().loginId)")
        let dict = [
            "login_token":LoginModel.getLoginIdAndTokenInUD().tokenId,
            "login_user_id":LoginModel.getLoginIdAndTokenInUD().loginId,
            "version":self.getAppVersion(),
            "deviceId":self.getPhoneUUID()
        ]
        var model:InguryPositionModel = InguryPositionModel()
        
        manager.get(url, parameters: dict, progress: { (pro) in
            
            }, success: { (task, data) in
                KFBLog(message: task.response?.url)
//                KFBLog(message: data)
                model = Mapper<InguryPositionModel>().map(JSON: data as! [String : Any])!
                complate(model)
                
        }) { (task, erro) in
            faile(erro.localizedDescription.debugDescription)

        }
    }
    
    
    
    func getInjuryMenu1Data(positionId : String,complate : @escaping (_ data :Any) ->(),faile : @escaping (_ errorData:String) ->()) {
        let url = BASER_API + InjuryInfoMenu1Page_API
        //        KFBLog(message: "\(LoginModel.getLoginIdAndTokenInUD().tokenId)\(LoginModel.getLoginIdAndTokenInUD().loginId)")
        let dict = [
            "login_token":LoginModel.getLoginIdAndTokenInUD().tokenId,
            "login_user_id":LoginModel.getLoginIdAndTokenInUD().loginId,
            "uuid":self.getPhoneUUID(),
            "version":self.getAppVersion(),
            "positionId":positionId,
            "deviceId":self.getPhoneUUID()
        ]
        var model:FirstInguryModel = FirstInguryModel()
        
        manager.get(url, parameters: dict, progress: { (pro) in
            
            }, success: { (task, data) in
                
                KFBLog(message: task.response?.url)
                
                model = Mapper<FirstInguryModel>().map(JSON: data as! [String : Any])!
                complate(model)
                
        }) { (task, erro) in
            faile(erro.localizedDescription.debugDescription)

        }
    }
    
    
    func getInjuryMenu2Data(positionId : String,AMenuId : String,complate : @escaping (_ data :Any) ->(),faile : @escaping (_ errorData:String) ->()) {
        let url = BASER_API + InjuryInfoMenu2Page_API
        //        KFBLog(message: "\(LoginModel.getLoginIdAndTokenInUD().tokenId)\(LoginModel.getLoginIdAndTokenInUD().loginId)")
        let dict = [
            "login_token":LoginModel.getLoginIdAndTokenInUD().tokenId,
            "login_user_id":LoginModel.getLoginIdAndTokenInUD().loginId,
            "version":self.getAppVersion(),
            "deviceId":self.getPhoneUUID(),
            "positionId":positionId,
            "AMenuId":AMenuId
        ]
        var model:FirstInguryModel = FirstInguryModel()
        
        manager.get(url, parameters: dict, progress: { (pro) in
            
            }, success: { (task, data) in
                
                KFBLog(message: task.response?.url)
                
                model = Mapper<FirstInguryModel>().map(JSON: data as! [String : Any])!
                complate(model)
                
        }) { (task, erro) in
            faile(erro.localizedDescription.debugDescription)

        }
    }

//    生成方案
    func createProgram(parentPositionId: Int,positionId : Int,createDict:Any,complate: @escaping (_ data : Any) ->(),failure : @escaping (_ error:Any) ->()) {
        MobClick.event("006")
        manager.requestSerializer = AFJSONRequestSerializer.init()
        manager.requestSerializer.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        let postInfoStr:String = "?parentPositionId=\(parentPositionId)&positionId=\(positionId)&deviceId=\(self.getPhoneUUID())&version=\(self.getAppVersion())&login_user_id=\(LoginModel.getLoginIdAndTokenInUD().loginId)&login_token=\(LoginModel.getLoginIdAndTokenInUD().tokenId)"
        
        let url = BASER_API + CreateProgram_API + postInfoStr
        var createModel:CreateProgramModel = CreateProgramModel()
        
        KFBLog(message: "Body-------------\(createDict)")
        
        manager.post(url, parameters: createDict, progress: { (pro) in
            
            }, success: { (task, data) in
                KFBLog(message: task.response?.url)
                KFBLog(message: data)
                createModel = Mapper<CreateProgramModel>().map(JSON: data as! [String : Any])!
                KFBLog(message: "模型msg---" + (createModel.msg)!)
                complate(createModel)
        }) { (task, erro) in
            failure(erro.localizedDescription.debugDescription)
        }
        
    }

}
