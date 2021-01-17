//
//  FirestoreBrain.swift
//  Number Chat
//
//  Created by Dominik Leszczyński on 15/01/2021.
//

import Foundation
import Firebase

class NumberChatBrain {
    
    // Firestore instance
    let db = Firestore.firestore()
    
    var messages : [Int : String] = [ : ]
    
    let chatNumbers = 1...10

}
