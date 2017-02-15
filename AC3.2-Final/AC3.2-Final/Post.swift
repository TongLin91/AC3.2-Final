//
//  Post.swift
//  AC3.2-Final
//
//  Created by Tong Lin on 2/15/17.
//  Copyright © 2017 C4Q. All rights reserved.
//

import Foundation

class Post{
    let key: String
    let comment: String
    let userID: String
    
    init(key: String, comment: String, userID: String) {
        self.key = key
        self.comment = comment
        self.userID = userID
    }
    
    convenience init?(dict: NSDictionary, key: String) {
        guard let comment = dict["comment"] as? String,
            let userID = dict["userId"] as? String else { return nil }
        
        self.init(key: key, comment: comment, userID: userID)
    }
}
