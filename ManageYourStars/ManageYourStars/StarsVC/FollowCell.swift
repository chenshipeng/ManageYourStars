//
//  FollowCell.swift
//  ManageYourStars
//
//  Created by 陈仕鹏 on 2017/9/9.
//  Copyright © 2017年 csp. All rights reserved.
//

import UIKit

class FollowCell: UITableViewCell {

    @IBOutlet weak var avatarImage: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.avatarImage.layer.cornerRadius = 30.0
        self.avatarImage.layer.masksToBounds = true
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
