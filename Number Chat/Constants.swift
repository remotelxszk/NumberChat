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
    static let chatSegue = "ChatSegue"
    
    struct FireStore {
        static let senderID = "senderid"
        static let bodyField = "body"
        static let dateField = "date"
        static let collection = "chat"
    }
    
    struct Colors {
        static let primaryBackgroundColor = "BackgroundStandardColor"
        static let secondaryBackgroundColor = "BackgroundSecondaryColor"
        static let customLabelColor = "CustomLabelColor"
    }
    
    struct Strings {
        static let noMessages = "[No Messages Yet]" 
    }
}
