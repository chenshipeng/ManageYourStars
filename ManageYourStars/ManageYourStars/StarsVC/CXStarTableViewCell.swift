//
//  CXStarTableViewCell.swift
//  ManageYourStars
//
//  Created by 陈仕鹏 on 2017/8/31.
//  Copyright © 2017年 csp. All rights reserved.
//

import UIKit

class CXStarTableViewCell: UITableViewCell {
    
    

    @IBOutlet weak var avatarImage: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var ownerLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var starsLabel: UILabel!
    @IBOutlet weak var languageLabel: UILabel!
    var starModel:StarredModel?{
        didSet{
            
            self.nameLabel?.text = starModel?.name
            if let login = starModel?.owner?.login {
                self.ownerLabel.text = "owner:" + login
                
            }
            self.descriptionLabel.text = starModel?.description
            self.starsLabel.text = "Stars:" + (starModel?.stargazers_count!)!
            if let url = starModel?.owner?.avatar_url {
                self.avatarImage.kf.setImage(with: URL(string:(url)))
                
            }else{
                print("avatar url is \(String(describing: starModel?.owner?.avatar_url))")
            }
            if let language = starModel?.language{
                print("language is \(language)")
                self.languageLabel.text = "Language:" + language

            }
        }
    }
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
