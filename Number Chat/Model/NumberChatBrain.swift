//
//  FirestoreBrain.swift
//  Number Chat
//
//  Created by Dominik Leszczyński on 15/01/2021.
//

import Foundation

import FirebaseFirestore

class NumberChatBrain {
    
    // Firestore instance
    let db = Firestore.firestore()
    
    var messages : [Int : String] = [ : ]
    
    // Replace this with counting collections from firestore
    // and making a range out of them
    let chatNumbers = 1...10

}
