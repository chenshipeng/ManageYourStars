//
//  NetworkRequest.swift
//  ManageYourStars
//
//  Created by 陈仕鹏 on 2017/8/9.
//  Copyright © 2017年 csp. All rights reserved.
//

import Foundation
import UIKit
import Alamofire
import SwiftyJSON
private let NetworkRequestShareInstance =  NetworkRequest()
class NetworkRequest {
    
    class var sharedInstance:NetworkRequest{
        return NetworkRequestShareInstance
    }
}
