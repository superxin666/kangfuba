//
//  CourseViewController.swift
//  kangfuba
//
//  Created by lvxin on 16/10/13.
//  Copyright © 2016年 Xunqiu. All rights reserved.
//  课程列表

import UIKit
let CELLHEIGHT : CGFloat = 190
let cell_id = "COURSEALL_ID"

class CourseViewController: BaseViewController,UITableViewDelegate,UITableViewDataSource {
    let _mainTableView:UITableView = UITableView(frame: CGRect(x: 0, y: -15, width:KSCREEN_WIDTH, height:KSCREEN_HEIGHT - 64))
    let request = CourseDataManger.sharedInstance
    var courseDataModle = CourseListModelWap()


    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.naviagtionTitle(titleName: "康复课程")
        self.creat_tableView()
        weak var weakSelf = self
        request.getCourseListData(complate: {(data) in
            weakSelf?.courseDataModle = data as! CourseListModelWap
            weakSelf?._mainTableView.reloadData()
        }, faile: {(erro) in
            if erro  == "403" {
                KFBLog(message: "账号异地登录请重新登录")
                self.KfbShowWithInfo(titleString: "账号异地登录请重新登录")
            } else {
                self.KfbShowWithInfo(titleString: erro)
            }

        })

    }
    override func navigationLeftBtnClick() {
        _=self.navigationController?.popViewController(animated: true)
    }
    func creat_tableView() {
        _mainTableView.backgroundColor = UIColor.clear
        _mainTableView.delegate = self;
        _mainTableView.dataSource = self;
        _mainTableView.tableFooterView = UIView()
        _mainTableView.separatorStyle = .none
        _mainTableView.showsVerticalScrollIndicator = false
        _mainTableView.showsHorizontalScrollIndicator = false
        let weekNib = UINib(nibName: "CourseAllTableViewCell", bundle: nil) //
        _mainTableView.register(weekNib, forCellReuseIdentifier: cell_id)
        self.view.addSubview(_mainTableView)

    }
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.courseDataModle.datas.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch indexPath.section {
        case 0:
            let cell : CourseAllTableViewCell  = tableView.dequeueReusableCell(withIdentifier: cell_id, for: indexPath) as! CourseAllTableViewCell
            if indexPath.row < courseDataModle.datas.count {
                cell.sutUpUI(dataModel: courseDataModle.datas[indexPath.row])
            }
            return cell
        default:
            return UITableViewCell()
        }
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        switch indexPath.section {
        case 0:
            return CELLHEIGHT
        default:
            return 0
        }
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        MobClick.event("017")
        let vc = SubCourseViewController()
        var model = CourseListModel()
        if indexPath.row < courseDataModle.datas.count {
            model = courseDataModle.datas[indexPath.row]
        }
        vc.coureseType = model.coursetypeid
        vc.navTitle = model.typename
        vc.hidesBottomBarWhenPushed = true
        self.navigationController?.pushViewController(vc, animated: true)
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
