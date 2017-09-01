//
//  CXMoreViewController.swift
//  ManageYourStars
//
//  Created by 陈仕鹏 on 2017/8/19.
//  Copyright © 2017年 csp. All rights reserved.
//

import UIKit
import SVProgressHUD
import Alamofire
import SwiftyJSON
import HandyJSON
class CXMoreViewController: UITableViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "More"
        
        if UserDefaults.standard.object(forKey: "access_token") != nil{
            getUserInfo()

        }
        
        NotificationCenter.default.addObserver(self, selector: #selector(CXMoreViewController.getUserInfo), name: NSNotification.Name(rawValue: "refreshMoreVC"), object: nil)

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
    }

    // MARK: - Table view data source

//    override func numberOfSections(in tableView: UITableView) -> Int {
//
//        return 4
//    }
//
//    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//
//        return 1
//    }

   
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "moreCell", for: indexPath)
        switch indexPath.section {
        case 0:
            if let userName = UserDefaults.standard.object(forKey: "currentLogin"){
                cell.textLabel?.text = userName as? String
                if let avatar_url = UserDefaults.standard.object(forKey: "avatar_url"){
                    cell.imageView?.kf.setImage(with: URL(string:avatar_url as! String))

                }
            }else{
                cell.textLabel?.text = "登录"
                cell.imageView?.image = nil

            }
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
    func getUserInfo(){
        //进入个人详情页面
        let url = "https://api.github.com/user"
        let params = ["access_token":UserDefaults.standard.object(forKey: "access_token")!]
        
        SVProgressHUD.show()
        Alamofire.request(url, method: .get, parameters: params).responseString(completionHandler: { (response) in
            
            if response.result.isSuccess {
                SVProgressHUD.dismiss()
                if let arr = CXUserModel.deserialize(from: response.result.value){
                    if let login = arr.login{
                        UserDefaults.standard.set(login, forKey: "currentLogin")
                        UserDefaults.standard.set(arr.avatar_url, forKey: "avatar_url")
                        
                    }
                }
                self.tableView.reloadData()
                print("response is \(String(describing: response.result.value))")
            }else{
                SVProgressHUD.dismiss()
                SVProgressHUD.showError(withStatus: String(describing: response.result.value))
            }
        })
    }
     override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        if indexPath.section == 0 {
            if UserDefaults.standard.object(forKey: "access_token") == nil {
                pushToLogin()
            }else{

            }
            
        }else if indexPath.section == 1 {
            pushToAboutMe()
        }else if indexPath.section == 3 {
            let alert = UIAlertController(title: "Warnning", message: "确定要退出吗？", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "取消", style: .cancel, handler: nil))
            alert.addAction(UIAlertAction(title: "确定", style: .default, handler: { (action) in
                self.doLogout()
            }))
            self.present(alert, animated: true, completion: nil)
        }
    }
    func pushToLogin(){
        let loginVC = CXLoginViewController()
        loginVC.hidesBottomBarWhenPushed = true
        navigationController?.pushViewController(loginVC, animated: true)
    }
    func pushToAboutMe(){
        let aboutMe = CXAboutMeViewController()
        aboutMe.hidesBottomBarWhenPushed = true
        navigationController?.pushViewController(aboutMe, animated: true)
    }
    func doLogout(){
        UserDefaults.standard.set(nil, forKey: "access_token")
        UserDefaults.standard.set(nil, forKey: "currentLogin")
        UserDefaults.standard.set(nil, forKey: "avatar_url")
        tableView.reloadData()
    }
  

    

}
