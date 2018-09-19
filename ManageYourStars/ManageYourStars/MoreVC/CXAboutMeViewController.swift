//
//  CXAboutMeViewController.swift
//  ManageYourStars
//
//  Created by 陈仕鹏 on 2017/9/1.
//  Copyright © 2017年 csp. All rights reserved.
//

import UIKit

class CXAboutMeViewController: UIViewController {

    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var versionLabel: UILabel!
    @IBOutlet weak var githubLabel: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()

        self.title = "About Me"
        
        
        nameLabel.addTapGesture { (tap) in
            let vc = CXUserViewController()
            vc.login = "chenshipeng"
            vc.hidesBottomBarWhenPushed = true
            self.navigationController?.pushViewController(vc, animated: true)
        }
        if let version =  Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String{
            versionLabel.text = "CXHub\(version)"
        }
        githubLabel.addTapGesture { (tap) in
            let vc = CXWebController()
            vc.url = "https://github.com/chenshipeng"
            vc.title = "chenshipeng"
            vc.hidesBottomBarWhenPushed = true
            self.navigationController?.pushViewController(vc, animated: true)
        }
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
