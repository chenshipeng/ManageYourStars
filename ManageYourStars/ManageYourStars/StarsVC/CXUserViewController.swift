//
//  CXUserViewController.swift
//  ManageYourStars
//
//  Created by 陈仕鹏 on 2017/9/4.
//  Copyright © 2017年 csp. All rights reserved.
//

import UIKit
import Alamofire
import SVProgressHUD
class CXUserViewController: UIViewController {
//    var starModel:StarredModel?
    
    
    var avatar_url:String?
    var login:String?

    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var avatarImageView: UIImageView!
    @IBOutlet var tabBarView: TabBarView!
    @IBOutlet weak var backImageView: UIImageView!
    @IBOutlet weak var tableView: UITableView!
    var repositoriesArr = [StarredModel?]()
    var followingArr = [CXUserModel?]()
    var followerArr = [CXUserModel?]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
       
        self.setupUI()
        self.addNotification()
        self.firstLoadData()
        
        
        
      
        
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: true)
    }
    func setupUI(){
        
       

        self.tableView.delegate = self
        self.tableView.dataSource = self
        self.tableView.estimatedRowHeight = 120
        self.tableView.rowHeight = UITableViewAutomaticDimension
        avatarImageView.layer.cornerRadius = 40.0
        avatarImageView.layer.masksToBounds = true
        
        if let avatar_url = self.avatar_url {
            avatarImageView.kf.setImage(with: URL(string:avatar_url))
            backImageView.kf.setImage(with: URL(string:avatar_url))
            
        }
        nameLabel.text = self.login
    }
    
    func addNotification() {
        NotificationCenter.default.addObserver(self, selector:#selector(CXUserViewController.selectTabbarMenu(no:)), name: NSNotification.Name(rawValue: "didSelectMenu"), object: nil)
    }
    
    func firstLoadData(){
        self.getUserInfo()
        self.getUserReposotories()
    }
    
    @objc func selectTabbarMenu(no:Notification){
        let index = no.userInfo!["index"] as! Int
        
        if index == 1 && followingArr.count == 0 {
            self.getUserFollowings()
        }
        
        if index == 2 && followerArr.count == 0 {
            self.getUserFollowers()
        }
        
        
        
        self.tableView.reloadData()
    }
    
    func getUserInfo(){
        //进入个人详情页面
        guard let currentLogin = self.login  else {
            return
        }
        let url = "https://api.github.com/users/" + "\(String(describing: currentLogin))"
        
        print("url is \(url)")
        
        SVProgressHUD.show()
        Alamofire.request(url, method: .get, parameters: nil).responseString(completionHandler: { (response) in
            
            if response.result.isSuccess {
                SVProgressHUD.dismiss()
                if let arr = CXUserModel.deserialize(from: response.result.value){
                    self.tabBarView.countArray = [arr.public_repos,arr.following,arr.followers]

                }
//                print("response is \(String(describing: response.result.value))")
            }else{
                SVProgressHUD.dismiss()
                SVProgressHUD.showError(withStatus: String(describing: response.result.value))
            }
        })
    }
    func getUserReposotories(){
        //进入个人详情页面
        self.repositoriesArr.removeAll()
        guard let currentLogin = self.login  else {
            return
        }
        let url = "https://api.github.com/users/" + "\(String(describing: currentLogin))/repos?sort=updated&page=" + "1"
        print("url is \(url)")
        
        SVProgressHUD.show()
        Alamofire.request(url, method: .get, parameters: nil).responseJSON(completionHandler: { (response) in
            
            if response.result.isSuccess {
                SVProgressHUD.dismiss()
                if let arr = [StarredModel].deserialize(from: response.result.value as? NSArray){
                    print("response is \(String(describing: response.result.value))")

                    self.repositoriesArr.append(contentsOf:arr)
                }
                self.tableView.reloadData()
            }else{
                SVProgressHUD.dismiss()
                SVProgressHUD.showError(withStatus: String(describing: response.result.value))
            }
        })
    }
    func getUserFollowings(){
        //进入个人详情页面
        self.followingArr.removeAll()
        guard let currentLogin = self.login  else {
            return
        }
        let url = "https://api.github.com/users/" + "\(String(describing: currentLogin))/following?page=" + "1"
        print("url is \(url)")
        
        SVProgressHUD.show()
        Alamofire.request(url, method: .get, parameters: nil).responseJSON(completionHandler: { (response) in
            
            if response.result.isSuccess {
                SVProgressHUD.dismiss()
                if let arr = [CXUserModel].deserialize(from: response.result.value as? NSArray){
                    self.followingArr.append(contentsOf:arr)
                }
                self.tableView.reloadData()

                print("response is \(String(describing: response.result.value))")
            }else{
                SVProgressHUD.dismiss()
                SVProgressHUD.showError(withStatus: String(describing: response.result.value))
            }
        })
    }
    
    func getUserFollowers(){
        //进入个人详情页面
        self.followerArr.removeAll()
        guard let currentLogin = self.login  else {
            return
        }
        let url = "https://api.github.com/users/" + "\(String(describing: currentLogin))/followers?page=" + "1"
        print("url is \(url)")
        
        SVProgressHUD.show()
        Alamofire.request(url, method: .get, parameters: nil).responseJSON(completionHandler: { (response) in
            
            if response.result.isSuccess {
                SVProgressHUD.dismiss()
                if let arr = [CXUserModel].deserialize(from: response.result.value as? NSArray){
                    self.followerArr.append(contentsOf:arr)
                }
                self.tableView.reloadData()

                print("response is \(String(describing: response.result.value))")
            }else{
                SVProgressHUD.dismiss()
                SVProgressHUD.showError(withStatus: String(describing: response.result.value))
            }
        })
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

extension CXUserViewController:UITableViewDelegate,UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch tabBarView.selectedIndex {
        case 0:
            return repositoriesArr.count
        case 1:
            return followingArr.count
        case 2:
            return followerArr.count
        default:
            return repositoriesArr.count
        }
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
       
        if self.tabBarView.selectedIndex == 0 {
            
            self.tableView.register(UINib.init(nibName: "RepositoryCell", bundle: nil), forCellReuseIdentifier: "RepositoryCell")
            let cell = tableView.dequeueReusableCell(withIdentifier: "RepositoryCell", for: indexPath) as! RepositoryCell
            cell.selectionStyle = .none
            let repository = repositoriesArr[indexPath.row]
            cell.nameLabel.text = repository?.name
            if let login = repository?.owner?.login {
                cell.ownerLabel.text = "owner:" + login
            }else{
                if let login1 = self.login {
                    cell.ownerLabel.text = "owner:" + login1
                    
                }
            }
            if let stargazers_count = repository?.stargazers_count {
                cell.starsLabel.text = "Stars:" + "\(stargazers_count)"
                
            }else{
                cell.starsLabel.text = "Stars:0"
                
            }
            if let des = repository?.description {
                cell.descriptionLabel.text = des
                
            }else{
                cell.descriptionLabel.text = "no description"
                
            }
            
            return cell
        }else{
            self.tableView.register(UINib.init(nibName: "FollowCell", bundle: nil), forCellReuseIdentifier: "FollowCell")

            let cell = tableView.dequeueReusableCell(withIdentifier: "FollowCell", for: indexPath) as! FollowCell
            cell.selectionStyle = .none
            
            let user = tabBarView.selectedIndex == 1 ? followingArr[indexPath.row] : followerArr[indexPath.row]
            cell.nameLabel.text = user?.login
            if let url = user?.avatar_url {
                cell.avatarImage.kf.setImage(with: URL(string:(url)))

            }
            
            return cell
        }
        
        
        
        
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if tabBarView.selectedIndex != 0 {
            let vc: CXUserViewController = self.storyboard?.instantiateViewController(withIdentifier: "CXUserViewController") as! CXUserViewController
            let user = tabBarView.selectedIndex == 1 ? followingArr[indexPath.row] : followerArr[indexPath.row]
            vc.avatar_url = user?.avatar_url
            vc.login = user?.login
            self.navigationController?.pushViewController(vc, animated: true)
        }else{
            let model:StarredModel = self.repositoriesArr[indexPath.row]!
            
            let vc = RepositoryDetailViewController()
            vc.starModel = model
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }
}
