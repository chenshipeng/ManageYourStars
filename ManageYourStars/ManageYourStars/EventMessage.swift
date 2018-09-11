//
//  EventMessage.swift
//  ManageYourStars
//
//  Created by 陈仕鹏 on 2018/9/10.
//  Copyright © 2018 csp. All rights reserved.
//

import Foundation
import HandyJSON
class EventMessage{
    public static func getMessage(with event:UserEvent) -> String {
        switch event.type {
        case "PushEvent":
            return event.payload?.commits![0].message ?? ""
        //            break
        case "IssuesEvent":
            return event.payload?.issue?.title ?? ""
        //            break
        case "CreateEvent":
            return event.payload?.description ?? ""
        case "CommitCommentEvent":
            return event.payload?.comment?.body ?? ""
        case "PullRequestEvent","PullRequestReviewCommentEvent":
            return event.payload?.pull_request?.body ?? ""
        default:
            return ""
        }
    }
}

