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
    func getRequest(urlString:String,params:[String:Any]?,success:@escaping(_ response:[String:AnyObject])->(),failure:@escaping(_ error:Error)->()) {
        
        Alamofire.request(urlString,method:.get,parameters:params).responseJSON{(response) in
        
            switch response.result{
                
            case .success( _):
                if let value = response.result.value as? [String:AnyObject] {
                    success(value)
                }
                
            case .failure(let error):
                failure(error)
            }
        }
    }
    
    func getRequestReturnString(urlString:String,params:[String:Any],success:@escaping(_ response:String)->(),failure:@escaping(_ error:Error)->()) {
        
        Alamofire.request(urlString,method:.get,parameters:params).responseJSON{(response) in
            
            switch response.result{
                
            case .success( _):
                if let value = response.result.value as? String {
                    success(value)
                }
                
            case .failure(let error):
                failure(error)
            }
        }
    }
    
    func postRequest(urlString:String,params:[String:AnyObject],success:@escaping(_ response:[String:AnyObject])->(),failure:@escaping(_ error:Error)->()) {
        Alamofire.request(urlString,method:.post,parameters:params).responseJSON { (response) in
            switch response.result{
            case .success:
                if let value = response.result.value as? [String:AnyObject]{
                    success(value)
                    let json = JSON(value)
                    print(json)
                }
            case .failure(let error):
                failure(error)
                print("error:\(error)")
            }
        }
    }
    
    func uploadImageRequest(urlString:String,params:[String:AnyObject],data:[Data],name:[String],success:@escaping(_ response:[String:AnyObject])->(),failure:@escaping(_ error:Error)->()) {
        
        let headers = ["content-type":"multipart/form-data"]
        Alamofire.upload(multipartFormData: { multipartFormData in
            
        }, to: urlString, encodingCompletion: {encodingResult in
        
            switch encodingResult{
            case .success(let upload,_,_):
                upload.responseJSON(completionHandler: { (response) in
                    print("response")
                })
            case .failure(let encodingError):
                print(encodingError)
            }
            
        })
    }
}
