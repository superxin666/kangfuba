//
//  thisWeekPlansModel.swift
//  kangfuba
//
//  Created by lvxin on 2016/12/23.
//  Copyright © 2016年 Xunqiu. All rights reserved.
//  本周康复计划

import UIKit
import ObjectMapper
class thisWeekPlansModel: Mappable {
    var dateStr : String = ""//几号
    var state : Bool = false//是否被选中
    var recommendCourses : [recommendCourses] = []//课程数组

    init() {}
    required init?(map: Map){
        mapping(map: map)
    }
    // Mappable
    func mapping(map: Map) {
        dateStr <- map["dateStr"]
        recommendCourses <- map["recommendCourses"]
    }

}
