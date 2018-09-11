//
//  CXRepositoriesListController.swift
//  ManageYourStars
//
//  Created by 陈仕鹏 on 2018/9/11.
//  Copyright © 2018 csp. All rights reserved.
//

import UIKit
import SVProgressHUD
import Alamofire
import Kingfisher
import MJRefresh
class CXRepositoriesListController: UITableViewController {
    
    var login:String?
    var repositories = [Repo?]()
    var page = 1
    var isRefresh = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Repositories"
        self.tableView.rowHeight = UITableViewAutomaticDimension
        self.tableView.estimatedRowHeight = 200
        self.tableView.tableFooterView = UIView()
        tableView.register(UINib(nibName: "CXReposotoryListCell", bundle: nil), forCellReuseIdentifier: "CXReposotoryListCell")
        self.tableView.mj_header = MJRefreshNormalHeader(refreshingBlock: {
            self.refreshData(loadMore:false)
        })
        if UserDefaults.standard.object(forKey: "access_token") != nil {
            self.tableView.mj_header.beginRefreshing()
            
        }
        
        self.tableView.mj_footer = MJRefreshAutoNormalFooter(refreshingBlock: {
            self.refreshData(loadMore:true)
        })
        
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(false, animated: true)
        
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
            
            SVProgressHUD.show()
            if let login =  login {
                
                let url = "https://api.github.com/users/" + "\(login)/repos"
                isRefresh = true
                
                Alamofire.request(url, method: .get, parameters: nil).responseJSON(completionHandler: { (response) in
                    
                    self.tableView.mj_header.endRefreshing()
                    self.tableView.mj_footer.endRefreshing()
                    
                    if response.result.isSuccess {
                        if !loadMore {
                            self.repositories.removeAll()
                        }
                        SVProgressHUD.dismiss()
                        if let array = response.result.value as? Array<Any> {
                            print("\(array.count)")
                            if let arr = [Repo].deserialize(from: response.result.value as? NSArray){
                                self.repositories.append(contentsOf: arr)
                            }
                            print("Repo count is \(self.repositories.count)")
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
    
    // MARK: - Table view data source
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.repositories.count
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CXReposotoryListCell", for: indexPath) as! CXReposotoryListCell
        let model:Repo = self.repositories[indexPath.row]!
        cell.avatarImageView.kf.setImage(with: URL(string: model.owner?.avatar_url ?? ""))
        cell.nameLabel.text = model.name
        cell.dseLabel.text = model.description
        cell.starsLabel.text = "\(model.stargazers_count ?? 0)"
        cell.pullRequestLabel.text = "\(model.forks_count ?? 0)"
        cell.orgLabel.text = model.owner?.login
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let vc = CXUserViewController()
        vc.login = repositories[indexPath.row]?.owner?.login
        vc.hidesBottomBarWhenPushed = true
        self.navigationController?.pushViewController(vc, animated: true)
        
        
    }
}
