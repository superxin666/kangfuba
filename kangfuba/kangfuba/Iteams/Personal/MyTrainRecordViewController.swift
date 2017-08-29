//
//  MyTrainPlanViewController.swift
//  kangfuba
//
//  Created by LiChuanmin on 2016/10/18.
//  Copyright © 2016年 Xunqiu. All rights reserved.
//

import UIKit

class MyTrainRecordViewController: BaseViewController,UITableViewDataSource,UITableViewDelegate {

    let _mainTableView:UITableView = UITableView(frame: CGRect(x:0,y:0,width:KSCREEN_WIDTH,height:KSCREEN_HEIGHT-64),style:UITableViewStyle.plain)

    let request = PersonalDataManger.sharedInstance
    var trainDataModel : MyTrainRecordModel = MyTrainRecordModel()

    var startNumber = 0
    var countNumber = 10

    var trainModelArr : [RecordDetailModel]  = []
    var noDataLabel:UILabel = UILabel()

    
    override func viewWillAppear(_ animated: Bool) {
        header.beginRefreshing()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        naviagtionTitle(titleName: "我的训练记录")
        navigationBar_leftBtn()
        
        createTableView()
        
        // Do any additional setup after loading the view.
    }

    func createTableView() {
        
        _mainTableView.backgroundColor = UIColor.white
        _mainTableView.dataSource = self
        _mainTableView.delegate = self
        _mainTableView.showsVerticalScrollIndicator = false
        _mainTableView.separatorStyle = UITableViewCellSeparatorStyle.none
        _mainTableView.mj_header = header
        header.setRefreshingTarget(self, refreshingAction: #selector(MyTrainRecordViewController.headerRefresh))
        _mainTableView.mj_footer = footer
        footer.setRefreshingTarget(self, refreshingAction: #selector(MyTrainRecordViewController.footerRefresh))
        self.view.addSubview(_mainTableView)

    }
    
    func createNoDataView() {
        
        self.noDataLabel.frame = CGRect(x:50,y:100,width:KSCREEN_WIDTH - 100,height:20)
        self.noDataLabel.font = UIFont.systemFont(ofSize: 14)
        self.noDataLabel.textAlignment = NSTextAlignment.center
        self.noDataLabel.textColor = GRAY999999_COLOUR
        self.noDataLabel.text = "您还没有参加康复训练，快去训练吧";
        self.view.addSubview(self.noDataLabel)
    }
    
    // MARK: 刷新
    func headerRefresh() {
        KFBLog(message: "下拉刷新")
        startNumber = 0
        trainModelArr.removeAll()
        self.getData()

    }

    // MARK: 加载
    func footerRefresh() {
        KFBLog(message: "jaizai")
        startNumber += 10
        self.getData()
    }

    // MARK: 获取数据
    func getData()  {
        weak var weakSelf = self
        KFBLog(message: startNumber)
        KFBLog(message: countNumber)
        
        request.getTrainRecord(start: startNumber, count: countNumber, complate: { (data) in
            
        weakSelf?.trainDataModel = data as! MyTrainRecordModel
            
            weakSelf?.trainModelArr += (weakSelf?.trainDataModel.datas)!

            if((weakSelf?.trainModelArr.count)! > 0){
                
                weakSelf?._mainTableView.reloadData()
                weakSelf?._mainTableView.mj_header.endRefreshing()
                weakSelf?._mainTableView.mj_footer.endRefreshing()

            }else{
                if((weakSelf?._mainTableView) != nil){
                    weakSelf?._mainTableView .removeFromSuperview()
                }
                weakSelf?.createNoDataView()
            }
            
        }){ (error) in
            weakSelf?.KfbShowWithInfo(titleString: error as! String)

            weakSelf?._mainTableView.mj_header.endRefreshing()
            weakSelf?._mainTableView.mj_footer.endRefreshing()

            if((weakSelf?._mainTableView) != nil){
                weakSelf?._mainTableView .removeFromSuperview()
            }
        }
    }

    
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 0.001
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 90
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return trainModelArr.count
    }
   
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let model = trainModelArr[indexPath.row]

        let indentifier = "recordCell"

        var cell:MyTrainingRecoredCell! = tableView.dequeueReusableCell(withIdentifier: indentifier) as? MyTrainingRecoredCell

        if (cell == nil) {
            
            cell = MyTrainingRecoredCell(style:UITableViewCellStyle.default,reuseIdentifier:indentifier)
        }
        
        cell.setCellDatasWithModel(model: model)
        return cell!
    }
    
    
    override func navigationLeftBtnClick() {
        _=self.navigationController?.popViewController(animated: true)
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
