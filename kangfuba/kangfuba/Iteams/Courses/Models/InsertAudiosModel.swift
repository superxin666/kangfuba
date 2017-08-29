//
//  InsertAudiosModel.swift
//  kangfuba
//
//  Created by lvxin on 2016/11/28.
//  Copyright © 2016年 Xunqiu. All rights reserved.
//

import UIKit
import ObjectMapper
class InsertAudiosModel: Mappable {
    var audioUrl : String = ""//指导音乐链接
    var audioLocalUrl : String = ""//指导音乐背景链接
    var secondNum : Int = 0

    init() {}
    required init?(map: Map){
        mapping(map: map)
    }
    // Mappable
    func mapping(map: Map) {
        audioUrl <- map["audioUrl"]
        secondNum <- map["secondNum"]
    }

}
