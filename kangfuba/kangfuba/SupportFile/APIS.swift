//
//  APIS.swift
//  kangfuba
//
//  Created by lvxin on 16/10/13.
//  Copyright © 2016年 Xunqiu. All rights reserved.
//  各种网络接口宏定义

import Foundation
//let BASER_API = "http://101.200.198.147:8080/xunqiu-recova"//测试域名
let BASER_API = "http://101.200.200.221:8080/xunqiu-recova"//线上域名备用
//let BASER_API = "https://apis.xunqiu.mobi/xunqiu-recova"//线上域名--https
//let BASER_API = "http://101.200.31.130:80/xunqiu-recova"//线上域名


//let OSS_API = "http://xunqiu-rehabilitation-img-test.oss-cn-beijing.aliyuncs.com"//测试服iss
let OSS_API = "http://xunqiu-rehabilitation-img.oss-cn-beijing.aliyuncs.com"//线上iss

// MARK:登录注册接口
let GETCODE_API = "/account/getToken"//获取验证码
let GETCODERESET_API = "/account/getResetPwdToken"//获取验证码 查找密码
let UPLOAD_USERICON = "/apis/utils/uploadImage"//上传头像
let LOGIN_API = "/account/login"//登录接口
let RESGITER_API = "/account/register"//注册
let RESGITPASS_API = "/account/resetPassword"//重置密码
let USERAGREEMENT_API = "/web/app/userAgreement?"//用户协议
// MARK:首页接口
let HOMEVIEW_API = "/user/index"//首页接口
let MYPLAN_API = "/user/indexDetailedPlan"//我的康复计划接口

// MARK:是否损伤
let getFirstGuideMenu_API = "/injury/getFirstGuideMenu"
// MARK:运动种类
let getSecondGuideMenu_API = "/injury/getSecondGuideMenu"
// MARK:设置用户最常参加的体育运动
let getUserFavouriteSport_API = "/user/setUserFavouriteSport"
// MARK:伤病情况接口
let InjuryPosition_API = "/injury/getInjuryPositionMenu"

// MARK:个人信息接口
let PersonalInfo_API = "/user/userInfo"
// MARK:修改个人信息
let EditUserInfo_API = "/user/editInfo"
// MARK:课程列表
let COURSELIST_API = "/course/courseTypeList"//首页接口
let SUBCOURSELIST_API = "/course/courseList"//课程子列表
let COURSEDETIAL_API = "/course/getCourseInfo"//课程详情
let JOINCOURSEDETIAL_API = "/course/participateTraining"//参加课程
let EXITCOURSEDETIAL_API = "/course/exitCourse"//退出课程
let UPLOADRECORD_API = "/training/uploadTrainingRecord"//上传记录
// MARK:伤病详情第一页菜单
let InjuryInfoMenu1Page_API = "/injury/getInjuryInfoMenu1Page"
// MARK:伤病详情第二页菜单
let InjuryInfoMenu2Page_API = "/injury/getInjuryInfoMenu2Page"
// MARK:我的训练记录
let MyTrainRecord_API = "/training/myTrainingRecord"
// MARK:生成方案
let CreateProgram_API = "/program/generatingProgram"
