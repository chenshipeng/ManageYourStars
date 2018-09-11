//
//  OrgInfoTableViewController.swift
//  ManageYourStars
//
//  Created by 陈仕鹏 on 2018/9/11.
//  Copyright © 2018 csp. All rights reserved.
//

import UIKit

class OrgInfoTableViewController: UITableViewController {
    
    var org:Org?
    override func viewDidLoad() {
        super.viewDidLoad()
        title = org?.login ?? ""
        tableView.estimatedRowHeight = 200
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.tableFooterView = UIView()
        tableView.register(UINib(nibName: "CXUserInfoCell", bundle: nil), forCellReuseIdentifier: "CXUserInfoCell")
        tableView.register(UINib.init(nibName: "CXNormalCell", bundle: nil), forCellReuseIdentifier: "CXNormalCell")
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        
        return 4
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 1 || section == 2 {
            return 2
        }
        return 1
    }
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if section > 0 {
            return 10
        }
        return 0.0
    }
   override  func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        if section > 0 {
            let header = UIView(frame: CGRect(x: 0, y: 0, width: self.view.bounds.size.width, height: 10))
            header.backgroundColor = UIColor(red: 231.0/255.0, green: 231.0/255.0, blue: 231.0/255.0, alpha: 0.5)
            return header
        }
        return nil
    }
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "CXUserInfoCell", for: indexPath) as! CXUserInfoCell
            cell.selectionStyle = .none
            cell.accessoryType = .none
            cell.avatarImageView.kf.setImage(with:  URL(string:(org?.avatar_url)!))
            cell.userNameLabel.text = org?.login ?? ""
            cell.repoDesLabel.text = org?.description ?? ""
            return cell

        }else{
            let cell = tableView.dequeueReusableCell(withIdentifier: "CXNormalCell", for: indexPath) as! CXNormalCell
            cell.selectionStyle = .none
            cell.accessoryType = .disclosureIndicator
            cell.desImageView.image = UIImage(named: [["member","team"],["events","followers"],["repository"]][indexPath.section - 1][indexPath.row])
            cell.desLabel.text = [["Members","Teams"],["Events","Followers"],["Repositories"]][indexPath.section - 1][indexPath.row]
            return cell
        }
        
    }
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let vc = CXMemberListController()
        vc.org = org
        navigationController?.pushViewController(vc, animated: true)
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
