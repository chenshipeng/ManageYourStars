//
//  CXIssueListController.swift
//  ManageYourStars
//
//  Created by 陈仕鹏 on 2018/9/11.
//  Copyright © 2018 csp. All rights reserved.
//

import UIKit
import Alamofire
import SVProgressHUD
import Kingfisher
import SwiftDate
import MJRefresh
class CXIssueListController: UITableViewController {

    var page = 1
    var starModel:Repo?
    var issueArray = [Issue?]()
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Issues"
        tableView.estimatedRowHeight = 200
        tableView.rowHeight = UITableViewAutomaticDimension
        self.tableView.register(UINib.init(nibName: "CXIssueListCell", bundle: nil), forCellReuseIdentifier: "CXIssueListCell")
        self.tableView.mj_header = MJRefreshNormalHeader(refreshingBlock: {
            self.refreshData(loadMore:false)
        })
        self.tableView.mj_header.beginRefreshing()
        self.tableView.mj_footer = MJRefreshAutoNormalFooter(refreshingBlock: {
            self.refreshData(loadMore:true)
        })
    }
    func refreshData(loadMore:Bool){
        if loadMore {
            page = page + 1
        }else{
            page = 1
        }
        guard let login = starModel?.owner?.login else { return }
        guard let name = starModel?.name else { return }
        let url = "https://api.github.com/repos/\(login)/\(name)/issues"
        
        print("url is \(String(describing: url))")
        
        SVProgressHUD.show()
        Alamofire.request(url, method: .get, parameters: nil).responseJSON(completionHandler: { (response) in
            self.tableView.mj_header.endRefreshing()
            self.tableView.mj_footer.endRefreshing()
            
            if response.result.isSuccess {
                SVProgressHUD.dismiss()
                if let JSON = response.result.value {
                    print("JSON: \(JSON)")
                }
                if let array = response.result.value as? Array<Any> {
                    print("\(array.count)")
                    if let event = [Issue].deserialize(from: response.result.value as? NSArray){
                        self.issueArray.append(contentsOf: event)
                    }
                }
                self.tableView.reloadData()
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
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - Table view data source
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return self.issueArray.count
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CXIssueListCell", for: indexPath) as! CXIssueListCell
        let issue = issueArray[indexPath.row]
        cell.numberLabel.text = "#\(issue?.number ?? 0)"
        cell.desLabel.text = issue?.title
        cell.statusLabel.text = issue?.state
        if let dateStr = issue?.created_at,let date = dateStr.toDate()?.date {
            cell.timeLabel.text =  timeAgoSince(date)
        }
        
        return cell
    }
}
