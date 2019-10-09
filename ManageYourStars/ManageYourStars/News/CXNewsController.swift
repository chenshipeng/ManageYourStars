//
//  CXNewsController.swift
//  CXHub
//
//  Created by 陈仕鹏 on 2018/9/19.
//  Copyright © 2018 csp. All rights reserved.
//

import UIKit
import Alamofire
import SVProgressHUD
import Kingfisher
import SwiftDate
import MJRefresh
class CXNewsController: UITableViewController {

    var page = 1
    var login:String?
    var userSvents = [UserEvent?]()
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "News"
        if #available(iOS 13.0,*)  {
            self.navigationController?.navigationBar.tintColor = UIColor.init(dynamicProvider: { (train) -> UIColor in
                if train.userInterfaceStyle == .dark{
                    return .white
                }else{
                    return .black
                }
            })
        }else{
            self.navigationController?.navigationBar.tintColor = .black
        }
        navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: self.navigationItem.backBarButtonItem?.style ?? .plain, target: nil, action: nil)
        if let login =  UserDefaults.standard.object(forKey: "currentLogin") {
            self.login = login as? String
        }
        
        tableView.estimatedRowHeight = 200
        tableView.rowHeight = UITableViewAutomaticDimension
        self.tableView.register(UINib.init(nibName: "CXEventsCell", bundle: nil), forCellReuseIdentifier: "CXEventsCell")
        self.tableView.mj_header = MJRefreshNormalHeader(refreshingBlock: {
            self.refreshData(loadMore:false)
        })
        self.refreshData(loadMore:false)
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
        guard let currentLogin = self.login  else {
            return
        }
        let url = "https://api.github.com/users/" + "\(String(describing: currentLogin))" + "/received_events" + "?page=\(page)"
        
        print("url is \(url)")
        
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
                    if let event = [UserEvent].deserialize(from: response.result.value as? NSArray){
                        self.userSvents.append(contentsOf: event)
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
        
        return self.userSvents.count
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CXEventsCell", for: indexPath) as! CXEventsCell
        let event = userSvents[indexPath.row]
        cell.avatarImageView.kf.setImage(with: URL(string: event?.actor?.avatar_url ?? ""))
        cell.eventLabel.text = EventAction.getActionWith(event: event!)
        cell.messageLabel.text = EventMessage.getMessage(with: event!)
        if let dateStr = event?.created_at,let date = dateStr.toDate()?.date {
            cell.timeLabel.text =  timeAgoSince(date)
        }
        cell.eventTypeImageView.image = EventAvatar.image(for: event!)
        
        return cell
    }
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let model:Repo = self.userSvents[indexPath.row]?.repo{
            let vc = RepositoryDetailViewController()
            vc.url = model.url
            vc.hidesBottomBarWhenPushed = true
            self.navigationController?.pushViewController(vc, animated: true)
        }
        
        
    }
    
    
   

}
