//
//  HomeDataManger.swift
//  kangfuba
//
//  Created by lvxin on 2016/10/28.
//  Copyright © 2016年 Xunqiu. All rights reserved.
//

import UIKit
import AFNetworking
import SwiftyJSON
import ObjectMapper
private let sharedKraken = HomeDataManger()
class HomeDataManger: KFBRequestViewController {
    var manager : AFHTTPSessionManager!
    var confi : URLSessionConfiguration!
    override init() {
        confi = URLSessionConfiguration.default
        manager = AFHTTPSessionManager.init(sessionConfiguration: confi)
        
    }
    class var sharedInstance: HomeDataManger {
        return sharedKraken
    }

    func getHomeViewData(complate : @escaping (_ data :Any) ->(),faile : @escaping (_ erroData:String) ->()) {
        let url = BASER_API + HOMEVIEW_API
        KFBLog(message: "\(LoginModel.getLoginIdAndTokenInUD().tokenId)\(LoginModel.getLoginIdAndTokenInUD().loginId)")
        let dict = [
            "login_token":LoginModel.getLoginIdAndTokenInUD().tokenId,
            "login_user_id":LoginModel.getLoginIdAndTokenInUD().loginId,
            "version":self.getAppVersion(),
            "deviceId":self.getPhoneUUID()
            ]
        var model:HomeViewModel = HomeViewModel()

        manager.get(url, parameters: dict, progress: { (pro) in

            }, success: { (task, data) in
                KFBLog(message: "网络状态"+"\(task.currentRequest?.networkServiceType.hashValue)")
                KFBLog(message: task.response?.url)
                KFBLog(message: data)
                model = Mapper<HomeViewModel>().map(JSON: data as! [String : Any])!
                complate(model)

        }) { (task, erro) in
            KFBLog(message: "访问链接\( task?.response?.url)失败\( erro.localizedDescription.description)")
            KFBLog(message: erro)

           // AFStringFromNetworkReachabilityStatus()
            KFBLog(message: "网络状态"+"\(task?.currentRequest?.networkServiceType)")
            if erro.localizedDescription.description.contains("(403)"){
                faile("403")
            } else {
                faile(erro.localizedDescription.description)
            }

        }
    }


    func getMyPlanViewData(complate : @escaping (_ data :Any) ->(),faile : @escaping (_ erroData:String) ->()){
        let url = BASER_API + MYPLAN_API
        let dict = [
            "login_token":LoginModel.getLoginIdAndTokenInUD().tokenId,
            "login_user_id":LoginModel.getLoginIdAndTokenInUD().loginId,
            "version":self.getAppVersion(),
            "deviceId":self.getPhoneUUID()
        ]
        var model:MyPlanHomeModel = MyPlanHomeModel()

        manager.get(url, parameters: dict, progress: { (pro) in

        }, success: { (task, data) in
            KFBLog(message: "网络状态"+"\(task.currentRequest?.networkServiceType.hashValue)")
            KFBLog(message: task.response?.url)
            KFBLog(message: data)
            model = Mapper<MyPlanHomeModel>().map(JSON: data as! [String : Any])!
            complate(model)

        }) { (task, erro) in
            KFBLog(message: "访问链接\( task?.response?.url)失败\( erro.localizedDescription.description)")
            KFBLog(message: erro)

            // AFStringFromNetworkReachabilityStatus()
            KFBLog(message: "网络状态"+"\(task?.currentRequest?.networkServiceType)")
            if erro.localizedDescription.description.contains("(403)"){
                faile("403")
            } else {
                faile(erro.localizedDescription.description)
            }
            
        }
    }

}
