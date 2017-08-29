//
//  CreateProgramModel.swift
//  kangfuba
//
//  Created by LiChuanmin on 2016/11/10.
//  Copyright © 2016年 Xunqiu. All rights reserved.
//

import UIKit
import ObjectMapper

class CreateProgramModel: Mappable {

    var status: Int = 0
    
    var msg : String!
    
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
