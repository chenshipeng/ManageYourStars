//
//  CXMoreViewController.swift
//  ManageYourStars
//
//  Created by 陈仕鹏 on 2017/8/19.
//  Copyright © 2017年 csp. All rights reserved.
//

import UIKit

class CXMoreViewController: UITableViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        
        return 4
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return 1
    }

   
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "moreCell", for: indexPath)
        switch indexPath.section {
        case 0:
            cell.textLabel?.text = "登录"
        case 1:
            cell.textLabel?.text = "关于"
        case 2:
            cell.textLabel?.text = "反馈"
        case 3:
            cell.textLabel?.text = "退出登录"
        default:
            cell.textLabel?.text = ""
        }
            return cell
        
        
    }
     override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        if indexPath.row == 0 {
            if UserDefaults.standard.object(forKey: "access_token") == nil {
                let loginVC = CXLoginViewController()
                loginVC.hidesBottomBarWhenPushed = true
                navigationController?.pushViewController(loginVC, animated: true)
            }else{
                //进入个人详情页面
            }
            
        }
    }
  

    

}
