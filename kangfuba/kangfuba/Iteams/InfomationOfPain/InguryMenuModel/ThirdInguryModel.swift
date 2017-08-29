//
//  ThirdInguryModel.swift
//  kangfuba
//
//  Created by LiChuanmin on 2016/11/5.
//  Copyright © 2016年 Xunqiu. All rights reserved.
//

import UIKit
import ObjectMapper

class ThirdInguryModel: Mappable {

    var injuryinfomenuid: Int = 0
    var parentmenuid: Int = 0
    var positionid: Int = 0
    var pageindex: Int = 0
    var continuetest: Int = 0
    var istestpage: Int = 0

    var menuname : String!
    
    var help: Int = 0
    var helpWords : String!
    var helpPic : String!
    
    var isSelect: Int = 0//是否选中

    init() {}
    required init?(map: Map){
        mapping(map: map)
    }
    // Mappable
    func mapping(map: Map) {
        injuryinfomenuid <- map["injuryinfomenuid"]
        parentmenuid <- map["parentmenuid"]
        positionid <- map["positionid"]
        pageindex <- map["pageindex"]
        continuetest <- map["continuetest"]
        istestpage <- map["istestpage"]
        menuname <- map["menuname"]
        
        help <- map["help"]
        helpWords <- map["helpWords"]
        helpPic <- map["helpPic"]

        isSelect = 0
    }
}
