//
//  CXWebController.swift
//  CXHub
//
//  Created by 陈仕鹏 on 2018/9/19.
//  Copyright © 2018 csp. All rights reserved.
//

import UIKit
import SnapKit
import SVProgressHUD
class CXWebController: UIViewController {
    
    var url:String?
    var webView = UIWebView()
    override func viewDidLoad() {
        super.viewDidLoad()
        webView.delegate = self
        view.addSubview(webView)
        webView.snp.makeConstraints { (make) in
            make.edges.equalTo(view)
        }
        if let url = url {
            webView.loadRequest(URLRequest(url: URL(string: url)!))
        }
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
extension CXWebController:UIWebViewDelegate{
    func webViewDidStartLoad(_ webView: UIWebView) {
        print("web view did start load")
        SVProgressHUD.show()
    }
    func webViewDidFinishLoad(_ webView: UIWebView) {
        SVProgressHUD.dismiss()
    }
    func webView(_ webView: UIWebView, didFailLoadWithError error: Error) {
        print("web view did fail to load")
        SVProgressHUD.dismiss()
    }
    func webView(_ webView: UIWebView, shouldStartLoadWith request: URLRequest, navigationType: UIWebViewNavigationType) -> Bool {
        return true
    }
}
