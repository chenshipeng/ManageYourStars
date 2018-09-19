//
//  CXLoginViewController.swift
//  ManageYourStars
//
//  Created by 陈仕鹏 on 2017/8/19.
//  Copyright © 2017年 csp. All rights reserved.
//

import UIKit
import Alamofire
import SVProgressHUD
import SnapKit
class CXLoginViewController: UIViewController {

    var autoPop = true
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Login"
        
        
        let url = "https://github.com/login/oauth/authorize?client_id=d67855104c8fb56c68e0&state=1995&redirect_uri=https://github.com/chenshipeng&scpoe=user,public_repo"
        let webView = UIWebView()
        webView.delegate = self
        view.addSubview(webView)
        webView.snp.makeConstraints { (make) in
            make.edges.equalTo(view)
        }
        webView.loadRequest(URLRequest(url: URL(string: url)!))
    }
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        URLCache.shared.removeAllCachedResponses()
        URLCache.shared.diskCapacity = 0
        URLCache.shared.memoryCapacity = 0
        
        if let cookies =  HTTPCookieStorage.shared.cookies{
            for cookie in cookies {
                HTTPCookieStorage.shared.deleteCookie(cookie)
            }
        }
        
    }
    @objc func getUserInfo(){
        //进入个人详情页面
        let url = "https://api.github.com/user"
        let params = ["access_token":UserDefaults.standard.object(forKey: "access_token")!]
        
        SVProgressHUD.show()
        Alamofire.request(url, method: .get, parameters: params).responseString(completionHandler: { (response) in
            
            if response.result.isSuccess {
                SVProgressHUD.dismiss()
                if let arr = CXUserModel.deserialize(from: response.result.value){
                    if let login = arr.login{
                        UserDefaults.standard.set(login, forKey: "currentLogin")
                        UserDefaults.standard.set(arr.avatar_url, forKey: "avatar_url")
                        if self.autoPop {
                            NotificationCenter.default.post(name: Notification.Name(rawValue:"refreshMoreVC"), object: nil)
                            self.navigationController?.popViewController(animated: true)
                        }else{
                            let application = UIApplication.shared.delegate as! AppDelegate
                            application.setupRootVC()
                        }
                        
                    }
                }
                print("response is \(String(describing: response.result.value))")
            }else{
                SVProgressHUD.dismiss()
                SVProgressHUD.showError(withStatus: String(describing: response.result.value))
            }
        })
    }
    func loginWithCode(code:String) {
        
        let url = "https://github.com/login/oauth/access_token"
        let params = ["client_id":"d67855104c8fb56c68e0",
                      "client_secret":"8ea0db7827776e711f65e6520f59b4a4c080af6d",
                      "redirect_uri":"https://github.com/chenshipeng",
                      "code":code,"state":"1"]
        
        SVProgressHUD.show()
        Alamofire.request(url, method: .post, parameters: params).responseString { (response) in
            print(response)
            if (response.value) != nil {
                SVProgressHUD.dismiss()
                let string = response.value
                print("response is \(String(describing: response.result.value))")
                if let str = string{
                    for i in 0..<str.count - 13 {
                        if (str as NSString).substring(with: NSMakeRange(i, 13)) == "access_token=" {
                            let token = (str as NSString).substring(with: NSMakeRange(i + 13, 40))
                            print("token is \(token)")
                            UserDefaults.standard.set(token, forKey: "access_token")
                            self.getUserInfo()
                            
                            
                            return
                        }
                    }
                }
                
            }else{
                SVProgressHUD.dismiss()
                SVProgressHUD.showError(withStatus: "登录失败!")
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
        SVProgressHUD.show()
    }
    func webViewDidFinishLoad(_ webView: UIWebView) {
        SVProgressHUD.dismiss()

        print("web view did finished load")
        if let url = webView.request?.url?.absoluteString {
            
            print("url is \(url)")
            for i in 0..<url.count - 5 {
                
                
                
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
        SVProgressHUD.dismiss()
    }
    func webView(_ webView: UIWebView, shouldStartLoadWith request: URLRequest, navigationType: UIWebViewNavigationType) -> Bool {
        return true
    }
}
