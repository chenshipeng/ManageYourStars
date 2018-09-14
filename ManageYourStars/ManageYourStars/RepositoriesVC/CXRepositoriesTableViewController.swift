//
//  CXRepositoriesTableViewController.swift
//  ManageYourStars
//
//  Created by 陈仕鹏 on 2017/8/31.
//  Copyright © 2017年 csp. All rights reserved.
//

import UIKit
import SVProgressHUD
import Alamofire
import Kingfisher
import MJRefresh
class CXRepositoriesTableViewController: UITableViewController {
    var repositories = [Repo?]()
    var page = 1
    var language = "Swift"
    var isRefresh = false
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationController?.navigationBar.tintColor = .black
        navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: self.navigationItem.backBarButtonItem?.style ?? .plain, target: nil, action: nil)
//        self.navigationController?.navigationBar.backIndicatorImage = UIImage(named:"back")
//        self.navigationController?.navigationBar.backIndicatorTransitionMaskImage = UIImage(named:"back")
        
        self.tableView.rowHeight = UITableViewAutomaticDimension
        self.tableView.estimatedRowHeight = 200
        self.tableView.tableFooterView = UIView()
        self.tableView.mj_header = MJRefreshNormalHeader(refreshingBlock: {
            self.refreshData(loadMore: false)
        })
        self.tableView.mj_footer = MJRefreshAutoNormalFooter(refreshingBlock: {
            self.refreshData(loadMore: true)
        })
        self.tableView.mj_header.beginRefreshing()
        
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
            if let login =  UserDefaults.standard.object(forKey: "currentLogin") {

                
                SVProgressHUD.show()
                let url = "https://api.github.com/users/" + "\(login)/repos"
                let params = ["type":"all",
                              "sort":"updated",
                              "page":"\(page)"]
                Alamofire.request(url, method: .get, parameters: params).responseJSON(completionHandler: { (response) in
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
                            print("repositories count is \(self.repositories.count)")
                        }
                        self.tableView.reloadData()
                        print("response is \(String(describing: response.result.value))")
                    }else{
                        if loadMore {
                            self.page = self.page - 1
                        }
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
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.repositories.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "RepoCell", for: indexPath) as! CXRespositoriesTableViewCell
        
        let model:Repo = self.repositories[indexPath.row]!
        cell.starModel = model
        
        return cell
    }
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let model:Repo = self.repositories[indexPath.row]!

        let vc = RepositoryDetailViewController()
        vc.starModel = model
//        vc.hidesBottomBarWhenPushed = true
        self.navigationController?.pushViewController(vc, animated: true)
    }
    

    
}
