//
//  courseDataManger.swift
//  kangfuba
//
//  Created by lvxin on 2016/10/31.
//  Copyright © 2016年 Xunqiu. All rights reserved.
//

import UIKit
import AFNetworking
import SwiftyJSON
import ObjectMapper
import Kingfisher
private let sharedKraken = CourseDataManger()
class CourseDataManger: KFBRequestViewController {
    var manager : AFHTTPSessionManager!
    var confi : URLSessionConfiguration!

    var documentPaths : [String] = NSSearchPathForDirectoriesInDomains(FileManager.SearchPathDirectory.documentDirectory, FileManager.SearchPathDomainMask.userDomainMask, true)
    var dirPath :String = ""//gif地址
    var expVideoPath :String = ""//讲解音地址
    var backGroundVideoPath :String = ""//讲解音地址
    var guideVideoPath :String = ""//指导音频地址

    var fileManager = FileManager.default
    var fileName = "gifFile"//gif文件夹名字
    var expVideoName = "expFile"//讲解音文件夹名字
    var backGroundVideoName = "backGroundVideoFile"//讲解音文件夹名字
    var guideVideoName :String = "guideVideoFile"//指导音频文件夹
    var downNum : Int = 0//下载个数
    var startNum:Int = 0//开始的位置

    override init() {

        confi = URLSessionConfiguration.default
        manager = AFHTTPSessionManager.init(sessionConfiguration: confi)
        //
        dirPath = documentPaths.first! + "/\(fileName)"
        expVideoPath = documentPaths.first! + "/\(expVideoName)"
        backGroundVideoPath = documentPaths.first! + "/\(backGroundVideoName)"
        guideVideoPath =    documentPaths.first! + "/\(guideVideoName)"
        //gif文件夹
        if fileManager.fileExists(atPath: dirPath) {
            KFBLog(message: "gif文件夹已存在")
        } else {
            KFBLog(message: "gif创建文件夹")
            do {
                try fileManager.createDirectory(atPath: dirPath, withIntermediateDirectories: true, attributes: nil)
            } catch _ {
                KFBLog(message: "gif创建文件夹失败")
            }
        }
//        //讲解音
        if fileManager.fileExists(atPath: expVideoPath) {
            KFBLog(message: "讲解音文件夹已存在")
        } else {
            KFBLog(message: "讲解音创建文件夹")
            do {
                try fileManager.createDirectory(atPath: expVideoPath, withIntermediateDirectories: true, attributes: nil)
            } catch _ {
                KFBLog(message: "讲解音创建文件夹失败")
            }
        }
//        //北京音乐
        if fileManager.fileExists(atPath: backGroundVideoPath) {
            KFBLog(message: "背景音乐文件夹已存在")
        } else {
            KFBLog(message: "创建背景音乐文件夹")
            do {
                try fileManager.createDirectory(atPath: backGroundVideoPath, withIntermediateDirectories: true, attributes: nil)
            } catch _ {
                KFBLog(message: "创建背景音乐文件夹失败")
            }
        }
        //指导音乐
        if fileManager.fileExists(atPath: guideVideoPath) {
            KFBLog(message: "指导音乐文件夹已存在")
        } else {
            KFBLog(message: "指导音乐文件夹")
            do {
                try fileManager.createDirectory(atPath: guideVideoPath, withIntermediateDirectories: true, attributes: nil)
            } catch _ {
                KFBLog(message: "创建指导音乐文件夹失败")
            }
        }

    }

