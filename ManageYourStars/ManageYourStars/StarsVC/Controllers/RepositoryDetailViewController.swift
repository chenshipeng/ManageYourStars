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
import EZSwiftExtensions
class RepositoryDetailViewController: UIViewController {

    public var starModel:Repo?
    private var readme:Readme?
    var url:String?
    var starred = false
    private var tableView:UITableView = UITableView()
    
    var contributors = [CXUserModel?]()
    var forks = [StarredModel?]()
    var stargazers = [CXUserModel?]()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        getRepoInfo()
        

        
    }
    func getRepoInfo(){
        if let url = url
        {
            SVProgressHUD.show()
            Alamofire.request(url, method: .get, parameters: nil).responseJSON(completionHandler: { (response) in
                if response.result.isSuccess {
                    SVProgressHUD.dismiss()
                    if let array = response.result.value as? Dictionary<String, Any> {
                        if let repo = Repo.deserialize(from: array){
                            self.starModel = repo
                        }
                    }
                    self.setupUI()
                    self.tableView.reloadData()
                    self.getReadme()
                
                }else{
                    SVProgressHUD.dismiss()
                    SVProgressHUD.showError(withStatus: String(describing: response.result.value))
                    print("error is \(String(describing: response.result.error))")
                    
                }
            })
        }
    }
    func checkIfStaredRepo() {
        guard let currentLogin = self.starModel?.owner?.login,let name = starModel?.name ,let token=UserDefaults.standard.object(forKey: "access_token") as? String else {
            return
        }
        
        let url = "https://api.github.com/user/starred" + "/\(String(describing: currentLogin))" + "/\(name)" + "?access_token=\(token)"
        
        print("url is \(url)")
        
        SVProgressHUD.show()
        Alamofire.request(url, method: .get, parameters: nil).responseJSON(completionHandler: { (response) in
            
            
            
            if response.result.isSuccess {
                SVProgressHUD.dismiss()
                if response.response?.statusCode == 404 {
                    self.starred =  false
                    
                }
                if response.response?.statusCode == 204 {
                    self.starred =  true
                }
                if let JSON = response.result.value {
                    print("JSON: \(JSON)")
                }
//                if let array = response.result.value as? Array<Any> {
//                    print("\(array.count)")
//                    if let org = [Org].deserialize(from: response.result.value as? NSArray){
//                        self.orgArray.append(contentsOf: org)
//                    }
//                }
//                self.tableView.reloadData()
            }else{
                SVProgressHUD.dismiss()
                SVProgressHUD.showError(withStatus: String(describing: response.result.value))
                print("error is \(String(describing: response.result.error))")
                
            }
        })
    }
    func getReadme(){
        guard let currentLogin = starModel?.owner?.login,let name = starModel?.name else {
            return
        }
        
        let url = "https://api.github.com/repos" + "/\(String(describing: currentLogin))" + "/\(name)/readme"
        
        print("url is \(url)")
        
        SVProgressHUD.show()
        Alamofire.request(url, method: .get, parameters: nil).responseString(completionHandler: { (response) in
            
            
            
            if response.result.isSuccess {
                SVProgressHUD.dismiss()
                if let readme = Readme.deserialize(from: response.result.value){
                    self.readme = readme
                }
            }else{
                SVProgressHUD.dismiss()
                SVProgressHUD.showError(withStatus: String(describing: response.result.value))
                print("error is \(String(describing: response.result.error))")
                
            }
        })
    }
    func addRightItem(with starred:Bool) {
        let bar = UIBarButtonItem.init(title: "Star", style: .plain, target: self, action: #selector(starTheRepo))
        navigationItem.rightBarButtonItem = bar
    }
    @objc func starTheRepo(){
        
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
            return 1
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
                cell.starsBackView.addTapGesture { (tap) in
                    let vc = CXUserListController()
                    vc.action = self.starModel?.stargazers_url
                    self.navigationController?.pushViewController(vc, animated: true)
                }
                cell.forkCountLabel.text = starModel?.forks_count
                cell.forksBackView.addTapGesture { (tap) in
                    let vc = CXUserListController()
                    vc.action = self.starModel?.forks_url
                    vc.isFork = true
                    self.navigationController?.pushViewController(vc, animated: true)
                }
                cell.watchesBackView.addTapGesture { (tap) in
                    let vc = CXUserListController()
                    vc.action = self.starModel?.subscribers_url
                    self.navigationController?.pushViewController(vc, animated: true)
                }
                cell.watchCountLabel.text = starModel?.watchers_count
                return cell
            }
        default:
            let cell = tableView.dequeueReusableCell(withIdentifier: "CXNormalCell", for: indexPath) as! CXNormalCell
            cell.selectionStyle = .none
            cell.accessoryType = .disclosureIndicator
            if indexPath.section == 1 {
                cell.desLabel.text = "Owner"
                cell.desImageView.image = UIImage(named: "owner")
            }
            if indexPath.section == 2 {
                cell.desLabel.text = ["Events","Issues","Readme"][indexPath.row]
                cell.desImageView.image = UIImage(named: ["events","issue_icon","readme"][indexPath.row])
            }
            if indexPath.section == 3{
                cell.desLabel.text = ["Commits","Source"][indexPath.row]
                cell.desImageView.image = UIImage(named: ["commit","source"][indexPath.row])
            }
            return cell
        }

        
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.section == 1,indexPath.row == 0 {
            let vc = CXUserViewController()
            vc.login = starModel?.owner?.login
            vc.hidesBottomBarWhenPushed = true
            self.navigationController?.pushViewController(vc, animated: true)
        }
        if indexPath.section == 2,indexPath.row == 0 {
            let vc = CXRepoEventsListController()
            vc.starModel = starModel
            vc.hidesBottomBarWhenPushed = true
            self.navigationController?.pushViewController(vc, animated: true)
        }
        if indexPath.section == 2,indexPath.row == 1 {
            let vc = CXIssueListController()
            vc.starModel = starModel
            vc.hidesBottomBarWhenPushed = true
            self.navigationController?.pushViewController(vc, animated: true)
        }
        if indexPath.section == 2,indexPath.row == 2 {
            let vc = CXReadmeController()
            vc.url = readme?._links?.html
            navigationController?.pushViewController(vc, animated: true)
        }
        if indexPath.section == 3,indexPath.row == 0 {
            let vc = CXBranchListController()
            vc.starModel = starModel
            navigationController?.pushViewController(vc, animated: true)
        }
        
    }
}
