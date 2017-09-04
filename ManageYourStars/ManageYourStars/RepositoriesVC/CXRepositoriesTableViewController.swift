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
    var repositories = [StarredModel?]()

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
            if let login =  UserDefaults.standard.object(forKey: "currentLogin") {

                self.repositories.removeAll()
                SVProgressHUD.show()
                let url = "https://api.github.com/users/" + "\(login)/repos"
                let params = ["type":"all",
                              "sort":"updated"]
                Alamofire.request(url, method: .get, parameters: params).responseJSON(completionHandler: { (response) in
                    self.tableView.mj_header.endRefreshing()
                    
                    if response.result.isSuccess {
                        SVProgressHUD.dismiss()
                        if let array = response.result.value as? Array<Any> {
                            print("\(array.count)")
                            if let arr = [StarredModel].deserialize(from: response.result.value as? NSArray){
                                self.repositories.append(contentsOf: arr)
                            }
                            print("repositories count is \(self.repositories.count)")
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
        
        let model:StarredModel = self.repositories[indexPath.row]!
        cell.starModel = model
        
        return cell
    }
    

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
