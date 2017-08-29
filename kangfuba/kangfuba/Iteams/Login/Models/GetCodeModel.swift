//
//  GetCodeModel.swift
//  kangfuba
//
//  Created by lvxin on 2016/10/25.
//  Copyright © 2016年 Xunqiu. All rights reserved.
//  获取验证码

import UIKit
import ObjectMapper
class GetCodeModel: Mappable{
    var status: Int = 0//状态码
    var msg : String!//提示

    init() {}
    required init?(map: Map){
        mapping(map: map)
    }
    // Mappable
    func mapping(map: Map) {
       status <- map["status"]
       msg <- map["msg"]
    }

}


