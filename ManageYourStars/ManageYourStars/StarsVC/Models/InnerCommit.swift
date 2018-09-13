//
//  InnerCommit.swift
//  ManageYourStars
//
//  Created by 陈仕鹏 on 2018/9/13.
//  Copyright © 2018 csp. All rights reserved.
//

import UIKit
import HandyJSON
struct InnerCommit: HandyJSON {
    var message: String?
    var author: Author?
    var distinct: Bool?
    var url: String?
    var sha: String?
    var comment_count: Int?
    var tree: Tree?
    var committer: Committer?
    var verification: Verification?
}
