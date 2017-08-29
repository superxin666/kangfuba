//
//  PartInguryPositionModel.swift
//  kangfuba
//
//  Created by LiChuanmin on 2016/10/31.
//  Copyright © 2016年 Xunqiu. All rights reserved.
//

import UIKit
import ObjectMapper
class PartInguryPositionModel: Mappable {

    var positionid: Int = 0//伤病位置id
    var positionname: String!//位置名称
    var parentpositionid: Int = 0//上一级id，没什么用
    var iconurl: String!//icon地址
    var BMenu : [DetailInguryPositionModel] = []//详细位置

    var isShow: Int = 0//是否展开

    init() {}
    required init?(map: Map){
        mapping(map: map)
    }
    // Mappable
    func mapping(map: Map) {
        positionid <- map["positionid"]
        positionname <- map["positionname"]
        parentpositionid <- map["parentpositionid"]
        iconurl <- map["iconurl"]
        BMenu <- map["BMenu"]
        isShow = 0
    }

}
