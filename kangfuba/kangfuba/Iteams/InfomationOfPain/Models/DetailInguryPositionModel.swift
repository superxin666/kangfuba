//
//  DetailInguryPositionModel.swift
//  kangfuba
//
//  Created by LiChuanmin on 2016/10/31.
//  Copyright © 2016年 Xunqiu. All rights reserved.
//

import UIKit
import ObjectMapper
class DetailInguryPositionModel: Mappable {

    var positionid: Int = 0
    var positionname: String!
    var parentpositionid: Int = 0
    var iconurl: String!
    var istestpage: Int = 0//下一页是否是测试页面 0不是 1是

    var isSelect: Int = 0//是否选中

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
        isSelect = 0
        istestpage <- map["istestpage"]
     }
    
}
