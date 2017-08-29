//
//  commonInjuriesModel.swift
//  kangfuba
//
//  Created by lvxin on 2016/12/28.
//  Copyright © 2016年 Xunqiu. All rights reserved.
//  常见伤病

import UIKit
import ObjectMapper
class commonInjuriesModel: Mappable {
    var commonInjuryId: Int = 0//id
    var pic: String!//图片地址
    var name : String = ""
    var des: String!//
    var contentUrl : String = ""
    init() {}
    required init?(map: Map){
        mapping(map: map)
    }
    // Mappable
    func mapping(map: Map) {
        commonInjuryId <- map["commonInjuryId"]
        pic <- map["pic"]
        name <- map["name"]
        des <- map["des"]
        contentUrl <- map["contentUrl"]
    }
}
