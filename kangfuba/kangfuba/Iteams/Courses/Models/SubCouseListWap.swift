//
//  SubCouseListWap.swift
//  kangfuba
//
//  Created by lvxin on 2016/10/31.
//  Copyright © 2016年 Xunqiu. All rights reserved.
//  子课程列表

import UIKit

import ObjectMapper
class SubCouseListWap: Mappable {
    var datas : [SubCourseList] = []//数据数组
    var count : Int = 0//
    var total : Int = 0//
    var status : Int = 0//
    var msg : String = ""


    init() {}
    required init?(map: Map){
        mapping(map: map)
    }
    // Mappable
    func mapping(map: Map) {
        status <- map["status"]
        msg <- map["msg"]
        count <- map["count"]
        total <- map["total"]
        datas <- map["datas"]
    }
}
