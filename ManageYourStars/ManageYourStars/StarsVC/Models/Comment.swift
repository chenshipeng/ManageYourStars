//
//  Comment.swift
//  ManageYourStars
//
//  Created by 陈仕鹏 on 2018/9/10.
//  Copyright © 2018 csp. All rights reserved.
//

import UIKit
import HandyJSON
struct Comment: HandyJSON {
    var user: User?
    var updated_at: String?
    var html_url: String?
    var body: String?
    var author_association: String?
    var line: Int?
    var position: Int?
    var commit_id: String?
    var path: String?
    var id: Int?
    var created_at: String?
    var node_id: String?
    var url: String?
}
