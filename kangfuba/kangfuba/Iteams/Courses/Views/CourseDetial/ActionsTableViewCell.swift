//
//  ActionsTableViewCell.swift
//  kangfuba
//
//  Created by lvxin on 2016/10/24.
//  Copyright © 2016年 Xunqiu. All rights reserved.
//  课程详情动作cell

import UIKit
let itemWidth :CGFloat = ip6(90)
let itemHeight :CGFloat = ip6(103)


class ActionsTableViewCell: UITableViewCell ,UICollectionViewDelegate,UICollectionViewDataSource{
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    var dataArr : [ActionGifModel] = []



    func setUpUI(model : CourseDetialModel) {
        self.backgroundColor = LINE_COLOUR
        //图片 名字 数据
        //此时要去掉 相同重复的gifmodel（组别的）
        dataArr = self.selectedModelArr(model: model)
        //白色背景
        let backView : UIView = UIView(frame: CGRect(x: 0, y: 10, width: KSCREEN_WIDTH, height: itemHeight))
        backView.backgroundColor = .white
        self.addSubview(backView)

        //底线
        let line = CALayer()
        line.frame = CGRect(x: 15, y: itemHeight - 0.5, width: KSCREEN_WIDTH - 30, height: 0.5)
        line.backgroundColor = LINE_COLOUR.cgColor
        backView.layer.addSublayer(line)


        //scrollerview
        let layout = UICollectionViewFlowLayout()
        layout.itemSize = CGSize(width: itemWidth, height: itemHeight)
        layout.scrollDirection = .horizontal
        layout.minimumInteritemSpacing = ip6(6)
        layout.sectionInset = UIEdgeInsetsMake(0, ip6(3), 0, ip6(3))

        let colletionView = UICollectionView(frame: CGRect(x: 15, y: 0, width: KSCREEN_WIDTH-30, height: itemHeight), collectionViewLayout: layout)
        colletionView.register(ActionCollectionViewCell.self, forCellWithReuseIdentifier: "actioncollectioncell_id")
        colletionView.backgroundColor = .clear
        colletionView.delegate = self
        colletionView.dataSource = self
        colletionView.contentSize = CGSize(width: itemWidth * 10, height: itemHeight)
        
        backView.addSubview(colletionView)

    }

    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return dataArr.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if indexPath.row < dataArr.count {
            let cell :ActionCollectionViewCell  = collectionView.dequeueReusableCell(withReuseIdentifier: "actioncollectioncell_id", for: indexPath) as! ActionCollectionViewCell

            var nameStr : String = ""
            var picStr :String = ""
            let model = dataArr[indexPath.row]
            KFBLog(message: "cellid\(model.courseid)")
            nameStr = model.actname
            picStr = model.actpic
            cell.setUI(nameStr: nameStr, picStr: picStr)
            return cell
        } else {
            return UIView() as! UICollectionViewCell
        }
    }

    func selectedModelArr(model : CourseDetialModel) ->Array<ActionGifModel>{

        var numArr = Array<Int>()
        var modelArr = Array<Any>()
        for subModel in model.courseActGifs {
            KFBLog(message: "当前\(subModel.coursegifid)")
            if numArr.contains(subModel.coursegifid) {
                KFBLog(message: "含有")

            } else {
                KFBLog(message: "不含有")
               numArr.append(subModel.coursegifid)
               modelArr.append(subModel)
            }

        }


//        let arr: NSSet = NSSet(array:numArr)
//        //let setArr:<Int> = Array(arr.allObjects)
//        var modelArr = Array<Any>()
//
//        for num in arr.allObjects {
//            let b : Int = num as! Int
//            for a in model.courseActGifs {
//                if b == a.coursegifid {
//                   modelArr.append(a)
//                   break
//                }
//            }
//        }
        KFBLog(message: "赛选后的数组\(numArr)--\(modelArr)")
        return modelArr as! Array<ActionGifModel>
    }
}
