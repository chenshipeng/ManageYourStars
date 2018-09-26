//
//  CXLanguageSelectController.swift
//  CXHub
//
//  Created by 陈仕鹏 on 2018/9/26.
//  Copyright © 2018 csp. All rights reserved.
//

import UIKit

class CXLanguageSelectController: UITableViewController {

    var titleArray = [String]()
    var languageBlock:(String) -> Void = {str in}
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Language"
        titleArray = ["all languages","javascript","java","php","ruby","python","css","cpp","c","objective-c","swift","shell","r","perl","lua","html","scala","go"]
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "languageCell")
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return titleArray.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "languageCell", for: indexPath)
        cell.textLabel?.text = titleArray[indexPath.row]

        return cell
    }
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        self.languageBlock(titleArray[indexPath.row])
        UserDefaults.standard.set(titleArray[indexPath.row], forKey: "language")
        navigationController?.popViewController(animated: true)
    }


}
