//
//  CXTrendingListCell.swift
//  CXHub
//
//  Created by 陈仕鹏 on 2018/9/26.
//  Copyright © 2018 csp. All rights reserved.
//

import UIKit

class CXTrendingListCell: UITableViewCell {
    @IBOutlet weak var avatarImage: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var ownerLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var starsLabel: UILabel!
    @IBOutlet weak var languageLabel: UILabel!
    @IBOutlet weak var forkLabel: UILabel!
    var trendingModel:Trending?{
        didSet{
            
            self.nameLabel?.text = trendingModel?.name
            if let login = trendingModel?.owner?.login {
                self.ownerLabel.text = login
                
            }
            self.descriptionLabel.text = trendingModel?.description
            self.starsLabel.text = trendingModel?.stargazers_count ?? "0"
            if let url = trendingModel?.owner?.avatar_url {
                self.avatarImage.kf.setImage(with: URL(string:(url)))
                
            }else{
                print("avatar url is \(String(describing: trendingModel?.owner?.avatar_url))")
            }
            if let language = trendingModel?.language{
                print("language is \(language)")
                self.languageLabel.text = language
            }
            forkLabel.text = trendingModel?.forks_count ?? "0"
        }
    }
    override func awakeFromNib() {
        super.awakeFromNib()
        avatarImage.layer.cornerRadius = 30.0;
        avatarImage.layer.masksToBounds = true;
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
