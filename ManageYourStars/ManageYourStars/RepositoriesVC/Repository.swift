//
//  Repository.swift
//  ManageYourStars
//
//  Created by 陈仕鹏 on 2017/9/8.
//  Copyright © 2017年 csp. All rights reserved.
//

import Foundation
import UIKit
import HandyJSON
struct Repository: HandyJSON {
    
    var name:String?
    var userId:String?
    var full_name:String?
    var html_url:String?
    var repositoryDescription:String?
    var isFork:Bool?
    var credited_at:String?
    var homePage:String?
    var stargazers_count:Int?
    var language:String?
    var forks_count:Int?
    var user:CXUserModel?
    var mirror_url:String?
    var parentWithDict:String?
    
    
    
}
