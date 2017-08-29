//
//  InguryGuideModel.swift
//  kangfuba
//
//  Created by LiChuanmin on 2016/12/30.
//  Copyright © 2016年 Xunqiu. All rights reserved.
//

import UIKit
import ObjectMapper

class InguryGuideModel: Mappable {

    var guideMenuId: Int = 0
    var parentMenuId: Int = 0
    
    var menuName : String!
    var iconPic : String!
    var iconPicSelected : String!
    var des : String!

    
    init() {}
    required init?(map: Map){
        mapping(map: map)
    }
    // Mappable
    func mapping(map: Map) {
        guideMenuId <- map["guideMenuId"]
        parentMenuId <- map["parentMenuId"]
        menuName <- map["menuName"]
        iconPic <- map["iconPic"]
        iconPicSelected <- map["iconPicSelected"]
        des <- map["des"]
    }
}
