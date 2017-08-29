//
//  SecondInguryModel.swift
//  kangfuba
//
//  Created by LiChuanmin on 2016/11/5.
//  Copyright © 2016年 Xunqiu. All rights reserved.
//

import UIKit
import ObjectMapper

class SecondInguryModel: Mappable {

    var injuryinfomenuid: Int = 0
    var parentmenuid: Int = 0
    var positionid: Int = 0
    var pageindex: Int = 0
    var continuetest: Int = 0
    var istestpage: Int = 0
    
    var menuname : String!
    var testvideourl : String!
    var guidevideo : String!

    var Bmenu : [ThirdInguryModel] = []//选项
    var isShow: Int = 0//是否展开

    var testvideopic : String!

    var help: Int = 0
    var helpWords : String!
    var helpPic : String!
    
    
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
        testvideourl <- map["testvideourl"]
        testvideopic <- map["testvideopic"]
        guidevideo <- map["guidevideo"]

        Bmenu <- map["Bmenu"]
        isShow = 0
        
        help <- map["help"]
        helpWords <- map["helpWords"]
        helpPic <- map["helpPic"]

    }

    
}
