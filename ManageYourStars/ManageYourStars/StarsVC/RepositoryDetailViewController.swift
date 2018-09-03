//
//  RepositoryDetailViewController.swift
//  ManageYourStars
//
//  Created by 陈仕鹏 on 2017/9/9.
//  Copyright © 2017年 csp. All rights reserved.
//

import UIKit
import SVProgressHUD
import Alamofire
import MJRefresh
import SnapKit
class RepositoryDetailViewController: UIViewController {

    public var starModel:StarredModel?
    
    private var tableView:UITableView = UITableView()
    
    var contributors = [CXUserModel?]()
    var forks = [StarredModel?]()
    var stargazers = [CXUserModel?]()

    override func viewDidLoad() {
        super.viewDidLoad()

        setupUI()
        
//        self.tableView.mj_header = MJRefreshNormalHeader(refreshingBlock: {
//            self.refreshData(loadMore:false)
//        })
//        self.tableView.mj_footer = MJRefreshAutoNormalFooter(refreshingBlock: {
//            self.refreshData(loadMore:true)
//        })
//        if UserDefaults.standard.object(forKey: "access_token") != nil {
//            self.tableView.mj_header.beginRefreshing()
//
//        }
//

        
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(false, animated: true)
    }
    func setupUI(){
        
        view.addSubview(tableView)
        tableView.snp.makeConstraints { (make) in
            make.edges.equalTo(view)
        }
        title = self.starModel?.full_name
        tableView.delegate = self
        tableView.dataSource = self
        tableView.estimatedRowHeight = 200
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.tableFooterView = UIView()

        tableView.register(UINib(nibName: "CXUserInfoCell", bundle: nil), forCellReuseIdentifier: "CXUserInfoCell")
        tableView.register(UINib(nibName: "CXPopularInfoCell", bundle: nil), forCellReuseIdentifier: "CXPopularInfoCell")
        tableView.register(UINib(nibName: "CXNormalCell", bundle: nil), forCellReuseIdentifier: "CXNormalCell")

    }

