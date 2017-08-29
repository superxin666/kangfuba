//
//  latest7DaysTrainingsModel.swift
//  kangfuba
//
//  Created by lvxin on 2016/12/23.
//  Copyright © 2016年 Xunqiu. All rights reserved.
//

import UIKit
import ObjectMapper
class latest7DaysTrainingsModel: Mappable {
    var title: String = ""
    var recommendCourses : [MyPlancourseModel] = []//其余的课程
    init() {}
    required init?(map: Map){
        mapping(map: map)
    }
    // Mappable
    func mapping(map: Map) {
        title <- map["title"]
        recommendCourses <- map["recommendCourses"]
    }
}