    class var sharedInstance: CourseDataManger {
        return sharedKraken
    }
    /// 课程列表
    ///
    /// - parameter complate: 数据
    func getCourseListData(complate : @escaping (_ data : Any) ->(), faile : @escaping (_ erroData:String) ->()) {
        let url = BASER_API + COURSELIST_API
        KFBLog(message: "\(LoginModel.getLoginIdAndTokenInUD().tokenId)\(LoginModel.getLoginIdAndTokenInUD().loginId)")
        let dict = [
            "login_token":LoginModel.getLoginIdAndTokenInUD().tokenId,
            "login_user_id":LoginModel.getLoginIdAndTokenInUD().loginId,
            "version":self.getAppVersion(),
            "deviceId":self.getPhoneUUID()
        ]
        var model:CourseListModelWap = CourseListModelWap()
        manager.get(url, parameters: dict, progress: { (pro) in

            }, success: { (task, data) in
                KFBLog(message: task.response?.url)
                KFBLog(message: data)
                model = Mapper<CourseListModelWap>().map(JSON: data as! [String : Any])!
                complate(model)

        }) { (task, erro) in
            KFBLog(message: "访问链接\( task?.response?.url)失败\( erro)")
            faile(erro.localizedDescription.debugDescription)
        }

    }


    /// 课程子列表
    ///
    /// - parameter courseTypeId: 课程id
    /// - parameter complate:     返回的数据
    func getSubCourseListData(start:Int,courseTypeId: Int ,complate :@escaping (_ data : Any) ->(),faile : @escaping (_ erroData:String) ->())  {
        let url = BASER_API + SUBCOURSELIST_API
        KFBLog(message: "\(LoginModel.getLoginIdAndTokenInUD().tokenId)\(LoginModel.getLoginIdAndTokenInUD().loginId)")
        let dict = [
            "start":"\(start)",
            "count":"\(10)",
            "courseTypeId":"\(courseTypeId)",
            "login_token":LoginModel.getLoginIdAndTokenInUD().tokenId,
            "login_user_id":LoginModel.getLoginIdAndTokenInUD().loginId,
            "version":self.getAppVersion(),
            "deviceId":self.getPhoneUUID()        ]
        var model:SubCouseListWap = SubCouseListWap()

        manager.get(url, parameters: dict, progress: { (pro) in

            }, success: { (task, data) in
                KFBLog(message: task.response?.url)
                KFBLog(message: data)
                model = Mapper<SubCouseListWap>().map(JSON: data as! [String : Any])!
                complate(model)

        }) { (task, erro) in
            KFBLog(message: "访问链接\( task?.response?.url)失败\( erro)")
            faile(erro.localizedDescription.debugDescription )
        }
    }

    /// 课程详情
    ///
    /// - parameter courseId: 课程id
    /// - parameter complate: 返回数据
    func getCourseDetialData(courseId : Int, complate :@escaping (_ data : Any) ->(),faile : @escaping (_ erroData:String) ->()) {
        let url = BASER_API + COURSEDETIAL_API
        KFBLog(message: "\(LoginModel.getLoginIdAndTokenInUD().tokenId)\(LoginModel.getLoginIdAndTokenInUD().loginId)")
        let dict = [
            "courseId":"\(courseId)",
            "login_token":LoginModel.getLoginIdAndTokenInUD().tokenId,
            "login_user_id":LoginModel.getLoginIdAndTokenInUD().loginId,
            "version":self.getAppVersion(),
            "deviceId":self.getPhoneUUID()
        ]
        var model:CourseDetialWapModel = CourseDetialWapModel()

        manager.get(url, parameters: dict, progress: { (pro) in

            }, success: { (task, data) in
                KFBLog(message: task.response?.url)
                KFBLog(message: data)
                model = Mapper<CourseDetialWapModel>().map(JSON: data as! [String : Any])!
                complate(model)
        }) { (task, erro) in
            KFBLog(message: "访问链接\( task?.response?.url)失败\( erro)")
            faile(erro.localizedDescription.debugDescription )
        }
    }

