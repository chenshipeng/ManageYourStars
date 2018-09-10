//
//  PullRequest.swift
//  ManageYourStars
//
//  Created by 陈仕鹏 on 2018/9/10.
//  Copyright © 2018 csp. All rights reserved.
//

import UIKit
import HandyJSON
struct PullRequest: HandyJSON {
    var state: String?
    var review_comments: Int?
    var requested_reviewers: [Any]?
    var body: String?
    var closed_at: Any?
//    var _links: _links
    var locked: Bool?
    var diff_url: String?
    var patch_url: String?
    var assignees: [Any]?
    var milestone: Any?
    var statuses_url: String?
    var commits: Int?
    var id: Int?
    var review_comment_url: String?
    var merged: Bool?
//    var base: Base?
    var title: String?
    var comments_url: String?
    var url: String?
    var requested_teams: [Any]?
    var rebaseable: Any?
    var labels: [Any]?
//    var user: Org?
    var issue_url: String?
    var html_url: String?
    var updated_at: String?
    var deletions: Int?
    var merge_commit_sha: Any?
    var mergeable_state: String?
    var number: String?
    var mergeable: Any?
    var merged_at: Any?
    var author_association: String?
//    var head: Base?
    var commits_url: String?
    var additions: Int?
    var merged_by: Any?
    var created_at: String?
    var comments: Int?
    var maintainer_can_modify: Bool?
    var assignee: Any?
    var node_id: String?
    var changed_files: Int?
    var review_comments_url: String?
}
