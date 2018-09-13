//
//  Verification.swift
//  ManageYourStars
//
//  Created by 陈仕鹏 on 2018/9/13.
//  Copyright © 2018 csp. All rights reserved.
//

import UIKit
import HandyJSON
struct Verification: HandyJSON {
    var verified: Bool?
    var reason: String?
    var payload: Any?
    var signature: Any?
}
