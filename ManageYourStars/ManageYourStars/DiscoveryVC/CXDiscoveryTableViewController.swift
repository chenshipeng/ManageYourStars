//
//  CXDiscoveryTableViewController.swift
//  ManageYourStars
//
//  Created by 陈仕鹏 on 2017/8/20.
//  Copyright © 2017年 csp. All rights reserved.
//

import UIKit
import BetterSegmentedControl
import SVProgressHUD
import Alamofire
import Kingfisher
import MJRefresh
class CXDiscoveryTableViewController: UITableViewController {
    var stars = [Trending?]()
    
    var page = 1
    var language = ""
    var isRefresh = false
    var type = "daily"
    override func viewDidLoad() {
        super.viewDidLoad()
        if UserDefaults.standard.object(forKey: "language") != nil{
            language = UserDefaults.standard.object(forKey: "language") as! String
        }

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
        let control = BetterSegmentedControl(
            frame: CGRect(x: 35.0, y: 40.0, width: 200.0, height: 30.0),
            segments: LabelSegment.segments(withTitles: ["Daily", "Weekly","Monthly"],
                                            normalFont: UIFont(name: "Avenir", size: 13.0)!,
                                            normalTextColor: .lightGray,
                                            selectedFont: UIFont(name: "Avenir", size: 13.0)!,
                                            selectedTextColor: .white),
            options:[.backgroundColor(.darkGray),
                     .indicatorViewBackgroundColor(UIColor(r: 160.0, g: 32.0, b: 24.0, a: 1.0)),
                     .cornerRadius(3.0),
                     .bouncesOnChange(false)])
        control.addTarget(self, action: #selector(CXDiscoveryTableViewController.controlValueChanged(control:)), for: .valueChanged)
        self.navigationItem.titleView = control
        
        self.tableView.rowHeight = UITableViewAutomaticDimension
        self.tableView.estimatedRowHeight = 200
        self.tableView.tableFooterView = UIView()
        self.refreshData(loadMore:false,type: "daily")
        
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Lanaguage", style: .plain, target: self, action: #selector(CXDiscoveryTableViewController.selectLanguage))

    }
    @objc func selectLanguage(){
        let vc = CXLanguageSelectController()
        vc.languageBlock = {str in
            self.language = str
            self.refreshData(loadMore:false,type: self.type)
        }
        vc.hidesBottomBarWhenPushed = true
        navigationController?.pushViewController(vc, animated: true)
    }
    @objc func controlValueChanged(control:BetterSegmentedControl){
        type = ["daily","weekly","monthly"][control.index.toInt]
        self.refreshData(loadMore: false, type: ["daily","weekly","monthly"][control.index.toInt])
    }
    func refreshData(loadMore:Bool,type:String){
        
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
            let url = "http://trending.codehub-app.com/v2/trending" + "?language=\(language)&since=\(type)"
            print("stared url is \(url)")
            isRefresh = true
            
            Alamofire.request(url, method: .get, parameters: nil).responseJSON(completionHandler: { (response) in
                
                if response.result.isSuccess {
                    if !loadMore {
                        self.stars.removeAll()
                    }
                    SVProgressHUD.dismiss()
                    if let array = response.result.value as? Array<Any> {
                        print("\(array.count)")
                        if let arr = [Trending].deserialize(from: response.result.value as? Array<Any>){
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
        let cell = tableView.dequeueReusableCell(withIdentifier: "trendingCell", for: indexPath) as! CXTrendingListCell
        let model:Trending = self.stars[indexPath.row]!
        cell.trendingModel = model
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let vc: RepositoryDetailViewController = RepositoryDetailViewController()
        let model:Trending = self.stars[indexPath.row]!
        vc.url = model.url
        vc.hidesBottomBarWhenPushed = true
        self.navigationController?.pushViewController(vc, animated: true)
        
    }
    
    
    
    

}
