//
//  CXPopularInfoCell.swift
//  ManageYourStars
//
//  Created by chenshipeng on 2018/9/3.
//  Copyright © 2018年 csp. All rights reserved.
//

import UIKit

class CXPopularInfoCell: UITableViewCell {

    @IBOutlet weak var starCountLabel: UILabel!
    @IBOutlet weak var starDesLabel: UILabel!
    @IBOutlet weak var forkCountLabel: UILabel!
    @IBOutlet weak var forkDesLabel: UILabel!
    @IBOutlet weak var watchCountLabel: UILabel!
    @IBOutlet weak var watchDesLabel: UILabel!
    @IBOutlet weak var starsBackView: UIView!
    @IBOutlet weak var forksBackView: UIView!
    @IBOutlet weak var watchesBackView: UIView!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
