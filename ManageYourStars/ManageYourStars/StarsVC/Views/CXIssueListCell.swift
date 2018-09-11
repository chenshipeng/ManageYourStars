//
//  CXIssueListCell.swift
//  ManageYourStars
//
//  Created by 陈仕鹏 on 2018/9/11.
//  Copyright © 2018 csp. All rights reserved.
//

import UIKit

class CXIssueListCell: UITableViewCell {

    @IBOutlet weak var numberLabel: UILabel!
    @IBOutlet weak var desLabel: UILabel!
    @IBOutlet weak var statusLabel: UILabel!
    @IBOutlet weak var timeLabel: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
