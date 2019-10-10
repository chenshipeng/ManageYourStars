//
//  CXPreLoginController.swift
//  ManageYourStars
//
//  Created by 陈仕鹏 on 2018/9/12.
//  Copyright © 2018 csp. All rights reserved.
//

import UIKit
import SVProgressHUD
import Alamofire
class CXPreLoginController: UIViewController {

    @IBOutlet weak var usernameTF: UITextField!
    @IBOutlet weak var passwordTF: UITextField!
    @IBOutlet weak var loginBtn: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()
        usernameTF.delegate = self
        passwordTF.delegate = self
        loginBtn.layer.cornerRadius = 5
    }
    @IBAction func loginBtnClicked(_ sender: UIButton) {
        if let username = usernameTF.text,username.length > 0,let password = passwordTF.text,password.length > 0 {
            var headers:HTTPHeaders = [:]
            if let authorizationHeader = Request.authorizationHeader(user: username, password: password){
                headers[authorizationHeader.key] = authorizationHeader.value
                headers["Content-Type"] = "application/json"
                loginWithCode(headers)
            }
            
//
//            if let usernameAndPassword = "\(username):\(password)".data(using: .utf8)?.base64EncodedString(){
//
//                let basicCode = "Basic \(usernameAndPassword)"
//                loginWithCode(code: headers)
//            }
        }
//        let loginVC = CXLoginViewController()
//        loginVC.autoPop = false
//        loginVC.hidesBottomBarWhenPushed = true
//        self.present(loginVC, animated: true, completion: {
//
//        })
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
                        let application = UIApplication.shared.delegate as! AppDelegate
                        application.setupRootVC()
                        
                    }
                }
                print("response is \(String(describing: response.result.value))")
            }else{
                SVProgressHUD.dismiss()
                SVProgressHUD.showError(withStatus: String(describing: response.result.value))
            }
        })
    }
    func loginWithCode(_ headers:HTTPHeaders) {
        
        let url = "https://api.github.com/authorizations"
        let params = ["client_id":"d67855104c8fb56c68e0",
                      "client_secret":"8ea0db7827776e711f65e6520f59b4a4c080af6d",
                      "redirect_uri":"https://github.com/chenshipeng/ManageYourStars",
                      "scopes": ["user", "repo", "gist", "notifications"],
            "note": "admin_script"] as [String : Any]
        debugPrint(params.description)
        SVProgressHUD.show()
        Alamofire.request(url, method: .post, parameters: params,encoding: JSONEncoding.default,headers: headers).responseString { (response) in
            print(response)
            if (response.value) != nil {
                SVProgressHUD.dismiss()
                let string = response.value
                if let jsonData:Data = string?.data(using: .utf8),let dict = try? JSONSerialization.jsonObject(with: jsonData, options: .mutableContainers){
                    let dic = dict as! Dictionary<String, Any>
                    let token = dic["token"] as! String
                    debugPrint(token)
                    UserDefaults.standard.set(token, forKey: "access_token")
                    self.getUserInfo()
                }
                
            }else{
                SVProgressHUD.dismiss()
                SVProgressHUD.showError(withStatus: "Login failed!")
            }
            
        }
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}
extension CXPreLoginController:UITextFieldDelegate{
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == usernameTF {
            passwordTF.becomeFirstResponder()
        }else{
            if let username = usernameTF.text,username.length > 0,let password = passwordTF.text,password.length > 0{
                var headers:HTTPHeaders = [:]
                if let authorizationHeader = Request.authorizationHeader(user: username, password: password){
                    headers[authorizationHeader.key] = authorizationHeader.value
                    loginWithCode(headers)
                }
            }
        }
        return true
    }
}
