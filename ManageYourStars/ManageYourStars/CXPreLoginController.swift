//
//  CXPreLoginController.swift
//  ManageYourStars
//
//  Created by 陈仕鹏 on 2018/9/12.
//  Copyright © 2018 csp. All rights reserved.
//

import UIKit

class CXPreLoginController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    @IBAction func loginBtnClicked(_ sender: UIButton) {
        let loginVC = CXLoginViewController()
        loginVC.autoPop = false
        loginVC.hidesBottomBarWhenPushed = true
        self.present(loginVC, animated: true, completion: {
            
        })
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
