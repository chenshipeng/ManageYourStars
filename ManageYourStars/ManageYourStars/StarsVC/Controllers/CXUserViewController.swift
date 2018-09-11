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
import Kingfisher
import SABlurImageView
class CXUserViewController: UIViewController {
    var login:String?
    var tableView = UITableView()
    var userModel = CXUserModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
       
        self.setupUI()
        self.firstLoadData()
        
        
        
      
        
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    func setupUI(){

        title = login

        tableView.tableFooterView = UIView()
        tableView.register(UINib.init(nibName: "CXUserTopCell", bundle: nil), forCellReuseIdentifier: "CXUserTopCell")
        tableView.register(UINib.init(nibName: "CXNormalCell", bundle: nil), forCellReuseIdentifier: "CXNormalCell")
        view.addSubview(tableView)
        tableView.snp.makeConstraints { (make) in
            make.edges.equalTo(view)
        }
        self.tableView.delegate = self
        self.tableView.dataSource = self
    }
    func firstLoadData(){
        self.getUserInfo()
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
                if let model = CXUserModel.deserialize(from: response.result.value){
                    print("user info is %@",model.toJSON() as Any)
                    self.userModel = model
                    self.tableView.reloadData()
                }
//                print("response is \(String(describing: response.result.value))")
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

}

extension CXUserViewController:UITableViewDelegate,UITableViewDataSource{

    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.section == 0 {
            return 150
        }
        return 50
    }
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if section > 0 {
            return 10
        }
        return 0.0
    }
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        if section > 0 {
            let header = UIView(frame: CGRect(x: 0, y: 0, width: self.view.bounds.size.width, height: 10))
            header.backgroundColor = UIColor(red: 231.0/255.0, green: 231.0/255.0, blue: 231.0/255.0, alpha: 0.5)
            return header
        }
        return nil
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return 1
        }
        return 3
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        if indexPath.section == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "CXUserTopCell", for: indexPath) as! CXUserTopCell
            cell.selectionStyle = .none
            cell.avatarImageView.kf.setImage(with: URL(string: userModel.avatar_url ?? ""))
            cell.loginLabel.text = userModel.name
            cell.aNameLabel.text = userModel.login
            cell.followerCountLabel.text = userModel.followers
            cell.followingCountLabel.text = userModel.following
            return cell
        }
        let cell = tableView.dequeueReusableCell(withIdentifier: "CXNormalCell", for: indexPath) as! CXNormalCell
        cell.selectionStyle = .none
        cell.accessoryType = .disclosureIndicator
        cell.desImageView.image = UIImage(named: ["events","organization","repository"][indexPath.row])
        cell.desLabel.text = ["Events","Organizations","Repositories"][indexPath.row]
        return cell

        
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.section == 1,indexPath.row == 0 {
            let vc = CXEventsController()
            vc.login = self.login
            self.navigationController?.pushViewController(vc, animated: true)
        }
        if indexPath.section == 1,indexPath.row == 1 {
            let vc = CXOrganizationListController()
            vc.login = self.login
            navigationController?.pushViewController(vc, animated: true)
        }
        if indexPath.section == 1,indexPath.row == 2 {
            let vc = CXRepositoriesListController()
            vc.login = login
            vc.hidesBottomBarWhenPushed = true
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }
}