    func getRepoInfo(){
//        guard let name = self.starModel?.owner?.login  else {
//            return
//        }
//
//        guard let repo = self.starModel?.name  else {
//            return
//        }
//        let url = "https://api.github.com/repos/" + "\(String(describing: name))/" + "\(String(describing: repo))"
//
//        print("url is \(url)")
//
//        SVProgressHUD.show()
//        Alamofire.request(url, method: .get, parameters: nil).responseJSON(completionHandler: { (response) in
//            self.tableView.mj_header.endRefreshing()
//            self.tableView.mj_footer.endRefreshing()
//            if response.result.isSuccess {
//                SVProgressHUD.dismiss()
//                if !loadMore {
//                    self.contributors.removeAll()
//                }
//                if let arr = [CXUserModel].deserialize(from: response.result.value as? NSArray){
//
//                    self.contributors.append(contentsOf:arr)
//                }
//                self.tableView.reloadData()
//                print("response is \(String(describing: response.result.value))")
//            }else{
//
//                if loadMore {
//                    self.page1 = self.page1 - 1
//                }
//                SVProgressHUD.dismiss()
//                SVProgressHUD.showError(withStatus: String(describing: response.result.value))
//            }
//        })
    }
    func getContributors(loadMore:Bool) {
        //进入个人详情页面
//        guard let name = self.starModel?.owner?.login  else {
//            return
//        }
//
//        guard let repo = self.starModel?.name  else {
//            return
//        }
//
//        if isRefresh1 {
//            return
//        }
//
//        if loadMore {
//            page1 = page1 + 1
//        }else{
//            page1 = 1
//        }
//
//        let url = "https://api.github.com/repos/" + "\(String(describing: name))/" + "\(String(describing: repo))/contributors" + "?page=\(page1)"
//
//        print("url is \(url)")
//
//        SVProgressHUD.show()
//        Alamofire.request(url, method: .get, parameters: nil).responseJSON(completionHandler: { (response) in
//            self.tableView.mj_header.endRefreshing()
//            self.tableView.mj_footer.endRefreshing()
//            if response.result.isSuccess {
//                SVProgressHUD.dismiss()
//                if !loadMore {
//                    self.contributors.removeAll()
//                }
//                if let arr = [CXUserModel].deserialize(from: response.result.value as? NSArray){
//
//                    self.contributors.append(contentsOf:arr)
//                }
//                self.tableView.reloadData()
//                print("response is \(String(describing: response.result.value))")
//            }else{
//
//                if loadMore {
//                    self.page1 = self.page1 - 1
//                }
//                SVProgressHUD.dismiss()
//                SVProgressHUD.showError(withStatus: String(describing: response.result.value))
//            }
//        })
    }
    func getForks(loadMore:Bool){
        //进入个人详情页面
//        guard let name = self.starModel?.owner?.login  else {
//            return
//        }
//
//        guard let repo = self.starModel?.name  else {
//            return
//        }
//        if isRefresh2 {
//            return
//        }
//
//        if loadMore {
//            page2 = page2 + 1
//        }else{
//            page2 = 1
//        }
//        let url = "https://api.github.com/repos/" + "\(String(describing: name))/" + "\(String(describing: repo))/forks" + "?page=\(page2)"
//
//        print("url is \(url)")
//
//        SVProgressHUD.show()
//        Alamofire.request(url, method: .get, parameters: nil).responseJSON(completionHandler: { (response) in
//            self.tableView.mj_header.endRefreshing()
//            self.tableView.mj_footer.endRefreshing()
//            if response.result.isSuccess {
//                SVProgressHUD.dismiss()
//                if !loadMore {
//                    self.forks.removeAll()
//                }
//                if let arr = [StarredModel].deserialize(from: response.result.value as? NSArray){
//
//                    self.forks.append(contentsOf:arr)
//                }
//                self.tableView.reloadData()
//                print("response is \(String(describing: response.result.value))")
//            }else{
//
//                if loadMore {
//                    self.page2 = self.page2 - 1
//                }
//                SVProgressHUD.dismiss()
//                SVProgressHUD.showError(withStatus: String(describing: response.result.value))
//            }
//        })
    }
    func getStargazers(loadMore:Bool) {
        //进入个人详情页面
//        guard let name = self.starModel?.owner?.login  else {
//            return
//        }
//
//        guard let repo = self.starModel?.name  else {
//            return
//        }
//        if isRefresh3 {
//            return
//        }
//
//        if loadMore {
//            page3 = page3 + 1
//        }else{
//            page3 = 1
//        }
//        let url = "https://api.github.com/repos/" + "\(String(describing: name))/" + "\(String(describing: repo))/stargazers" + "?page=\(page3)"
//
//        print("url is \(url)")
//
//        SVProgressHUD.show()
//        Alamofire.request(url, method: .get, parameters: nil).responseJSON(completionHandler: { (response) in
//            self.tableView.mj_header.endRefreshing()
//            self.tableView.mj_footer.endRefreshing()
//            if response.result.isSuccess {
//                SVProgressHUD.dismiss()
//                if !loadMore {
//                    self.stargazers.removeAll()
//                }
//                if let arr = [CXUserModel].deserialize(from: response.result.value as? NSArray){
//
//                    self.stargazers.append(contentsOf:arr)
//                }
//                self.tableView.reloadData()
//                print("response is \(String(describing: response.result.value))")
//            }else{
//
//                if loadMore {
//                    self.page3 = self.page3 - 1
//                }
//                SVProgressHUD.dismiss()
//                SVProgressHUD.showError(withStatus: String(describing: response.result.value))
//            }
//        })
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}

extension RepositoryDetailViewController:UITableViewDelegate,UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case 0:
            return 2
        case 1:
            return 1
        case 2:
            return 3
        case 3:
            return 2
        default:
            return 0
        }
    }
    func numberOfSections(in tableView: UITableView) -> Int {
        return 4
    }
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if section > 0 {
            return 10
        }
        return 0.0
    }
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        if section > 0 {
            let header = UIView(frame: CGRect(x: 0, y: 0, width: self.view.bounds.size.width, height: 10))
            header.backgroundColor = UIColor(red: 231.0/255.0, green: 231.0/255.0, blue: 231.0/255.0, alpha: 0.5)
            return header
        }
        return nil
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch indexPath.section {
        case 0:
            if indexPath.row == 0 {
                let cell = tableView.dequeueReusableCell(withIdentifier: "CXUserInfoCell", for: indexPath) as! CXUserInfoCell
                cell.selectionStyle = .none
                cell.avatarImageView.kf.setImage(with:  URL(string:(self.starModel?.owner?.avatar_url)!))
                cell.userNameLabel.text = starModel?.name
                cell.repoDesLabel.text = starModel?.description
                return cell
            }else{
                let cell = tableView.dequeueReusableCell(withIdentifier: "CXPopularInfoCell", for: indexPath) as! CXPopularInfoCell
                cell.selectionStyle = .none
                cell.starCountLabel.text = starModel?.stargazers_count
                cell.forkCountLabel.text = starModel?.forks_count
                cell.watchCountLabel.text = starModel?.watchers_count
                return cell
            }
        default:
            let cell = tableView.dequeueReusableCell(withIdentifier: "CXNormalCell", for: indexPath) as! CXNormalCell
            cell.selectionStyle = .none
            cell.accessoryType = .disclosureIndicator
            if indexPath.section == 1 {
                cell.desLabel.text = "Owner"
            }
            if indexPath.section == 2 {
                cell.desLabel.text = ["Events","Issues","Readme"][indexPath.row]
            }
            if indexPath.section == 3{
                cell.desLabel.text = ["Commits","Source"][indexPath.row]
            }
            return cell
        }

        
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
    }
}
