//
//  GIFView.swift
//  kangfuba
//
//  Created by lvxin on 2016/11/9.
//  Copyright © 2016年 Xunqiu. All rights reserved.
//

import UIKit
import ImageIO
import QuartzCore
class GIFView: UIView {
    var width:CGFloat{return self.frame.size.width}
    var height:CGFloat{return self.frame.size.height}
    private var gifurl:NSURL! // 把本地图片转化成URL
    private var imageArr:Array<CGImage> = [] // 图片数组(存放每一帧的图片)
    private var timeArr:Array<NSNumber> = [] // 时间数组(存放每一帧的图片的时间)
    var totalTime:Float = 0 // gif动画时间
    var imagesArr:Array<UIImage> = Array() //
    /**
     *  加载本地GIF图片
     */
    func showGIFImageWithLocalName(name:String) {
        gifurl = Bundle.main.url(forResource: name, withExtension: "gif") as NSURL!
        totalTime = 0
        self.creatKeyFrame()
    }

    func showGifWitUrl(url : String)  {
         gifurl = NSURL(fileURLWithPath: url)
         totalTime = 0
         self.creatKeyFrame()
    }


    /**
     *  获取GIF图片的每一帧 有关的东西  比如：每一帧的图片、每一帧的图片执行的时间
     */
    private func creatKeyFrame() {
        let url:CFURL = gifurl as CFURL
        let gifSource = CGImageSourceCreateWithURL(url, nil)
        let imageCount = CGImageSourceGetCount(gifSource!)

        for i in 0..<imageCount {
            let imageRef = CGImageSourceCreateImageAtIndex(gifSource!, i, nil) // 取得每一帧的图片
            imageArr.append(imageRef!)
            imagesArr.append(UIImage(cgImage: imageRef!))

            let sourceDict:NSDictionary = CGImageSourceCopyPropertiesAtIndex(gifSource!, i, nil) as NSDictionary!
            let gifDict:NSDictionary = sourceDict.object(forKey: String(kCGImagePropertyGIFDictionary)) as! NSDictionary
            let time = gifDict[String(kCGImagePropertyGIFUnclampedDelayTime)] as! NSNumber// 每一帧的动画时间
            timeArr.append(time)
            totalTime += time.floatValue

            // 获取图片的尺寸 (适应)
            let imageWitdh = sourceDict[String(kCGImagePropertyPixelWidth)] as! NSNumber
            let imageHeight = sourceDict[String(kCGImagePropertyPixelHeight)] as! NSNumber
            if ((imageWitdh.floatValue)/(imageHeight.floatValue) != Float((width)/(height))) {
                self.fitScale(imageWitdh: CGFloat(imageWitdh.floatValue), imageHeight: CGFloat(imageHeight.floatValue))
            }
        }

        self.showAnimation()
    }

    /**
     *  (适应)
     */
    private func fitScale( imageWitdh:CGFloat, imageHeight:CGFloat) {
        var newWidth:CGFloat
        var newHeight:CGFloat
        if imageWitdh/imageHeight > width/height {
            newWidth = width
            newHeight = width/(imageWitdh/imageHeight)
        } else {
            newWidth = height/(imageHeight/imageWitdh)
            newHeight = height;
        }
        let point = self.center;
        self.frame.size = CGSize(width: newWidth, height: newHeight)
        self.center = point;
    }

    /**
     *  展示动画
     */
    private func showAnimation() {
        let animation = CAKeyframeAnimation(keyPath: "contents")
        var current:Float = 0
        var timeKeys:Array<NSNumber> = []

        for time in timeArr {
            timeKeys.append(NSNumber(value: current/totalTime))
            current += time.floatValue
        }
        animation.keyTimes = timeKeys
        animation.values = imageArr
        animation.repeatCount = HUGE;
        animation.duration = TimeInterval(totalTime)
        animation.isRemovedOnCompletion = false
        self.layer .add(animation, forKey: "MGGifView")
    }

}
