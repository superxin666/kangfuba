//
//  SubCourseViewController.swift
//  kangfuba
//
//  Created by lvxin on 2016/10/24.
//  Copyright © 2016年 Xunqiu. All rights reserved.
//  课程里的子课程

import UIKit
let iteam :CGFloat = (KSCREEN_WIDTH - 35)/2
let subcoursecolletioncell_id = "subcoursecolletioncell_id"

class SubCourseViewController: BaseViewController ,UICollectionViewDataSource,UICollectionViewDelegate{
    let request = CourseDataManger.sharedInstance
    var subCourseDataModle = SubCouseListWap()
    var colletionView : UICollectionView!
    var coureseType : Int!//课程id
    var navTitle : String = ""//标题
    var dataArr : [SubCourseList] = []//
    var num : Int = 0;//加载更多

    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.navigationBar_leftBtn()
        self.naviagtionTitle(titleName: navTitle)
        self.creatUI()
        self.getData()


    }
    override func navigationLeftBtnClick() {
        _=self.navigationController?.popViewController(animated: true)

    }

    func creatUI()  {
        let layout = UICollectionViewFlowLayout()
        layout.itemSize = CGSize(width: iteam, height: iteam)
        layout.scrollDirection = .vertical
        layout.minimumInteritemSpacing = 1.5
        layout.minimumLineSpacing = 1.5
        layout.sectionInset = UIEdgeInsetsMake(1.5, 1.5, 1.5, 1.5)

        colletionView = UICollectionView(frame: CGRect(x: 15, y: 15, width: KSCREEN_WIDTH-30, height: KSCREEN_HEIGHT - ip6(40)), collectionViewLayout: layout)
        colletionView.register(SubCourseCollectionViewCell.self, forCellWithReuseIdentifier: subcoursecolletioncell_id)
        colletionView.backgroundColor = .clear
        colletionView.delegate = self
        colletionView.dataSource = self
        colletionView.showsVerticalScrollIndicator = false
        colletionView.showsHorizontalScrollIndicator = false
        colletionView.contentSize = CGSize(width: KSCREEN_WIDTH-30, height: iteam * 10)
        colletionView.mj_footer = footer
        footer.setRefreshingTarget(self, refreshingAction: #selector(SubCourseViewController.loadMoreData))
        self.view.addSubview(colletionView)

    }
    func loadMoreData() {
        KFBLog(message: "获取更多数据")
        num += 10
        self.getData()
    }
    func getData()  {
        weak var weakSelf = self
        request.getSubCourseListData(start : num,courseTypeId: coureseType, complate: {(data) in
            weakSelf?.subCourseDataModle = data as! SubCouseListWap
            if weakSelf?.subCourseDataModle.status == 0{
                weakSelf?.KfbShowWithInfo(titleString: (weakSelf?.subCourseDataModle.msg)!)
                weakSelf?.colletionView.mj_footer.endRefreshing()
            } else {
                weakSelf?.dataArr = (weakSelf?.dataArr)! + (weakSelf?.subCourseDataModle.datas)!
                KFBLog(message: "数据个数\(weakSelf?.dataArr.count)")
                weakSelf?.colletionView.reloadData()
                weakSelf?.colletionView.mj_footer.endRefreshing()
            }

        }, faile: {(erro) in
            weakSelf?.KfbShowWithInfo(titleString: erro)
        })
    }
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return dataArr.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell :SubCourseCollectionViewCell  = collectionView.dequeueReusableCell(withReuseIdentifier: subcoursecolletioncell_id, for: indexPath) as! SubCourseCollectionViewCell
        if indexPath.row < dataArr.count {
            cell.setUI(model: dataArr[indexPath.row])
        }
        return cell
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        MobClick.event("018")
        if indexPath.row < dataArr .count {
            let vc = CoutrseDetialViewController()
            var model : SubCourseList = SubCourseList()
             model = dataArr[indexPath.row]
            vc.hidesBottomBarWhenPushed = true
            vc.isShowDownBtn = 1
            vc.courseID = model.courseid
            vc.courseName = model.coursename
            self.navigationController?.pushViewController(vc, animated: true)
        }

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
