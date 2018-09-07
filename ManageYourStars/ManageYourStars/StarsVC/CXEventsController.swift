//
//  CXEventsController.swift
//  ManageYourStars
//
//  Created by chenshipeng on 2018/9/5.
//  Copyright © 2018年 csp. All rights reserved.
//

import UIKit
import Alamofire
import SVProgressHUD
import Kingfisher
import SwiftDate
class CXEventsController: UITableViewController {

    var login:String?
    var userSvents = [UserEvent?]()
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.estimatedRowHeight = 200
        tableView.rowHeight = UITableViewAutomaticDimension
        self.tableView.register(UINib.init(nibName: "CXEventsCell", bundle: nil), forCellReuseIdentifier: "CXEventsCell")
        getData()
    }
    func getData(){
        guard let currentLogin = self.login  else {
            return
        }
        let url = "https://api.github.com/users/" + "\(String(describing: currentLogin))" + "/events"

        print("url is \(url)")

        SVProgressHUD.show()
        Alamofire.request(url, method: .get, parameters: nil).responseJSON(completionHandler: { (response) in

            if response.result.isSuccess {
                SVProgressHUD.dismiss()
                if let JSON = response.result.value {
                    print("JSON: \(JSON)")
                }
                if let array = response.result.value as? Array<Any> {
                    print("\(array.count)")
                    if let event = [UserEvent].deserialize(from: response.result.value as? NSArray){
                        self.userSvents.append(contentsOf: event)
                    }
                }
                self.tableView.reloadData()
            }else{
                SVProgressHUD.dismiss()
                SVProgressHUD.showError(withStatus: String(describing: response.result.value))
            }
        })
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
        
        return self.userSvents.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CXEventsCell", for: indexPath) as! CXEventsCell
        let event = userSvents[indexPath.row]
        cell.avatarImageView.kf.setImage(with: URL(string: event?.actor?.avatar_url ?? ""))
        cell.eventLabel.text = self.getActionWith(event: event!)
        cell.messageLabel.text = self.getMessage(with: event!)
        if let dateStr = event?.created_at,let date = dateStr.toDate()?.date {
            cell.timeLabel.text =  timeAgoSince(date)
        }

        return cell
    }
    func getActionWith(event:UserEvent)->String{
        switch event.type {
        case "PushEvent":
            var str = ""
            if let user = event.actor?.login {
                str += user
            }
            let action = " pushed to "
            str += action
            if let branch = event.payload?.ref?.split(separator: "/", maxSplits: Int.max, omittingEmptySubsequences: true).last {
                str += branch
            }
            if let location = event.repo?.name {
                str += " at " + location
            }
            
            return str
//            break
        case "IssuesEvent":
            var str = ""
            if let user = event.actor?.login{
                str += user
            }
            if let action = event.payload?.action {
                str += " " + action
            }
            if let IssueNumber = event.payload?.issue?.number{
                str += " " + "#" + String(IssueNumber)
            }
            if let location = event.repo?.name{
                str += " in " + location
            }
            
            return str
//            break
        default:
            return ""
        }
    }
    
    func getMessage(with event:UserEvent) -> String {
        switch event.type {
        case "PushEvent":
            return (event.payload?.commits![0].message)!
//            break
        case "IssuesEvent":
            return (event.payload?.issue?.title)!
//            break
        default:
            return ""
        }
    }
    

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
