//
//  CXUserViewController.swift
//  ManageYourStars
//
//  Created by 陈仕鹏 on 2017/9/4.
//  Copyright © 2017年 csp. All rights reserved.
//

import UIKit
import ForceBlur
class CXUserViewController: UIViewController {
    var starModel:StarredModel?

    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var avatarImageView: UIImageView!
    @IBOutlet var tabBarView: TabBarView!
    @IBOutlet weak var backImageView: ForceBlurImageView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        avatarImageView.layer.cornerRadius = 40.0
        avatarImageView.layer.masksToBounds = true

        if let avatar_url = starModel?.owner?.avatar_url {
            avatarImageView.kf.setImage(with: URL(string:avatar_url))
            backImageView.kf.setImage(with: URL(string:avatar_url))

        }
        nameLabel.text = starModel?.owner?.login
        
//        tabBarView.countArray = [starModel.re]
        
    }
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.setNavigationBarHidden(false, animated: true)

    }

    @IBAction func pop(_ sender: Any) {
        
        navigationController?.popViewController(animated: true)
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
