//
//  MyTrainingRecoredCell.swift
//  kangfuba
//
//  Created by LiChuanmin on 2016/11/9.
//  Copyright © 2016年 Xunqiu. All rights reserved.
//

import UIKit

class MyTrainingRecoredCell: UITableViewCell {

    var TitleLabel:UILabel = UILabel()
    var CourceLabel:UILabel = UILabel()
    var TimeLabel:UILabel = UILabel()
    var iconImageView:UIImageView = UIImageView()
    
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.backgroundColor = LINE_COLOUR
        self.selectionStyle = UITableViewCellSelectionStyle.none

        setUpviews()
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setUpviews() {
    
        let bgview = UIView(frame:CGRect(x:0,y:0,width:KSCREEN_WIDTH,height:80))
        bgview.backgroundColor = UIColor.white
        self.contentView.addSubview(bgview)
        
        self.TitleLabel.frame = CGRect(x:15,y:10,width:KSCREEN_WIDTH - 30,height:20)
        self.TitleLabel.font = UIFont.systemFont(ofSize: 12)
        self.TitleLabel.textAlignment = NSTextAlignment.left
        self.TitleLabel.textColor = GRAY656A72_COLOUR
        self.contentView.addSubview(self.TitleLabel)

        let lineView = UIView(frame:CGRect(x:15,y:39,width:KSCREEN_WIDTH - 30,height:1))
        lineView.backgroundColor = LINE_COLOUR
        self.contentView.addSubview(lineView)

        self.iconImageView.frame = CGRect(x:30,y:51,width:18,height:18)
        self.iconImageView.image = UIImage(named:"MyTrainingRecord_icon_ok")
        self.contentView.addSubview(self.iconImageView)
        
        self.CourceLabel.frame = CGRect(x:58,y:50,width:KSCREEN_WIDTH - 75 - 50,height:20)
        self.CourceLabel.font = UIFont.systemFont(ofSize: 12)
        self.CourceLabel.textAlignment = NSTextAlignment.left
        self.CourceLabel.textColor = GRAY999999_COLOUR
        self.contentView.addSubview(self.CourceLabel)
        
        self.TimeLabel.frame = CGRect(x:KSCREEN_WIDTH - 65,y:50,width: 50,height:20)
        self.TimeLabel.font = UIFont.systemFont(ofSize: 12)
        self.TimeLabel.textAlignment = NSTextAlignment.right
        self.TimeLabel.textColor = GRAY999999_COLOUR
        self.contentView.addSubview(self.TimeLabel)

    }
    
    
    func setCellDatasWithModel(model:RecordDetailModel) {
        
        self.TitleLabel.text = model.completiontime
        self.CourceLabel.text = model.courseName
        if model.timeLen > 0 {
            let minutes:Int = (model.timeLen+59)/60
            self.TimeLabel.text = "\(minutes)分钟"
        }else{
            self.TimeLabel.text = "1分钟"
        }
    }
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        
        setUpviews()
        
    }
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
