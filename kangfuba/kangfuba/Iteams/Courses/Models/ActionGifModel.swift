//
//  ActionGifModel.swift
//  kangfuba
//
//  Created by lvxin on 2016/11/7.
//  Copyright © 2016年 Xunqiu. All rights reserved.
//

import UIKit
import ObjectMapper
class ActionGifModel: Mappable {
    var courseid : Int = 0//课程id
    var coursegifid : Int = 0//gifid
    var timelen :Float = 0.0//没个gif的时间
    var repeattimes : Int = 0//重复次数，lastSeconds=0时该字段有效
    var lastseconds : Int = 0//持续秒数，repeattimes=0时该字段有效
    var resttimelen : Int = 0//休息时间
    var actname : String = ""//动作名称
    var videoTitle : String = ""//播放视频时展示的视频标题
    var nextActName : String = ""//播放视频时下一个动作提示语
    var wisdom :String = ""//名言
    var actpic : String = ""//动作展示图片地址 前面加oss域名
    var gifurl : String = ""//gif视频地址 前面加oss域名
    var gifLocalUrl : String = ""//gif视频本地地址
    var explainmusicurl : String = ""//讲解音
    var explainLocalUrl : String = ""//讲解音本地地址
    var insertAudiosLocalPath:String = ""//当前指导音本地路径
     var tips:String = ""//当前指导音本地路径
    var insertAudios:[InsertAudiosModel] = []//内部讲解音
    init() {}
    required init?(map: Map){
        mapping(map: map)
    }
    // Mappable
    func mapping(map: Map) {
        courseid <- map["courseid"]
        timelen <- map["timelen"]
        tips <- map["tips"]
        coursegifid <- map["coursegifid"]
        repeattimes <- map["repeattimes"]
        resttimelen <- map["resttimelen"]
        lastseconds <- map["lastseconds"]
        actname <- map["actname"]
        videoTitle <- map["videoTitle"]
        wisdom <- map["wisdom"]
        nextActName <- map["nextActName"]
        gifurl <- map["gifurl"]
        actpic <- map["actpic"]
        explainmusicurl <- map["explainmusicurl"]
        insertAudios <- map["insertAudios"]
    }
}
