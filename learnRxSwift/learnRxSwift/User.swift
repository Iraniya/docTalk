//
//  User.swift
//  learnRxSwift
//
//  Created by Shilpy Samaddar on 07/01/18.
//  Copyright © 2018 iraniya. All rights reserved.
//

import Foundation

struct User {
    let id: Int
    let login: String
    let avatar_url: String
    
    init?(object: [String: Any]) {
        guard let id = object["id"] as? Int,
            let login = object["login"] as? String,
            let avatar_url = object["avatar_url"] as? String else {
                return nil
        }
        self.id = id
        self.login = login
        self.avatar_url = avatar_url
    }
    
    init(_ id: Int, _ login: String, _ avatar_url: String) {
        self.id = id
        self.login = login
        self.avatar_url = avatar_url
    }
}



