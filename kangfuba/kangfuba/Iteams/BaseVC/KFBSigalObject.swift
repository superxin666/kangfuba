//
//  KFBSigalObject.swift
//  kangfuba
//
//  Created by lvxin on 2016/10/26.
//  Copyright © 2016年 Xunqiu. All rights reserved.
//  单利

import UIKit
private let sharedKraken = KFBSigalObject()
class KFBSigalObject: NSObject {
    class var sharedInstance: KFBSigalObject {
        return sharedKraken
    }

    
}
