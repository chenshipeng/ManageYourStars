//
//  CXUserListController.swift
//  ManageYourStars
//
//  Created by 陈仕鹏 on 2018/9/13.
//  Copyright © 2018 csp. All rights reserved.
//

import UIKit
import SVProgressHUD
import Alamofire
import Kingfisher
import MJRefresh
class CXUserListController: UITableViewController {

    var action:String?
    var userList = [Owner?]()
    var forkList = [StarredModel?]()
    var isFork = false
    
    var page = 1
    var isRefresh = false
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.register(UINib.init(nibName: "CXNormalCell", bundle: nil), forCellReuseIdentifier: "CXNormalCell")
        self.tableView.mj_header = MJRefreshNormalHeader(refreshingBlock: {
            self.refreshData(loadMore:false)
        })
        if UserDefaults.standard.object(forKey: "access_token") != nil {
            self.refreshData(loadMore:false)
            
        }
        
        self.tableView.mj_footer = MJRefreshAutoNormalFooter(refreshingBlock: {
            self.refreshData(loadMore:true)
        })

    }
    func refreshData(loadMore:Bool){
        
        if isRefresh {
            return
        }
        
        if loadMore {
            page = page + 1
        }else{
            page = 1
        }
        
        
        if UserDefaults.standard.object(forKey: "access_token") != nil {
            
            if let url = action {
                print("stared url is \(url)")
                isRefresh = true
                SVProgressHUD.show()
                Alamofire.request(url, method: .get, parameters: nil).responseJSON(completionHandler: { (response) in
                    
                    self.tableView.mj_header.endRefreshing()
                    self.tableView.mj_footer.endRefreshing()
                    
                    if response.result.isSuccess {
                        if !loadMore {
                            self.userList.removeAll()
                        }
                        SVProgressHUD.dismiss()
                        if let array = response.result.value as? Array<Any> {
                            print("\(array.count)")
                            if self.isFork {
                                if let arr = [StarredModel].deserialize(from: response.result.value as? NSArray){
                                    self.forkList.append(contentsOf: arr)
                                }
                            }else{
                                if let arr = [Owner].deserialize(from: response.result.value as? NSArray){
                                    self.userList.append(contentsOf: arr)
                                }
                            }
                            
                            print("stars count is \(self.userList.count)")
                        }
                        self.tableView.reloadData()
                        self.isRefresh = false
                        print("response is \(String(describing: response.result.value))")
                    }else{
                        if loadMore {
                            self.page = self.page - 1
                        }
                        self.isRefresh = false
                        
                        SVProgressHUD.dismiss()
                        SVProgressHUD.showError(withStatus: String(describing: response.result.value))
                        print("error is \(String(describing: response.result.error))")
                    }
                })
            }
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if isFork {
            return forkList.count
        }
        return self.userList.count
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CXNormalCell", for: indexPath) as! CXNormalCell
        cell.accessoryType = .disclosureIndicator
        if isFork {
            let model:StarredModel = self.forkList[indexPath.row]!
            cell.desImageView.kf.setImage(with: URL(string: model.owner?.avatar_url ?? ""))
            cell.desLabel.text = model.owner?.login ?? ""
        }else{
            let model:Owner = self.userList[indexPath.row]!
            cell.desImageView.kf.setImage(with: URL(string: model.avatar_url ?? ""))
            cell.desLabel.text = model.login
        }
        
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let vc = CXUserViewController()
        if isFork{
            let model:Owner = (self.forkList[indexPath.row]?.owner)!
            vc.login = model.login
        }else{
            let model:Owner = self.userList[indexPath.row]!
            vc.login = model.login

        }
        vc.hidesBottomBarWhenPushed = true
        self.navigationController?.pushViewController(vc, animated: true)
        
        
    }

}
