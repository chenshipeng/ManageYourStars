//
//  CXBranchListController.swift
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
class CXBranchListController: UITableViewController {
    var commits = [Commit?]()
    public var starModel:Repo?
    var page = 1
    var language = "swift"
    var isRefresh = false
    override func viewDidLoad() {
        super.viewDidLoad()

        self.tableView.rowHeight = UITableViewAutomaticDimension
        self.tableView.estimatedRowHeight = 200
        self.tableView.tableFooterView = UIView()
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

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
            if let login =  starModel?.owner?.login,let repoName = starModel?.name {
                
                let url = "https://api.github.com/repos/" + "\(login)/\(repoName)/commits" + "?page=\(page)"
                print("stared url is \(url)")
                isRefresh = true
                
                Alamofire.request(url, method: .get, parameters: nil).responseJSON(completionHandler: { (response) in
                    
                    self.tableView.mj_header.endRefreshing()
                    self.tableView.mj_footer.endRefreshing()
                    print("response is \(String(describing: response.result.value))")

                    if response.result.isSuccess {
                        if !loadMore {
                            self.commits.removeAll()
                        }
                        SVProgressHUD.dismiss()
                        if let array = response.result.value as? Array<Any> {
                            print("\(array.count)")
                            if let arr = [Commit].deserialize(from: response.result.value as? NSArray){
                                self.commits.append(contentsOf: arr)
                            }
                            print("stars count is \(self.commits.count)")
                        }
                        self.tableView.reloadData()
                        self.isRefresh = false
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
    
    // MARK: - Table view data source
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.commits.count
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "starsCell", for: indexPath) as! CXStarTableViewCell
        
        let model:Commit = self.commits[indexPath.row]!
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let vc: RepositoryDetailViewController = RepositoryDetailViewController()
        let model:Commit = self.commits[indexPath.row]!
//        vc.starModel = model
        vc.hidesBottomBarWhenPushed = true
        self.navigationController?.pushViewController(vc, animated: true)
        
        
    }

}
