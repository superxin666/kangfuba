//
//  SportsModel.swift
//  kangfuba
//
//  Created by LiChuanmin on 2016/12/30.
//  Copyright © 2016年 Xunqiu. All rights reserved.
//

import UIKit
import ObjectMapper

class SportsModel: Mappable {

    var count: Int = 0
    var start: Int = 0
    var total: Int = 0
    var status: Int = 0
    
    var msg : String!
    var datas : [SportsDetailModel] = []//选项
    
    init() {}
    required init?(map: Map){
        mapping(map: map)
    }
    // Mappable
    func mapping(map: Map) {
        count <- map["count"]
        start <- map["start"]
        total <- map["total"]
        status <- map["status"]
        msg <- map["msg"]
        datas <- map["datas"]
        
    }

    
}
