//
//  FileManger.swift
//  kangfuba
//
//  Created by lvxin on 2016/11/15.
//  Copyright © 2016年 Xunqiu. All rights reserved.
//  文件夹管理

import UIKit
private let sharedKraken = FileManger()
class FileManger: NSObject {
    var fileManager = FileManager.default
    
    var documentPaths : [String] = NSSearchPathForDirectoriesInDomains(FileManager.SearchPathDirectory.documentDirectory, FileManager.SearchPathDomainMask.userDomainMask, true)
    var dirPath :String = ""
    var fileName = "gifInfo.plist"
    var gifInfoPathStr = ""

    
    var expVideoPath :String = ""//讲解音地址
    var backGroundVideoPath :String = ""//讲解音地址
    var gifVideoPath :String = ""//gif文件夹地址
    
    var gifFileName = "gifFile"//gif文件夹名字
    var expVideoName = "expFile"//讲解音文件夹名字
    var backGroundVideoName = "backGroundVideoFile"//讲解音文件夹名字

    class var sharedInstance: FileManger {
        return sharedKraken
    }
    override init() {
        super.init()
        dirPath = documentPaths.first!
        gifInfoPathStr = dirPath + "/"+fileName
        
        gifVideoPath = documentPaths.first! + "/\(gifFileName)"
        expVideoPath = documentPaths.first! + "/\(expVideoName)"
        backGroundVideoPath = documentPaths.first! + "/\(backGroundVideoName)"

    }

    /// 存贮下载课程信息
    ///
    /// - parameter courseid: <#courseid description#>
    /// - parameter exist:    <#exist description#>
    func setCourseInfotoPlist(courseid: String,exist : Bool, complate : @escaping (_ data : Any) ->()) {
        KFBLog(message: "plist路径\(gifInfoPathStr)")
        if fileManager.fileExists(atPath: gifInfoPathStr) {
            //已经有plist
            let arr : NSArray = NSArray(contentsOfFile: gifInfoPathStr)!
             KFBLog(message: "数组\(arr)")
            if findKey(coursid: courseid, arr: arr as! [NSDictionary]) {
                //该课程已经存在了
                KFBLog(message: "该课程已经存在")
                complate(true)
            } else {
                //该课程不存在 存值
                let dict : NSDictionary = [
                    "courseid":courseid,
                    "exist":exist
                    ]
                KFBLog(message: courseid)
                let newArr : NSArray = arr.adding(dict) as NSArray
                KFBLog(message: "数组\(newArr)")
                let saveOk : Bool = newArr.write(toFile: gifInfoPathStr, atomically: true)
                if saveOk {
                    KFBLog(message: "插入数据成功")
                    complate(true)
                } else {
                    KFBLog(message: "插入数据失败")
                    complate(false)
                }

            }
        } else {
            //该plist不存在 存值
            let dict : NSDictionary = [
                "courseid":courseid,
                "exist":exist
                ]
            let arr : NSArray = [dict]
            //arr.adding(dict)
            let saveOk : Bool = arr.write(toFile: gifInfoPathStr, atomically: true)
            if saveOk {
                KFBLog(message: "插入数据成功")
                complate(true)
            } else {
                KFBLog(message: "插入数据失败")
                complate(false)
            }

        }
    }


    /// 查找当前课程是否已经下载
    ///
    /// - parameter coursid: <#coursid description#>
    ///
    /// - returns: <#return value description#>
    func findValue(coursid : String) -> Bool {
        if fileManager.fileExists(atPath: gifInfoPathStr) {
            let arr : NSArray = NSArray(contentsOfFile: gifInfoPathStr)!
            let result : Bool = self.findKey(coursid: coursid, arr: arr as! [NSDictionary])
            return result
        } else {
            return false
        }
    }

    //MARK删除所有课程数据
    func removeAllCourseData() {
        
//        删除plist数据 --- gifInfo.plist
        if fileManager.fileExists(atPath: gifInfoPathStr){
            try!fileManager.removeItem(atPath: gifInfoPathStr)
        }
        
//        清空gif文件夹数据 --- gifFile
        if fileManager.fileExists(atPath: gifVideoPath){
            try! fileManager.removeItem(atPath: gifVideoPath)

            do {
                try fileManager.createDirectory(atPath: gifVideoPath, withIntermediateDirectories: true, attributes: nil)
            } catch _ {
                KFBLog(message: "gifFile创建文件夹失败")
            }

        }
        
//        清空讲解语音文件夹数据 --- expFile
        if fileManager.fileExists(atPath: expVideoPath){
            try! fileManager.removeItem(atPath: expVideoPath)
            
            do {
                try fileManager.createDirectory(atPath: expVideoPath, withIntermediateDirectories: true, attributes: nil)
            } catch _ {
                KFBLog(message: "expFile创建文件夹失败")
            }
            
        }

//        清空讲解音文件夹数据 --- backGroundVideoFile
        if fileManager.fileExists(atPath: backGroundVideoPath){
            try! fileManager.removeItem(atPath: backGroundVideoPath)
            
            do {
                try fileManager.createDirectory(atPath: backGroundVideoPath, withIntermediateDirectories: true, attributes: nil)
            } catch _ {
                KFBLog(message: "backGroundVideoFile创建文件夹失败")
            }
            
        }
        
    }

    
    /// 查看该课程id是否已经存在
    ///
    /// - parameter coursid: <#coursid description#>
    /// - parameter arr:     <#arr description#>
    ///
    /// - returns: <#return value description#>
   private func findKey(coursid : String, arr : [NSDictionary]) -> Bool {
        var num : Int  = 0
        for dict:NSDictionary in arr {
            let dictValue : String = dict.value(forKey: "courseid") as! String
            if dictValue == coursid {
                num += 1
            }
        }
        return Bool(NSNumber(value: num))
    }

}
