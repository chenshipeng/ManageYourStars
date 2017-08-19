//
//  CXLoginViewController.swift
//  ManageYourStars
//
//  Created by 陈仕鹏 on 2017/8/19.
//  Copyright © 2017年 csp. All rights reserved.
//

import UIKit
import Alamofire

class CXLoginViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        let url = "https://github.com/login/oauth/authorize?client_id=d67855104c8fb56c68e0&redirect_uri=https://github.com/chenshipeng&scpoe=user,public_repo"
        let webView = UIWebView(frame: CGRect(x: 0, y: 0, width: self.view.frame.size.width, height: self.view.frame.size.height))
        webView.delegate = self
        view.addSubview(webView)
        webView.loadRequest(URLRequest(url: URL(string: url)!))
    }
    func loginWithCode(code:String) {
        
        let url = "https://github.com/login/oauth/access_token"
        let params = ["client_id":"d67855104c8fb56c68e0",
                      "client_secret":"8ea0db7827776e711f65e6520f59b4a4c080af6d",
                      "redirect_uri":"https://github.com/chenshipeng",
                      "code":code]
        
        
        Alamofire.request(url, method: .get, parameters: params).responseString { (response) in
            print(response)
            if (response.value) != nil {
                let string = response.value
                if let str = string{
                    for i in 0..<str.characters.count - 13 {
                        if (str as NSString).substring(with: NSMakeRange(i, 13)) == "access_token=" {
                            let token = (str as NSString).substring(with: NSMakeRange(i + 13, 40))
                            print("token is \(token)")
                            UserDefaults.standard.set(token, forKey: "access_token")
                            self.navigationController?.popViewController(animated: true)
                            return
                        }
                    }
                }
                
            }
            
        }
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
extension CXLoginViewController:UIWebViewDelegate{
    func webViewDidStartLoad(_ webView: UIWebView) {
        print("web view did start load")
    }
    func webViewDidFinishLoad(_ webView: UIWebView) {
        print("web view did finished load")
        if let url = webView.request?.url?.absoluteString {
            
            print("url is \(url)")
            for i in 0..<url.characters.count - 5 {
                
                
                
                if (url as NSString).substring(with: NSMakeRange(i, 5)) == "code=" {
                    print("url is \((url as NSString).substring(with: NSMakeRange(i+5, 20)))")
                    let code = (url as NSString).substring(with: NSMakeRange(i+5, 20))
                    loginWithCode(code: code)
                }
            }
        }
    }
    func webView(_ webView: UIWebView, didFailLoadWithError error: Error) {
        print("web view did fail to load")
    }
    func webView(_ webView: UIWebView, shouldStartLoadWith request: URLRequest, navigationType: UIWebViewNavigationType) -> Bool {
        return true
    }
}
