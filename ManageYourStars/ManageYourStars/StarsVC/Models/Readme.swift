//
//  Readme.swift
//  ManageYourStars
//
//  Created by 陈仕鹏 on 2018/9/13.
//  Copyright © 2018 csp. All rights reserved.
//

import UIKit
import HandyJSON
struct Readme: HandyJSON {
    var content: String?
    var name: String?
    var path: String?
    var download_url: String?
    var encoding: String?
    var html_url: String?
    var _links: Links?
    var git_url: String?
    var size: Int?
    var sha: String?
    var type: String?
    var url: String?
}