    /// 参加课程
    ///
    /// - parameter courseId: 课程id
    /// - parameter complate: 返回数据模型
    func joinCourse(courseId : Int ,complate : @escaping (_ data : Any) ->(),faile : @escaping (_ erroData:String) ->())  {
        let url = BASER_API + JOINCOURSEDETIAL_API
        let dict = [
            "courseId":"\(courseId)",
            "login_token":LoginModel.getLoginIdAndTokenInUD().tokenId,
            "login_user_id":LoginModel.getLoginIdAndTokenInUD().loginId,
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
                complate(model)
        }) { (task, erro) in
            KFBLog(message: "访问链接\( task?.response?.url)失败\( erro)")
            faile(erro.localizedDescription.debugDescription)
        }

    }

    /// 退出课程
    ///
    /// - parameter courseId: 课程id
    /// - parameter complate: 返回数据模型
    func cancleCourse(courseId : Int ,complate : @escaping (_ data : Any) ->(),faile : @escaping (_ erroData:String) ->())  {
        let url = BASER_API + EXITCOURSEDETIAL_API
        let dict = [
            "courseId":"\(courseId)",
            "login_token":LoginModel.getLoginIdAndTokenInUD().tokenId,
            "login_user_id":LoginModel.getLoginIdAndTokenInUD().loginId,
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
                complate(model)
        }) { (task, erro) in
            KFBLog(message: "访问链接\( task?.response?.url)失败\( erro)")
            faile(erro.localizedDescription.debugDescription)
        }
    }

    /// 下载gif图片
    ///
    /// - parameter string:   <#string description#>
    /// - parameter complate: <#complate description#>
    func downLoadGif(model : ActionGifModel,complate : @escaping (_ data : Any) ->()) {
        KFBLog(message: model.gifurl)

        let nameArr : Array = model.gifurl.components(separatedBy: "/")
        let gifPathStr : String = dirPath + "/"+nameArr.last!
        if fileManager.fileExists(atPath: gifPathStr) {
            //该gif已存在 下载解说
            model.gifLocalUrl = gifPathStr
            complate(1)
            //下载解说音乐
            downLoadExpVideo(model: model, complate: { (data) in
                let num = data as!Int
                complate(num)
            })
        } else {
            complate(1)
            let urlStr : String = OSS_API + model.gifurl
            let urlBase = urlStr.addingPercentEncoding(withAllowedCharacters: .urlPathAllowed)
            let url : URL = URL.init(string: urlBase!)!
            KFBLog(message: "gifurl\(url)")
            let gifData = NSData(contentsOf: url)
            KFBLog(message: "gif视频路径\(gifPathStr)")
            let isok = gifData?.write(toFile: gifPathStr, atomically: true)
            if let _ = isok {
                model.gifLocalUrl = gifPathStr

                //下载讲解音
                downLoadExpVideo(model: model, complate: { (data) in
                    let num = data as!Int
                    complate(num)
                })

            } else {
                KFBLog(message: "gif保存失败")
            }
        }
    }


    /// 下载解说
    ///
    /// - Parameters:
    ///   - model: <#model description#>
    ///   - complate: <#complate description#>
    func downLoadExpVideo(model : ActionGifModel,complate : (_ musicData : Any) ->())  {

        if model.explainmusicurl.characters.count > 0{
            //有讲解音
            KFBLog(message: "开始下载讲解音")
            let nameArr : Array = model.explainmusicurl.components(separatedBy: "/")
            let expPathStr : String = expVideoPath + "/"+nameArr.last!
            if fileManager.fileExists(atPath: expPathStr) {
                model.explainLocalUrl = expPathStr
                KFBLog(message: "该讲解音已经存在")
            } else {
                let urlStr = OSS_API + model.explainmusicurl
                let urlBase = urlStr.addingPercentEncoding(withAllowedCharacters: .urlPathAllowed)
                let url : URL = URL.init(string: urlBase!)!
                let gifData = NSData(contentsOf: url)
                KFBLog(message: "讲解音路径\(expPathStr)")
                let isok = gifData?.write(toFile: expPathStr, atomically: true)
                if let _ = isok{
                    model.explainLocalUrl = expPathStr
                    complate(downNum)
                    KFBLog(message: "讲解音乐保存成功")
                } else {
                    KFBLog(message: "讲解音乐保存失败")
                    model.explainLocalUrl = ""
                }
            }
        } else {
            //没有讲解音乐  直接返回下载gif成功
            KFBLog(message: "没有讲解音讲解音")
            downNum += 1
            complate(downNum)
            KFBLog(message: "gif保存成功")
        }

    }


    /// 下载背景音乐
    ///
    /// - Parameters:
    ///   - model: <#model description#>
    ///   - complate: <#complate description#>
    func downBackGroundMusic(model : CourseDetialModel, complate : (_ backMusic :Any) ->()) {
        if model.gifbackgroundmusicurl.characters.count > 0 {
            //有背景音乐
            let nameArr : Array = model.gifbackgroundmusicurl.components(separatedBy: "/")
            let backPathStr : String = backGroundVideoPath + "/"+nameArr.last!
            if fileManager.fileExists(atPath: backPathStr) {
                complate(backPathStr)
                KFBLog(message: "该背景音乐已经存在")
            } else {
                let urlStr = OSS_API + model.gifbackgroundmusicurl
                let urlBase = urlStr.addingPercentEncoding(withAllowedCharacters: .urlPathAllowed)
                let url : URL = URL.init(string: urlBase!)!
                let gifData = NSData(contentsOf: url)
                KFBLog(message: "背景音月路径\(backPathStr)")
                //let isok = gifData?.write(to: URL.init(fileURLWithPath: expPathStr), atomically: true)
                let isok = gifData?.write(toFile: backPathStr, atomically: true)
                if let _ = isok {
                    complate(backPathStr)
                    KFBLog(message: "背景音月保存成功")
                } else {
                    KFBLog(message: "背景音月保存失败")
                    complate("")
                }
            }
        } else {
            //没有背景音乐
            complate("")
        }

    }

    func downGuideMusic(model : ActionGifModel, complate : (_ backMusic :Any) ->()) {

        let basePath : String = guideVideoPath + "/"+model.actname
        for subModel in model.insertAudios {
            let nameStr : String = subModel.audioUrl
            let backPathStr : String = basePath + "/"+nameStr+".mp3"
            if fileManager.fileExists(atPath: backPathStr) {
                complate(backPathStr)
                KFBLog(message: "该指导音乐已经存在")
            } else {
                let urlStr = OSS_API + subModel.audioUrl
                let urlBase = urlStr.addingPercentEncoding(withAllowedCharacters: .urlPathAllowed)
                let url : URL = URL.init(string: urlBase!)!
                let gifData = NSData(contentsOf: url)
                KFBLog(message: "该指导音乐路径\(backPathStr)")
                //let isok = gifData?.write(to: URL.init(fileURLWithPath: expPathStr), atomically: true)
                let isok = gifData?.write(toFile: backPathStr, atomically: true)
                if let _ = isok {
                    complate(backPathStr)
                    KFBLog(message: "该指导音乐保存成功")
                } else {
                    KFBLog(message: "该指导音乐保存失败")
                    complate("")
                }
            }

        }

    }


    /// 上传训练记录
    ///
    /// - Parameters:
    ///   - courseId: <#courseId description#>
    ///   - trainType: <#trainType description#>
    func upLoadTrainingRecord(courseId : Int, trainType:Int,complate : @escaping (_ data : Any) ->(),faile : @escaping (_ erroData:String) ->())  {
        let url = BASER_API + UPLOADRECORD_API
        let dict = [
            "courseId":"\(courseId)",
            "trainType":"\(trainType)",
            "login_token":LoginModel.getLoginIdAndTokenInUD().tokenId,
            "login_user_id":LoginModel.getLoginIdAndTokenInUD().loginId,
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
                complate(model)
        }) { (task, erro) in
            KFBLog(message: "访问链接\( task?.response?.url)失败\( erro)")
            faile(erro.localizedDescription.debugDescription)
        }

    }

}
