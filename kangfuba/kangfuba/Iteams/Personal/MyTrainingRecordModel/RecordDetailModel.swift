//
//  RecordDetailModel.swift
//  kangfuba
//
//  Created by LiChuanmin on 2016/11/9.
//  Copyright © 2016年 Xunqiu. All rights reserved.
//

import UIKit
import ObjectMapper

class RecordDetailModel: Mappable {

    var usertrainingid: Int = 0//训练id
    var userid: Int = 0//用户id
    var userinjuryid: Int = 0
    var programid: Int = 0
    var courseid: Int = 0//训练的课程id
    var times: Int = 0//第几次
    var traintype: Int = 0
    var timeLen: Int = 0//训练时长
    var completiontime : String!//训练完成时间
    var courseName : String!//训练课程名称
    
    
    init() {}
    required init?(map: Map){
        mapping(map: map)
    }
    // Mappable
    func mapping(map: Map) {
        usertrainingid <- map["usertrainingid"]
        userid <- map["userid"]
        userinjuryid <- map["userinjuryid"]
        programid <- map["programid"]
        courseid <- map["courseid"]
        times <- map["times"]
        traintype <- map["traintype"]
        timeLen <- map["timeLen"]
        completiontime <- map["completiontime"]
        courseName <- map["courseName"]
    }
    

    
}
