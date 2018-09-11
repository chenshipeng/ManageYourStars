//
//  CXOrganizationListController.swift
//  ManageYourStars
//
//  Created by 陈仕鹏 on 2018/9/11.
//  Copyright © 2018 csp. All rights reserved.
//

import UIKit
import Alamofire
import SVProgressHUD
import Kingfisher
class CXOrganizationListController: UITableViewController {

    var login:String?
    var orgArray = [Org?]()
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Organizations"
        tableView.estimatedRowHeight = 200
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.tableFooterView = UIView()
        tableView.register(UINib.init(nibName: "CXNormalCell", bundle: nil), forCellReuseIdentifier: "CXNormalCell")
        refreshData()
        
    }
    func refreshData(){
       
        guard let currentLogin = self.login  else {
            return
        }
        let url = "https://api.github.com/users/" + "\(String(describing: currentLogin))" + "/orgs"
        
        print("url is \(url)")
        
        SVProgressHUD.show()
        Alamofire.request(url, method: .get, parameters: nil).responseJSON(completionHandler: { (response) in
            
            if response.result.isSuccess {
                SVProgressHUD.dismiss()
                if let JSON = response.result.value {
                    print("JSON: \(JSON)")
                }
                if let array = response.result.value as? Array<Any> {
                    print("\(array.count)")
                    if let org = [Org].deserialize(from: response.result.value as? NSArray){
                        self.orgArray.append(contentsOf: org)
                    }
                }
                self.tableView.reloadData()
            }else{
                SVProgressHUD.dismiss()
                SVProgressHUD.showError(withStatus: String(describing: response.result.value))
                print("error is \(String(describing: response.result.error))")
                
            }
        })
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50.0
    }
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return orgArray.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CXNormalCell", for: indexPath) as! CXNormalCell
        cell.selectionStyle = .none
        cell.accessoryType = .disclosureIndicator
        cell.desImageView.kf.setImage(with: URL(string: orgArray[indexPath.row]?.avatar_url ?? ""))
        cell.desLabel.text = orgArray[indexPath.row]?.login ?? ""
        return cell
    }
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let vc = OrgInfoTableViewController()
        vc.org = orgArray[indexPath.row]
        navigationController?.pushViewController(vc, animated: true)
    }

}
