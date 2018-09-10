//
//  EventMessage.swift
//  ManageYourStars
//
//  Created by 陈仕鹏 on 2018/9/10.
//  Copyright © 2018 csp. All rights reserved.
//

import Foundation
import HandyJSON
extension CXEventsController{
    public func getMessage(with event:UserEvent) -> String {
        switch event.type {
        case "PushEvent":
            return event.payload?.commits![0].message ?? ""
        //            break
        case "IssuesEvent":
            return event.payload?.issue?.title ?? ""
        //            break
        case "CreateEvent":
            return event.payload?.description ?? ""
        default:
            return ""
        }
    }
}

