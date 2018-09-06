//
//  User.swift
//  ManageYourStars
//
//  Created by 陈仕鹏 on 2018/9/6.
//  Copyright © 2018 csp. All rights reserved.
//

import UIKit
import HandyJSON
struct User: HandyJSON {
    var login: String?
    var avatar_url: String?
    var id: Int?
    var url: String?
    var gravatar_id: String?
}
