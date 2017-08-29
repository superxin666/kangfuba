//
//  MyPlanHomeModel.swift
//  kangfuba
//
//  Created by lvxin on 2016/12/23.
//  Copyright © 2016年 Xunqiu. All rights reserved.
//

import UIKit
import ObjectMapper
class MyPlanHomeModel: Mappable {
    var status: Int = 0//状态码
    var msg: String = ""
    var dayNumRemaining: Int = 0//剩余时间
    var weekOrder: Int = 0//第几周
    var latest7DaysTrainings : latest7DaysTrainingsModel = latest7DaysTrainingsModel()//本周课程
    var other7DaysTraings : [latest7DaysTrainingsModel] = []//其余的课程
    init() {}
    required init?(map: Map){
        mapping(map: map)
    }
    // Mappable
    func mapping(map: Map) {
        status <- map["status"]
        msg <- map["msg"]
        dayNumRemaining <- map["dayNumRemaining"]
        weekOrder <- map["weekOrder"]
        latest7DaysTrainings <- map["latest7DaysTrainings"]
        other7DaysTraings <- map["other7DaysTraings"]
    }
}
