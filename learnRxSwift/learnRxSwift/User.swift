//
//  User.swift
//  learnRxSwift
//
//  Created by Shilpy Samaddar on 07/01/18.
//  Copyright © 2018 iraniya. All rights reserved.
//

import Foundation

struct User {
    let login: String
    let url:String
    let avatar_url: String
    
    init?(object: [String: Any]) {
        guard let url = object["url"] as? String,
            let login = object["login"] as? String,
            let avatar_url = object["avatar_url"] as? String else {
                return nil
        }
        self.url = url
        self.login = login
        self.avatar_url = avatar_url
    }
    
    init(_ url: String, _ login: String, _ avatar_url: String) {
        self.url = url
        self.login = login
        self.avatar_url = avatar_url
    }
}



