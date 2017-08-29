//
//  MyTrainRecordModel.swift
//  kangfuba
//
//  Created by LiChuanmin on 2016/11/9.
//  Copyright © 2016年 Xunqiu. All rights reserved.
//

import UIKit
import ObjectMapper

class MyTrainRecordModel: Mappable {

    var status: Int = 0//状态码,返回状态值：1：我的训练记录 0：您还没有训练记录
    var count: Int = 0
    var start: Int = 0
    var total: Int = 0
    var msg : String!//提示
    var datas : [RecordDetailModel] = []//选项

    
    init() {}
    required init?(map: Map){
        mapping(map: map)
    }
    // Mappable
    func mapping(map: Map) {
        status <- map["status"]
        count <- map["count"]
        start <- map["start"]
        total <- map["total"]
        msg <- map["msg"]
        datas <- map["datas"]
    }

    
}
