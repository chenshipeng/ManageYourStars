//
//  CXYourStarsViewController.swift
//  ManageYourStars
//
//  Created by 陈仕鹏 on 2017/8/19.
//  Copyright © 2017年 csp. All rights reserved.
//

import UIKit
import SVProgressHUD
class CXYourStarsViewController: UITableViewController {
    
    
    var stars = [String:Any]()

    override func viewDidLoad() {
        super.viewDidLoad()

        if UserDefaults.standard.object(forKey: "access_token") != nil {
            //进入个人详情页面
            let url = "https://api.github.com/users/chenshipeng/repos?sort=updated"
            let params = ["page":"1"]
            SVProgressHUD.show()
            NetworkRequest().getRequest(urlString: url, params: params, success: { (response) in
                SVProgressHUD.dismiss()
                
                print("\(response)")
            }, failure: { (error) in
                SVProgressHUD.showError(withStatus: error as! String)
                
            })
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return 20
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "starsCell", for: indexPath)


        return cell
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