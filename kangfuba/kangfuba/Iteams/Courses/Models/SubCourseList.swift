//
//  SubCourseList.swift
//  kangfuba
//
//  Created by lvxin on 2016/10/31.
//  Copyright © 2016年 Xunqiu. All rights reserved.
//  子课程列表 

import UIKit
import ObjectMapper
class SubCourseList: Mappable {
    var courseid : Int = 0//id
    var timelen : Int = 0//课程时间
    var pic : String = ""//图片
    var smallpic : String = ""//小图片
    var videourl : String = ""//图片
    var coursename : String = ""//图片

    init() {}
    required init?(map: Map){
        mapping(map: map)
    }
    // Mappable
    func mapping(map: Map) {
        courseid <- map["courseid"]
        timelen <- map["timelen"]
        videourl <- map["videourl"]
        coursename <- map["coursename"]
        pic <- map["pic"]
        smallpic <- map["smallpic"]
    }
}

