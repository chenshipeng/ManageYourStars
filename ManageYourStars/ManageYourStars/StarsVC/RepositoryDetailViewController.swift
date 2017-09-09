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
class RepositoryDetailViewController: UIViewController {

    var starModel:StarredModel?
    
    var selectedIndex = 0
    
    var page1 = 1
    var isRefresh1 = false
    
    var page2 = 1
    var isRefresh2 = false
    
    var page3 = 1
    var isRefresh3 = false

    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var avatarImageView: UIImageView!
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var contributeCountLabel: UILabel!
    @IBOutlet weak var contributeDesLabel: UILabel!
    @IBOutlet weak var forksCountLabel: UILabel!
    @IBOutlet weak var forksDesLabel: UILabel!
    @IBOutlet weak var starsCountLabel: UILabel!
    @IBOutlet weak var starsDesLabel: UILabel!
    
    var contributors = [CXUserModel?]()
    var forks = [StarredModel?]()
    var stargazers = [CXUserModel?]()

    override func viewDidLoad() {
        super.viewDidLoad()

        setupUI()
        
        self.tableView.mj_header = MJRefreshNormalHeader(refreshingBlock: {
            self.refreshData(loadMore:false)
        })
        self.tableView.mj_footer = MJRefreshAutoNormalFooter(refreshingBlock: {
            self.refreshData(loadMore:true)
        })
        if UserDefaults.standard.object(forKey: "access_token") != nil {
            self.tableView.mj_header.beginRefreshing()
            
        }
        
        
        
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(false, animated: true)
    }
    func refreshData(loadMore:Bool) {
        switch selectedIndex {
        case 0:
            if loadMore {
                getContributors(loadMore: true)

            }else{
                getContributors(loadMore: false)

            }
        case 1:
            if loadMore {
                getForks(loadMore: true)
                
            }else{
                getForks(loadMore: false)
                
            }
        case 2:
            if loadMore {
                getStargazers(loadMore: true)
                
            }else{
                getStargazers(loadMore: false)
                
            }
        default:
            if loadMore {
                getContributors(loadMore: true)
                
            }else{
                getContributors(loadMore: false)
                
            }
        }
    }
    
