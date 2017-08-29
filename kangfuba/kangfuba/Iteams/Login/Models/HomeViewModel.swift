//
//  HomeViewModel.swift
//  kangfuba
//
//  Created by lvxin on 2016/10/28.
//  Copyright © 2016年 Xunqiu. All rights reserved.
//  首页数据

import UIKit
import ObjectMapper
class HomeViewModel: Mappable {
    var status: Int = 0//状态码
    var trainingTimeLen: Int = 0//用户总共的训练时长
    var trainingProgress: Int = 0//训练总进度
    var stabilityTrainingTimes: Int = 0//稳定性训练次数
    var strengthTrainingTimes: Int = 0//力量训练次数
    var indexStyle: Int = 100//主要用于标示首页展示形式：0：用户有方案展示训练情况，1：用户没方案但是有最常参加的体育运动，-1：二无青年
    var commonInjuriesTitle : String = ""//运动名称
    var thisWeekCourses : [thisWeekCourses] = []//本周课程
    var thisWeekPlans : [thisWeekPlansModel] = []//本周计划
    var commonInjuries : [commonInjuriesModel] = []//常见伤病
    var recommendStrengthenCourses : [recommendStrengthenCoursesModel] = []//推荐强化课程
    init() {}
    required init?(map: Map){
        mapping(map: map)
    }
    // Mappable
    func mapping(map: Map) {
        status <- map["status"]
        indexStyle <- map["indexStyle"]
        commonInjuriesTitle <- map["commonInjuriesTitle"]
        trainingTimeLen <- map["trainingTimeLen"]
        trainingProgress <- map["trainingProgress"]
        stabilityTrainingTimes <- map["stabilityTrainingTimes"]
        strengthTrainingTimes <- map["strengthTrainingTimes"]
        thisWeekCourses <- map["thisWeekCourses"]
        thisWeekPlans <- map["thisWeekPlans"]
        commonInjuries <- map["commonInjuries"]
        recommendStrengthenCourses <- map["recommendStrengthenCourses"]
    }
}
