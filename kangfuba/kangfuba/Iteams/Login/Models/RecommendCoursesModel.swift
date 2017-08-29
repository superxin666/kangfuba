//
//  recommendCoursesModel.swift
//  kangfuba
//
//  Created by lvxin on 2016/10/28.
//  Copyright © 2016年 Xunqiu. All rights reserved.
//  推荐的训练课程+我已经选择的课程

import UIKit
import ObjectMapper
class RecommendCoursesModel: Mappable {
    var courseid: Int = 0//课程id
    var coursename: String!//课程名字
    var pic : String = ""
    var timelen: Int = 0//课程时长
    var traintype: Int = 0//0力量训练，1稳定性训练，2治疗（一个MP4视频，只播放），3建议（只展示文案，例如：冰敷）
    var videourl: String!//如果有视频
    var completedTotleTrainCount: Int = 0//用户完成该更称训练总次数
    init() {}
    required init?(map: Map){
        mapping(map: map)
    }
    // Mappable
    func mapping(map: Map) {
        courseid <- map["courseid"]
        coursename <- map["coursename"]
        timelen <- map["timelen"]
        completedTotleTrainCount <- map["completedTotleTrainCount"]
        pic <- map["pic"]
    }
}
