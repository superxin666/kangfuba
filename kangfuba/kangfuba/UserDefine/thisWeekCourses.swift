//
//  thisWeekCourses.swift
//  kangfuba
//
//  Created by lvxin on 2016/12/23.
//  Copyright © 2016年 Xunqiu. All rights reserved.
//  康复课程

import UIKit
import ObjectMapper
class thisWeekCourses: Mappable {
    var courseid : Int = 0//
    var completedTotleTrainCount : Int = 0//完成次数
    var timelen : Int = 0//时间
    var coursename : String = ""//标题
    var expertsInterpretUrl : String = ""//课程专家解读MP4文件地址，=空字符串时不显示UI
    var pic : String = ""//图片

    init() {}
    required init?(map: Map){
        mapping(map: map)
    }
    // Mappable
    func mapping(map: Map) {
        courseid <- map["courseid"]
        completedTotleTrainCount <- map["completedTotleTrainCount"]
        expertsInterpretUrl <- map["expertsInterpretUrl"]
        timelen <- map["timelen"]
        coursename <- map["coursename"]
        pic <- map["pic"]
    }
}
