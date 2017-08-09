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

extension NetworkRequest{
    func getRequest(urlString:String,params:[String:Any],success:@escaping(_ response:[String:AnyObject])->(),failure:@escaping(_ error:Error)->()) {
        
    }
}
