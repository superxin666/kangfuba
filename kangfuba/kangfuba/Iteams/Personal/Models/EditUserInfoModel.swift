//
//  EditUserInfoModel.swift
//  kangfuba
//
//  Created by LiChuanmin on 2016/11/8.
//  Copyright © 2016年 Xunqiu. All rights reserved.
//

import UIKit
import ObjectMapper

class EditUserInfoModel: Mappable {

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
