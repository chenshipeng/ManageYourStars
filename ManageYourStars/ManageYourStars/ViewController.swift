//
//  ViewController.swift
//  ManageYourStars
//
//  Created by 陈仕鹏 on 2017/8/9.
//  Copyright © 2017年 csp. All rights reserved.
//

import UIKit
import Alamofire
class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        let params = ["client_id":"d67855104c8fb56c68e0",
                        "redirect_uri":"https://github.com/chenshipeng",
                        "scope":"user,public_repo"]
        NetworkRequest.sharedInstance.getRequest(urlString: "https://github.com/login/OAuth/authorize", params: params, success: { response in
            print(response)
        }) { error in
            print(error.localizedDescription)
        }
        
        Alamofire.request("https://github.com/login/oauth/authorize", method: .get, parameters: params).responseString { (strin) in
            print(strin)
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

