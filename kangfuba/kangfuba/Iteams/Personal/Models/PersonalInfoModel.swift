//
//  PersonalInfoModel.swift
//  kangfuba
//
//  Created by LiChuanmin on 2016/11/1.
//  Copyright © 2016年 Xunqiu. All rights reserved.
//

import UIKit
import ObjectMapper

class PersonalInfoModel: Mappable {

    var usersid: Int = 0//用户id
    var usergender: Int = 0//性别 -1：未设置性别 0：女 1：男
    var userstate: Int = 0//
    var trainingtimelen: Int = 0//
    var currentinjuryinfoid: Int = 0//
    var programid: Int = 0//
    var favouriteSportId: Int = 0//

    var userbirthday : String!//用户出生日期
    var username : String!//用户名
    var userpass : String!//
    var userimage : String!//用户头像：前面加oss域名
    var usercreatetime : String!//
    var telphone : String!//手机号

    // MARK:- 构造函数

    
    init() {}
    required init?(map: Map){
        mapping(map: map)
    }
    // Mappable
    func mapping(map: Map) {
        usersid <- map["usersid"]
        usergender <- map["usergender"]
        userstate <- map["userstate"]
        trainingtimelen <- map["trainingtimelen"]
        currentinjuryinfoid <- map["currentinjuryinfoid"]
        programid <- map["programid"]
        favouriteSportId <- map["favouriteSportId"]

        userbirthday <- map["userbirthday"]
        username <- map["username"]
        userpass <- map["userpass"]
        userimage <- map["userimage"]
        usercreatetime <- map["usercreatetime"]
        telphone <- map["telphone"]

    }

}
