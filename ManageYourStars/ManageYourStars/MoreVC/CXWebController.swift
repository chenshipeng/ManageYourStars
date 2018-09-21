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
            if #available(iOS 11.0, *){
                make.top.equalTo(self.view.safeAreaLayoutGuide.snp.top)
                make.left.equalTo(self.view.safeAreaLayoutGuide.snp.left)
                make.right.equalTo(self.view.safeAreaLayoutGuide.snp.right)
                make.bottom.equalTo(self.view.safeAreaLayoutGuide.snp.bottom).offset(34)

            }else{
                make.edges.equalTo(view)
            }
        }
        if #available(iOS 11.0, *) {
            webView.scrollView.contentInsetAdjustmentBehavior = .never
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
