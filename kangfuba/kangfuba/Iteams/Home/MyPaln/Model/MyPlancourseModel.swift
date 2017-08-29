//
//  MyPlancourseModel.swift
//  kangfuba
//
//  Created by lvxin on 2016/12/23.
//  Copyright © 2016年 Xunqiu. All rights reserved.
//

import UIKit
import ObjectMapper
class MyPlancourseModel: Mappable {
    var courseid: Int = 0//课程id
    var recommendcourseid: Int = 0//课程id
    var totletraintimes: Int = 0//课程id
    var coursename: String = ""//课程名字
    var videourl: String = ""//课程名字
    var traintype: Int = 0//0力量训练，1稳定性训练，2治疗（一个MP4视频，只播放），3建议（只展示文案，例如：冰敷）
    var traintimesweekly: Int = 0
    var completedTrainCountWeekly: Int = 0//用户完成该更称训练总次数
    var iconpic: String = ""//级别图标


    init() {}
    required init?(map: Map){
        mapping(map: map)
    }
    // Mappable
    func mapping(map: Map) {
        courseid <- map["courseid"]
        recommendcourseid <- map["recommendcourseid"]
        totletraintimes <- map["totletraintimes"]
        coursename <- map["coursename"]
        traintype <- map["traintype"]
        traintimesweekly <- map["traintimesweekly"]
        completedTrainCountWeekly <- map["completedTrainCountWeekly"]
        videourl <- map["videourl"]
        iconpic <- map["iconpic"]
    }
}
