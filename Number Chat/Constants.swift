//
//  Constants.swift
//  Number Chat
//
//  Created by Dominik Leszczyński on 01/01/2021.
//

import Foundation

struct Constants {
    static let loginSegue = "LoginSegue"
    static let cellIdentifier = "ReusableCell"
    
    struct FireStore {
        static let senderID = "senderid"
        static let bodyField = "body"
        static let dateField = "date"
        static let collection = "chat"
    }
}
