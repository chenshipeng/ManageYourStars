//
//  EventAction.swift
//  ManageYourStars
//
//  Created by 陈仕鹏 on 2018/9/10.
//  Copyright © 2018 csp. All rights reserved.
//

import Foundation
import HandyJSON
extension CXEventsController{
    public func getActionWith(event:UserEvent)->String{
        switch event.type {
        case "PushEvent":
            var str = ""
            if let user = event.actor?.login {
                str += user
            }
            let action = " pushed to "
            str += action
            if let branch = event.payload?.ref?.split(separator: "/", maxSplits: Int.max, omittingEmptySubsequences: true).last {
                str += branch
            }
            if let location = event.repo?.name {
                str += " at " + location
            }
            
            return str
        //            break
        case "IssuesEvent":
            var str = ""
            if let user = event.actor?.login{
                str += user
            }
            if let action = event.payload?.action {
                str += " " + action
            }
            if let IssueNumber = event.payload?.issue?.number{
                str += " " + "#" + String(IssueNumber)
            }
            if let location = event.repo?.name{
                str += " in " + location
            }
            
            return str
        case "IssueCommentEvent":
            var str = ""
            if let user = event.actor?.login{
                str += user
            }
            let action = " commented on issue "
            str += action
            if let IssueNumber = event.payload?.issue?.number{
                str += " " + "#" + String(IssueNumber)
            }
            if let location = event.repo?.name{
                str += " in " + location
            }
            
            return str
        case "WatchEvent":
            var str = ""
            if let user = event.actor?.login{
                str += user
            }
            if let action = event.payload?.action {
                str += " " + action
            }
            if let location = event.repo?.name {
                str += " " + location
            }
            
            return str
        case "ForkEvent":
            var str = ""
            if let user = event.actor?.login{
                str += user
            }
            let action = " forked "
            str += action
            if let source = event.repo?.name {
                str += " " + source
            }
            if let location = event.payload?.forkee?.full_name {
                str += " to " + location
            }
            
            return str
        case "CreateEvent":
            var str = ""
            if let user = event.actor?.login{
                str += user
            }
            let action = " crate "
            str += action
            if let source = event.repo?.name {
                str += " " + source
            }
            
            return str
        default:
            return ""
        }
    }
    

}
