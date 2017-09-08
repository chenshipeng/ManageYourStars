//
//  CXUserViewController.swift
//  ManageYourStars
//
//  Created by 陈仕鹏 on 2017/9/4.
//  Copyright © 2017年 csp. All rights reserved.
//

import UIKit
import ForceBlur
import Alamofire
import SVProgressHUD
class CXUserViewController: UIViewController {
    var starModel:StarredModel?

    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var avatarImageView: UIImageView!
    @IBOutlet var tabBarView: TabBarView!
    @IBOutlet weak var backImageView: ForceBlurImageView!
    var repositoriesArr = [Repository?]()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        avatarImageView.layer.cornerRadius = 40.0
        avatarImageView.layer.masksToBounds = true

        if let avatar_url = starModel?.owner?.avatar_url {
            avatarImageView.kf.setImage(with: URL(string:avatar_url))
            backImageView.kf.setImage(with: URL(string:avatar_url))

        }
        nameLabel.text = starModel?.owner?.login
        
        
        self.getUserInfo()
        
    }
    func getUserInfo(){
        //进入个人详情页面
        guard let currentLogin = starModel?.owner?.login  else {
            return
        }
        let url = "https://api.github.com/users" + "\(String(describing: currentLogin))"
        
        
        SVProgressHUD.show()
        Alamofire.request(url, method: .get, parameters: nil).responseString(completionHandler: { (response) in
            
            if response.result.isSuccess {
                SVProgressHUD.dismiss()
                if let arr = CXUserModel.deserialize(from: response.result.value){
                    self.tabBarView.countArray = [arr.public_repos!,arr.following!,arr.followers!]

                }
                print("response is \(String(describing: response.result.value))")
            }else{
                SVProgressHUD.dismiss()
                SVProgressHUD.showError(withStatus: String(describing: response.result.value))
            }
        })
    }
    func getUserReposotories(){
        //进入个人详情页面
        self.repositoriesArr.removeAll()
        guard let currentLogin = starModel?.owner?.login  else {
            return
        }
        let url = "https://api.github.com/users/" + "\(String(describing: currentLogin))/repos?sort=updated&page=" + "1"
        print("url is \(url)")
        
        SVProgressHUD.show()
        Alamofire.request(url, method: .get, parameters: nil).responseJSON(completionHandler: { (response) in
            
            if response.result.isSuccess {
                SVProgressHUD.dismiss()
                if let arr = [Repository].deserialize(from: response.result.value as? NSArray){
                    self.repositoriesArr.append(contentsOf:arr)
                }
                
                print("response is \(self.repositoriesArr))")
            }else{
                SVProgressHUD.dismiss()
                SVProgressHUD.showError(withStatus: String(describing: response.result.value))
            }
        })
    }
    func getUserFollowings(){
        //进入个人详情页面
        self.repositoriesArr.removeAll()
        guard let currentLogin = starModel?.owner?.login  else {
            return
        }
        let url = "https://api.github.com/users/" + "\(String(describing: currentLogin))/following?page=" + "1"
        print("url is \(url)")
        
        SVProgressHUD.show()
        Alamofire.request(url, method: .get, parameters: nil).responseJSON(completionHandler: { (response) in
            
            if response.result.isSuccess {
                SVProgressHUD.dismiss()
                if let arr = [Repository].deserialize(from: response.result.value as? NSArray){
                    self.repositoriesArr.append(contentsOf:arr)
                }
                
                print("response is \(self.repositoriesArr))")
            }else{
                SVProgressHUD.dismiss()
                SVProgressHUD.showError(withStatus: String(describing: response.result.value))
            }
        })
    }
    
    func getUserFollowers(){
        //进入个人详情页面
        self.repositoriesArr.removeAll()
        guard let currentLogin = starModel?.owner?.login  else {
            return
        }
        let url = "https://api.github.com/users/" + "\(String(describing: currentLogin))/followers?page=" + "1"
        print("url is \(url)")
        
        SVProgressHUD.show()
        Alamofire.request(url, method: .get, parameters: nil).responseJSON(completionHandler: { (response) in
            
            if response.result.isSuccess {
                SVProgressHUD.dismiss()
                if let arr = [Repository].deserialize(from: response.result.value as? NSArray){
                    self.repositoriesArr.append(contentsOf:arr)
                }
                
                print("response is \(self.repositoriesArr))")
            }else{
                SVProgressHUD.dismiss()
                SVProgressHUD.showError(withStatus: String(describing: response.result.value))
            }
        })
    }
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.setNavigationBarHidden(false, animated: true)

    }

    @IBAction func pop(_ sender: Any) {
        
        if let navigationController = navigationController, navigationController.viewControllers.first != self {
            navigationController.popViewController(animated: true)
        } else {
            dismiss(animated: true, completion: nil)
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
