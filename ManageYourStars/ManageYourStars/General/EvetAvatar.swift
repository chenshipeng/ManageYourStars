//
//  EvetAvatar.swift
//  ManageYourStars
//
//  Created by 陈仕鹏 on 2018/9/10.
//  Copyright © 2018 csp. All rights reserved.
//

import Foundation
import UIKit
class EventAvatar{
    public static func image(for event:UserEvent) -> UIImage?{
        switch event.type {
        case "PushEvent":
            return UIImage(named: "commit")
        case "IssuesEvent":
            return UIImage(named: "issue_icon")
        case "CommitCommentEvent","IssueCommentEvent":
            return UIImage(named: "comment")
        case "ForkEvent":
            return UIImage(named: "fork")
        case "WatchEvent":
            return UIImage(named: "watch")
        case "CreateEvent":
            return UIImage(named: "create")
        case "PullRequestEvent":
            return UIImage(named: "pull-request")
        case "MemberEvent":
            return UIImage(named: "team")
        default:
            return nil
        }
    }
}
