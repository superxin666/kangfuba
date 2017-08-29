//
//  InguryPositionModel.swift
//  kangfuba
//
//  Created by LiChuanmin on 2016/10/31.
//  Copyright © 2016年 Xunqiu. All rights reserved.
//

import UIKit
import ObjectMapper

class InguryPositionModel: Mappable {

    var status: Int = 0//状态码
    var guidevideo : String!//视频连接
    var positionMenu : [PartInguryPositionModel] = []//疼痛分类

    init() {}
    required init?(map: Map){
        mapping(map: map)
    }
    // Mappable
    func mapping(map: Map) {
        status <- map["status"]
        guidevideo <- map["guidevideo"]
        positionMenu <- map["positionMenu"]
        
    }
}
