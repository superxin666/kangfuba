//
//  CourseListModel.swift
//  kangfuba
//
//  Created by lvxin on 2016/10/31.
//  Copyright © 2016年 Xunqiu. All rights reserved.
//  课程列表

import UIKit
import ObjectMapper
class CourseListModel: Mappable {
    var typename : String = ""//类型名称
    var pic : String = ""//图片
    var coursetypeid : Int = 0//课程类型id


    init() {}
    required init?(map: Map){
        mapping(map: map)
    }
    // Mappable
    func mapping(map: Map) {
        typename <- map["typename"]
        pic <- map["pic"]
        coursetypeid <- map["coursetypeid"]

    }
}