    func setupUI(){
        
        
        self.title = self.starModel?.full_name
        self.tableView.delegate = self
        self.tableView.dataSource = self
        self.tableView.estimatedRowHeight = 120
        self.tableView.rowHeight = UITableViewAutomaticDimension
        
        
        self.avatarImageView.layer.cornerRadius = 22.5
        self.avatarImageView.layer.masksToBounds = true
        
        self.nameLabel.text = self.starModel?.full_name
        self.timeLabel.text = self.starModel?.created_at
        self.descriptionLabel.text = self.starModel?.description
        self.avatarImageView.kf.setImage(with: URL(string:(self.starModel?.owner?.avatar_url)!))
        
        self.forksCountLabel.text = self.starModel?.forks_count
        self.starsCountLabel.text = self.starModel?.stargazers_count
    }
    func getContributors(loadMore:Bool) {
        //进入个人详情页面
        guard let name = self.starModel?.owner?.login  else {
            return
        }
        
        guard let repo = self.starModel?.name  else {
            return
        }
        
        if isRefresh1 {
            return
        }
        
        if loadMore {
            page1 = page1 + 1
        }else{
            page1 = 1
        }
        
        let url = "https://api.github.com/repos/" + "\(String(describing: name))/" + "\(String(describing: repo))/contributors" + "?page=\(page1)"
        
        print("url is \(url)")
        
        SVProgressHUD.show()
        Alamofire.request(url, method: .get, parameters: nil).responseJSON(completionHandler: { (response) in
            self.tableView.mj_header.endRefreshing()
            self.tableView.mj_footer.endRefreshing()
            if response.result.isSuccess {
                SVProgressHUD.dismiss()
                if !loadMore {
                    self.contributors.removeAll()
                }
                if let arr = [CXUserModel].deserialize(from: response.result.value as? NSArray){
                    
                    self.contributors.append(contentsOf:arr)
                }
                self.tableView.reloadData()
                print("response is \(String(describing: response.result.value))")
            }else{
                
                if loadMore {
                    self.page1 = self.page1 - 1
                }
                SVProgressHUD.dismiss()
                SVProgressHUD.showError(withStatus: String(describing: response.result.value))
            }
        })
    }
    func getForks(loadMore:Bool){
        //进入个人详情页面
        guard let name = self.starModel?.owner?.login  else {
            return
        }
        
        guard let repo = self.starModel?.name  else {
            return
        }
        if isRefresh2 {
            return
        }
        
        if loadMore {
            page2 = page2 + 1
        }else{
            page2 = 1
        }
        let url = "https://api.github.com/repos/" + "\(String(describing: name))/" + "\(String(describing: repo))/forks" + "?page=\(page2)"
        
        print("url is \(url)")
        
        SVProgressHUD.show()
        Alamofire.request(url, method: .get, parameters: nil).responseJSON(completionHandler: { (response) in
            self.tableView.mj_header.endRefreshing()
            self.tableView.mj_footer.endRefreshing()
            if response.result.isSuccess {
                SVProgressHUD.dismiss()
                if !loadMore {
                    self.forks.removeAll()
                }
                if let arr = [StarredModel].deserialize(from: response.result.value as? NSArray){

                    self.forks.append(contentsOf:arr)
                }
                self.tableView.reloadData()
                print("response is \(String(describing: response.result.value))")
            }else{
                
                if loadMore {
                    self.page2 = self.page2 - 1
                }
                SVProgressHUD.dismiss()
                SVProgressHUD.showError(withStatus: String(describing: response.result.value))
            }
        })
    }
    func getStargazers(loadMore:Bool) {
        //进入个人详情页面
        guard let name = self.starModel?.owner?.login  else {
            return
        }
        
        guard let repo = self.starModel?.name  else {
            return
        }
        if isRefresh3 {
            return
        }
        
        if loadMore {
            page3 = page3 + 1
        }else{
            page3 = 1
        }
        let url = "https://api.github.com/repos/" + "\(String(describing: name))/" + "\(String(describing: repo))/stargazers" + "?page=\(page3)"
        
        print("url is \(url)")
        
        SVProgressHUD.show()
        Alamofire.request(url, method: .get, parameters: nil).responseJSON(completionHandler: { (response) in
            self.tableView.mj_header.endRefreshing()
            self.tableView.mj_footer.endRefreshing()
            if response.result.isSuccess {
                SVProgressHUD.dismiss()
                if !loadMore {
                    self.stargazers.removeAll()
                }
                if let arr = [CXUserModel].deserialize(from: response.result.value as? NSArray){
                    
                    self.stargazers.append(contentsOf:arr)
                }
                self.tableView.reloadData()
                print("response is \(String(describing: response.result.value))")
            }else{
                
                if loadMore {
                    self.page3 = self.page3 - 1
                }
                SVProgressHUD.dismiss()
                SVProgressHUD.showError(withStatus: String(describing: response.result.value))
            }
        })
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func firstBtnClicked(_ sender: Any) {
        
        selectedIndex = 0
        
        contributeCountLabel.textColor = UIColor(red: 160.0/255, green: 32/255.0, blue: 24/255.0, alpha: 1.0)
        contributeDesLabel.textColor = UIColor(red: 160.0/255, green: 32/255.0, blue: 24/255.0, alpha: 1.0)
        
        forksCountLabel.textColor = UIColor.black
        forksDesLabel.textColor = UIColor.black
        starsDesLabel.textColor = UIColor.black
        starsCountLabel.textColor = UIColor.black
        
        tableView.reloadData()
        
    }
    
    @IBAction func secondBtnClicked(_ sender: Any) {
        if forks.count == 0 {
            getForks(loadMore: false)
        }
        
        selectedIndex = 1
        forksCountLabel.textColor = UIColor(red: 160.0/255, green: 32/255.0, blue: 24/255.0, alpha: 1.0)
        forksDesLabel.textColor = UIColor(red: 160.0/255, green: 32/255.0, blue: 24/255.0, alpha: 1.0)
        
        contributeCountLabel.textColor = UIColor.black
        contributeDesLabel.textColor = UIColor.black
        starsDesLabel.textColor = UIColor.black
        starsCountLabel.textColor = UIColor.black
        tableView.reloadData()
    }
    
    @IBAction func thirdBtnClicked(_ sender: Any) {
        if stargazers.count == 0 {
            getStargazers(loadMore: false)
        }
        selectedIndex = 2
        starsDesLabel.textColor = UIColor(red: 160.0/255, green: 32/255.0, blue: 24/255.0, alpha: 1.0)
        starsCountLabel.textColor = UIColor(red: 160.0/255, green: 32/255.0, blue: 24/255.0, alpha: 1.0)
        
        forksCountLabel.textColor = UIColor.black
        forksDesLabel.textColor = UIColor.black
        contributeCountLabel.textColor = UIColor.black
        contributeDesLabel.textColor = UIColor.black
        tableView.reloadData()
    }
    
    

}

extension RepositoryDetailViewController:UITableViewDelegate,UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch selectedIndex {
        case 0:
            return contributors.count
        case 1:
            return forks.count
        case 2:
            return stargazers.count
        default:
            return contributors.count
        }
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        self.tableView.register(UINib.init(nibName: "FollowCell", bundle: nil), forCellReuseIdentifier: "FollowCell")
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "FollowCell", for: indexPath) as! FollowCell
        
        
        let user:CXUserModel?
        let fork:StarredModel?
        switch selectedIndex {
        case 0:
            user = contributors[indexPath.row]
            cell.nameLabel.text = user?.login
            if let url = user?.avatar_url {
                cell.avatarImage.kf.setImage(with: URL(string:(url)))
                
            }
        case 1:
            fork = forks[indexPath.row]
            cell.nameLabel.text = fork?.owner?.login
            if let url = fork?.owner?.avatar_url {
                cell.avatarImage.kf.setImage(with: URL(string:(url)))
                
            }
        case 2:
            user = stargazers[indexPath.row]
            cell.nameLabel.text = user?.login
            if let url = user?.avatar_url {
                cell.avatarImage.kf.setImage(with: URL(string:(url)))
                
            }
        default:
            user = contributors[indexPath.row]

        }
        
        
        return cell
        
        
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let vc: CXUserViewController = self.storyboard?.instantiateViewController(withIdentifier: "CXUserViewController") as! CXUserViewController
        let user:CXUserModel?
        let fork:StarredModel?

        switch selectedIndex {
        case 0:
            user = contributors[indexPath.row]
            vc.avatar_url = user?.avatar_url
            vc.login = user?.login
            self.navigationController?.pushViewController(vc, animated: true)
        case 1:
            fork = forks[indexPath.row]
            vc.avatar_url = fork?.owner?.avatar_url
            vc.login = fork?.owner?.login
            self.navigationController?.pushViewController(vc, animated: true)
        case 2:
            user = stargazers[indexPath.row]
            vc.avatar_url = user?.avatar_url
            vc.login = user?.login
            self.navigationController?.pushViewController(vc, animated: true)
        default:
            user = contributors[indexPath.row]
            vc.avatar_url = user?.avatar_url
            vc.login = user?.login
            self.navigationController?.pushViewController(vc, animated: true)
        }
        
        
    }
}
