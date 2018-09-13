//
//  CXCommitListController.swift
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
class CXCommitListController: UITableViewController {
    public var starModel:Repo?
    var branch:Branch?
    var commits = [Commit?]()
    var page = 1
    var language = "swift"
    var isRefresh = false
    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.register(UINib.init(nibName: "CXCommitListCell", bundle: nil), forCellReuseIdentifier: "CXCommitListCell")
        self.tableView.rowHeight = UITableViewAutomaticDimension
        self.tableView.estimatedRowHeight = 200
        self.tableView.tableFooterView = UIView()
        self.tableView.mj_header = MJRefreshNormalHeader(refreshingBlock: {
            self.refreshData(loadMore:false)
        })
        self.refreshData(loadMore:false)
        
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
        
        
        if let login =  starModel?.owner?.login,let repoName = starModel?.name,let bran = branch?.commit?.sha{
            let url = "https://api.github.com/repos/" + "\(login)/\(repoName)/commits" + "?sha=\(String(describing: bran))"
            SVProgressHUD.show()
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
                        print("branches count is \(self.commits.count)")
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
    
    // MARK: - Table view data source
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.commits.count
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CXCommitListCell", for: indexPath) as! CXCommitListCell
        let model:Commit = self.commits[indexPath.row]!
        cell.avatar.kf.setImage(with: URL(string: model.author?.avatar_url ?? ""))
        cell.nameLabel.text = model.commit?.author?.name ?? ""
        if let dateStr = model.commit?.author?.date,let date = dateStr.toDate()?.date {
            cell.timeLabel.text =  timeAgoSince(date)
        }
        cell.desLabel.text = model.commit?.message
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
       
        
        
    }

}
