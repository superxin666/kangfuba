//
//  CourseDetialModel.swift
//  kangfuba
//
//  Created by lvxin on 2016/11/1.
//  Copyright © 2016年 Xunqiu. All rights reserved.
//  课程详解

import UIKit

import ObjectMapper
class CourseDetialModel: Mappable {
    var courseid : Int = 0//id
    var gifbackgroundmusicurl : String = ""//课程背景音乐
    var gifbackgroundmusicurlLocal : String = ""//课程背景音乐本地路径
    var timelen : Float = 0//课程时间
    var courseTypeId : Int = 0//课程类型
    var traintype : Int = 0//课程完成类型
    var groupNum : Int = 0//课程机组动作
    var isSelected : Int = 0//当前用户是否选择参加了该课程:0没选，1已选，-1方案推荐课程（不能加入课程也不能退出课程）-2强化课程
    var completedTotleTrainCount : Int = 0//用户完成训练该课程的总次数
    var pic : String = ""//图片
    var toppic : String = ""//图片
    var videourl : String = ""//视频地址
    var coursename : String = ""//名字
    var des : String = ""//描述
    var attentions : String = ""//注意事项
    var courseActGifs :[ActionGifModel] = []//动作gig数组

    init() {}
    required init?(map: Map){
        mapping(map: map)
    }
    // Mappable
    func mapping(map: Map) {
        courseid <- map["courseid"]
        timelen <- map["timelen"]
        isSelected <- map["isSelected"]
        courseTypeId <- map["courseTypeId"]
        traintype <- map["traintype"]
        groupNum <- map["groupNum"]
        completedTotleTrainCount <- map["completedTotleTrainCount"]
        pic <- map["pic"]
        toppic <- map["toppic"]
        videourl <- map["videourl"]
        coursename <- map["coursename"]
        des <- map["des"]
        attentions <- map["attentions"]
        courseActGifs <- map["courseActGifs"]
        gifbackgroundmusicurl <- map["backgroundmusicurl"]
    }
}

