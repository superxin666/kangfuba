//
//  recommendStrengthenCoursesModel.swift
//  kangfuba
//
//  Created by lvxin on 2016/12/28.
//  Copyright © 2016年 Xunqiu. All rights reserved.
//  推荐强化课程

import UIKit
import ObjectMapper
class recommendStrengthenCoursesModel: Mappable {
    var courseid: Int = 0//id
    var coursename: String!//课程名称
    var completedTotleTrainCount: Int = 0
    var pic: String = ""
    var timelen: Int = 0

    init() {}
    required init?(map: Map){
        mapping(map: map)
    }
    // Mappable
    func mapping(map: Map) {
        courseid <- map["courseid"]
        timelen <- map["timelen"]
        coursename <- map["coursename"]
        completedTotleTrainCount <- map["completedTotleTrainCount"]
        pic <- map["pic"]

    }
}
