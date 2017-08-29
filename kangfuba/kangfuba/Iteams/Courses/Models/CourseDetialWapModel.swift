//
//  CourseDetialWapModel.swift
//  kangfuba
//
//  Created by lvxin on 2016/11/1.
//  Copyright © 2016年 Xunqiu. All rights reserved.
//  课程详解

import UIKit
import ObjectMapper
class CourseDetialWapModel: Mappable {
    var data : CourseDetialModel = CourseDetialModel()//数据数组
    var msg : Int = 0//
    var status : Int = 0//

    init() {}
    required init?(map: Map){
        mapping(map: map)
    }
    // Mappable
    func mapping(map: Map) {
        status <- map["status"]
        msg <- map["msg"]
        data <- map["data"]
    }
}
