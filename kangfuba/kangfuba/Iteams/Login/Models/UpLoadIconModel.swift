//
//  UpLoadIconModel.swift
//  kangfuba
//
//  Created by lvxin on 2016/11/3.
//  Copyright © 2016年 Xunqiu. All rights reserved.
//

import UIKit
import ObjectMapper
class UpLoadIconModel: Mappable{
    var status: Int!//状态码
    var msg : String!//提示
    var data : String!//提示
    var url : String!//头像链接
    init() {}
    required init?(map: Map){
        mapping(map: map)
    }

    // Mappable
    func mapping(map: Map) {
        status <- map["status"]
        msg <- map["msg"]
        data <- map["data"]
//        if data.keys.contains("url") {
//            url = data["url"]
//        }

    }

}
