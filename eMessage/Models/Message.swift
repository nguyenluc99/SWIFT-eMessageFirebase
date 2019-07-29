//
//  Message.swift
//  eMessage
//
//  Created by Luc Nguyen on 7/29/19.
//  Copyright © 2019 HoaPQ. All rights reserved.
//

import Foundation
import MessageKit
import FirebaseDatabase

struct MessageModel : MessageType {
    var sender: SenderType
    
    var messageId: String
    
    var sentDate: Date
    
    var content : String = ""
    
    var kind: MessageKind {
        return .text(content)
    }
    
    init(content: String, user: UserModel){
        self.content = content
        self.sender = Sender(id: user.uid, displayName: user.username)
        self.messageId = ""
        self.sentDate = Date()
    }
    
    init?(snapshot : DataSnapshot){
        let dict = snapshot.value as! [String: Any?]
        let senderId = dict["senderID"] as! String
        let senderName = dict["senderName"] as! String
        
        self.sender = Sender(id: senderId, displayName: senderName)
        self.messageId = snapshot.key
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd-MM-yyyy HH:mm:ss"
        
        let dateString = dict["senderDate"] as! String
        self.sentDate = dateFormatter.date(from: dateString) ?? Date()
        self.content = dict["content"] as! String
        
        
//        self.username = dict["username"] as! String
    }
    
}

