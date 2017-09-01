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
    
    
    var stars = [StarredModel?]()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        self.tableView.rowHeight = UITableViewAutomaticDimension
        self.tableView.estimatedRowHeight = 200
        self.tableView.tableFooterView = UIView()
        self.tableView.mj_header = MJRefreshNormalHeader(refreshingBlock: {
            self.refreshData()
        })
        self.tableView.mj_header.beginRefreshing()

        
    }
    
    func refreshData(){
        if UserDefaults.standard.object(forKey: "access_token") != nil {
            self.stars.removeAll()
            SVProgressHUD.show()
            if let login =  UserDefaults.standard.object(forKey: "currentLogin") {
                
                let url = "https://api.github.com/users/" + "\(login)/starred"
                let params = ["language":"Swift"]
                Alamofire.request(url, method: .get, parameters: params).responseJSON(completionHandler: { (response) in
                    
                    self.tableView.mj_header.endRefreshing()
                    
                    if response.result.isSuccess {
                        SVProgressHUD.dismiss()
                        if let array = response.result.value as? Array<Any> {
                            print("\(array.count)")
                            if let arr = [StarredModel].deserialize(from: response.result.value as? NSArray){
                                self.stars.append(contentsOf: arr)
                            }
                            print("stars count is \(self.stars.count)")
                        }
                        self.tableView.reloadData()
                        print("response is \(String(describing: response.result.value))")
                    }else{
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

        let model:StarredModel = self.stars[indexPath.row]!
        cell.starModel = model

        return cell
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
