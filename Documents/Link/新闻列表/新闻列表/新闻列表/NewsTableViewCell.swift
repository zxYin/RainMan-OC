//
//  NewsTableViewCell.swift
//  新闻列表
//
//  Created by 殷子欣 on 2017/4/8.
//  Copyright © 2017年 yinzixin. All rights reserved.
//

import UIKit

class NewsTableViewCell: UITableViewCell {

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    @IBOutlet weak var labelTime: UILabel!
    @IBOutlet weak var labelTitle: UILabel!
}
