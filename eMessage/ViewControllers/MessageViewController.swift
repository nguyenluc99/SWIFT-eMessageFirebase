//
//  MessageViewController.swift
//  eMessage
//
//  Created by Luc Nguyen on 7/28/19.
//  Copyright © 2019 HoaPQ. All rights reserved.
//

import UIKit
import MessageKit
import FirebaseDatabase
import InputBarAccessoryView

class MessageViewController: MessagesViewController {
    var messages = [MessageModel]()
    var currentUser = UserModel(uid: AppSettings.uid, username: AppSettings.username)
    
    var partner : UserModel!
    
    var channelID1 : String!
    var channelID2 : String!
    var channelDB : DatabaseReference!
    init(with partner : UserModel) {
        super.init(nibName: nil, bundle: nil)
        self.partner = partner
        self.channelID1 = "\(currentUser.uid)_\(partner.uid)"
        self.channelID2 = "\(partner.uid)_\(currentUser.uid)"
        
        channelDB = Database.database().reference().child("channels")
        channelDB.child(channelID1).observe(.childAdded) { (snapshot) in
            if let message = MessageModel(snapshot: snapshot) {
                self.messages.append(message)
                self.messagesCollectionView.reloadData()
            }
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.largeTitleDisplayMode = .always
        self.navigationItem.title = AppSettings.username
        // Do any additional setup after loading the view.
        
        
        messagesCollectionView.messagesDataSource = self
        messagesCollectionView.messagesLayoutDelegate = self
        messagesCollectionView.messagesDisplayDelegate = self
        messageInputBar.delegate = self
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}


//let sender = Sender(id: "any_unique_id", displayName: "Steven")
//let messages: [MessageType] = []
extension MessageViewController : MessagesDataSource, MessagesLayoutDelegate, MessagesDisplayDelegate {
    func numberOfSections(in messagesCollectionView: MessagesCollectionView) -> Int {
         return messages.count
    }
    func currentSender() -> SenderType {
        return Sender(id: AppSettings.uid, displayName: AppSettings.username)
    }
    func messageForItem(at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) -> MessageType {
        return messages[indexPath.section]
    }
}

extension MessageViewController : InputBarAccessoryViewDelegate {
    func inputBar(_ inputBar: InputBarAccessoryView, didPressSendButtonWith text: String) {
        let message = MessageModel(content: text, user: currentUser)
        inputBar.inputTextView.text = ""
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd-MM-yyyy HH:mm:ss"
        
        let dict : [String : Any?] = [
            "senderID" : currentUser.uid,
            "senderName" : currentUser.username,
            "senderDate" : dateFormatter.string(from: message.sentDate),
            "content" : message.content,
        ]
        channelDB.child(channelID1).childByAutoId().setValue(dict)
        channelDB.child(channelID2).childByAutoId().setValue(dict)
        
    }
}
