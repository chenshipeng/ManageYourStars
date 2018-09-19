//
//  CXNormalCell.swift
//  ManageYourStars
//
//  Created by chenshipeng on 2018/9/3.
//  Copyright © 2018年 csp. All rights reserved.
//

import UIKit

class CXNormalCell: UITableViewCell {

    @IBOutlet weak var desImageView: UIImageView!
    @IBOutlet weak var desLabel: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        desImageView.layer.cornerRadius = 15.0
        desImageView.layer.masksToBounds = true
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
