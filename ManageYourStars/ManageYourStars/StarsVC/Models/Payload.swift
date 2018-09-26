//
//  Payload.swift
//  ManageYourStars
//
//  Created by 陈仕鹏 on 06/09/18.
//  Copyright © 2017 csp. All rights reserved.
//
//  -- auto-generated by JSON2Swift --
//

import Foundation
import HandyJSON


struct Payload: HandyJSON {
    var push_id: Int?
    var commits: [Commit]?
    var size: Int?
    var distinct_size: Int?
    var ref: String?
    var before: String?
    var head: String?
    var action:String?
    var issue:Issue?
    var forkee:Forkee?
    var description:String?
    var comment:Comment?
    var pull_request:PullRequest?
    var member:Member?

}



