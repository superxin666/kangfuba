//
//  recommendCourses.swift
//  kangfuba
//
//  Created by lvxin on 2016/12/23.
//  Copyright © 2016年 Xunqiu. All rights reserved.
//  本周康复计划--每个课程的数据模型

import UIKit
import ObjectMapper
class recommendCourses: Mappable {
    var courseid: Int = 0//课程id
    var coursename: String!//课程名字
    var traintype: Int = 0//0力量训练，1稳定性训练，2治疗（一个MP4视频，只播放），3建议（只展示文案，例如：冰敷）
    var videourl: String = ""//如果有视频
    var iconpic: String!//级别图标
    var completeNumToday: Int = 0//用户完成该更称训练总次数
    var completedTotleTrainCount: Int = 0//用户完成该更称训练总次数


    init() {}
    required init?(map: Map){
        mapping(map: map)
    }
    // Mappable
    func mapping(map: Map) {
        courseid <- map["courseid"]
        coursename <- map["coursename"]
        traintype <- map["traintype"]
        videourl <- map["videourl"]
        iconpic <- map["iconpic"]
        completeNumToday <- map["completeNumToday"]
        completedTotleTrainCount <- map["completedTotleTrainCount"]
    }
}
