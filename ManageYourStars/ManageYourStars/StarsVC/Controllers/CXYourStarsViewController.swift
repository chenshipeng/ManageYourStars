//
//  CXYourStarsViewController.swift
//  ManageYourStars
//
//  Created by 陈仕鹏 on 2017/8/19.
//  Copyright © 2017年 csp. All rights reserved.
//

import UIKit
import SVProgressHUD
import Alamofire
import Kingfisher
import MJRefresh
class CXYourStarsViewController: UITableViewController {
    
    
    var stars = [Repo?]()
    
    var page = 1
    var language = "swift"
    var isRefresh = false

    override func viewDidLoad() {
        super.viewDidLoad()
        
//        if #available(iOS 11.0, *) {
//            self.tableView.contentInsetAdjustmentBehavior = .never
//            self.tableView.contentInset = UIEdgeInsetsMake(64, 0, 0, 0)
//        }
        self.navigationController?.navigationBar.tintColor = .black
//        navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: self.navigationItem.backBarButtonItem?.style ?? .plain, target: nil, action: nil)
        self.tableView.rowHeight = UITableViewAutomaticDimension
        self.tableView.estimatedRowHeight = 200
        self.tableView.tableFooterView = UIView()
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
            if let login =  UserDefaults.standard.object(forKey: "currentLogin") {
                
                let url = "https://api.github.com/users/" + "\(login)/starred" + "?page=\(page)" + "&sort=stars&order=desc" + "&q=language:\(language)"
                print("stared url is \(url)")
                isRefresh = true

                Alamofire.request(url, method: .get, parameters: nil).responseJSON(completionHandler: { (response) in
                    
                    self.tableView.mj_header.endRefreshing()
                    self.tableView.mj_footer.endRefreshing()
                    
                    if response.result.isSuccess {
                        if !loadMore {
                            self.stars.removeAll()
                        }
                        SVProgressHUD.dismiss()
                        if let array = response.result.value as? Array<Any> {
                            print("\(array.count)")
                            if let arr = [Repo].deserialize(from: response.result.value as? NSArray){
                                self.stars.append(contentsOf: arr)
                            }
                            print("stars count is \(self.stars.count)")
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
        return self.stars.count
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "starsCell", for: indexPath) as! CXStarTableViewCell

        let model:Repo = self.stars[indexPath.row]!
        cell.starModel = model

        return cell
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let vc: RepositoryDetailViewController = RepositoryDetailViewController()
        let model:Repo = self.stars[indexPath.row]!
        vc.starModel = model
        vc.hidesBottomBarWhenPushed = true
        self.navigationController?.pushViewController(vc, animated: true)

        
    }
    

    
   



}
