//
//  MessageHandler.swift
//  ChatApp
//
//  Created by Elluminati on 19/12/17.
//  Copyright © 2017 Irshad. All rights reserved.
//

import Foundation
import FirebaseDatabase
import FirebaseStorage
import FirebaseAuth

protocol MessageRecivedDelegate:class {
    func messageRecived(data:FirebaseMessage)
    func messageUpdated(data:FirebaseMessage)
}


class MessageHandler:NSObject{
    private static let _instance = MessageHandler()
    private override init(){}
    var lastChildKey:String!
    weak var delegate:MessageRecivedDelegate?
    static var chatType: Int = 0
    static var ReceiverID: String = ""
    static var orderID: String = ""


    static var Instace:MessageHandler{
        return _instance
    }
   
    func readMessage(id:String)
    {
    DBProvider.Instance.messageRef.child(MessageHandler.orderID).child("\(MessageHandler.chatType)").child(id).child(CONSTANT.MESSAGES.STATUS).setValue(true)
    }
    
    func observeMessage()
    {
       Utility.showLoading()
       print("chatType : \(MessageHandler.chatType)")

        DBProvider.Instance.messageRef.child(MessageHandler.orderID).child("\(MessageHandler.chatType)").observe(.childAdded){(snapShot:DataSnapshot) in
            if snapShot.exists(){
                if let data = snapShot.value as? [String:Any]
                {
                    print("selectedOrderId : \(MessageHandler.orderID)")
                    print("snapShot.childrenCount : \(snapShot.childrenCount)")
                    print("chatType : \(MessageHandler.chatType)")
                    //print("CHAT_TYPE from Firebase : \(data[CONSTANT.MESSAGES.CHAT_TYPE])")

                    self.lastChildKey = snapShot.key
                    if data[CONSTANT.MESSAGES.CHAT_TYPE] as? Int != nil
                    {
                        let message = FirebaseMessage.init(fromDictionary: data)
                        self.delegate?.messageRecived(data:message)
                    }
                }
            }
            Utility.hideLoading()
        }
    }
    
    func observeUpdateMessage()
    {
        Utility.showLoading()
        DBProvider.Instance.messageRef.child(MessageHandler.orderID).child("\(MessageHandler.chatType)").observe(.childChanged){(snapShot:DataSnapshot) in

            if let data = snapShot.value as? [String:Any]
            {
                self.lastChildKey = snapShot.key

                if /*let senderId =*/ data[CONSTANT.MESSAGES.CHAT_TYPE] as? Int != nil
                {
                    let message = FirebaseMessage.init(fromDictionary: data)
                    self.delegate?.messageUpdated(data: message)
                }
            }
            Utility.hideLoading()
        }

    }
    
   /* func continueObserveMessage() {
        DBProvider.Instance.messageRef.child(CurrentBooking.shared.selectedOrderId!).child("\(chatType)").child(CONSTANT.DBPROVIDER.MESSAGES).queryLimited(toLast: 1).observe(.value) { (snapShot:DataSnapshot) in
            
            if let data = snapShot.value as? [String:Any]
            {
                self.lastChildKey = snapShot.key
                
                if (data[CONSTANT.MESSAGES.CHAT_TYPE] as? Int) != nil
                {
                    let message = FirebaseMessage.init(fromDictionary: data)
                    self.delegate?.messageRecived(data:message)
                    
                }
                
            }
            
        }
    }*/
 
    func sendMessage(text:String,time:String){
        
        
        let key = (DBProvider.Instance.messageRef.child(MessageHandler.orderID).childByAutoId().key)
        print("receiver_id \(MessageHandler.ReceiverID)")
        let data:Dictionary<String,Any> = [CONSTANT.MESSAGES.ID:key!,
                                            CONSTANT.MESSAGES.SENDER_TYPE:CONSTANT.CHAT_STORE_TYPE,
                                            CONSTANT.MESSAGES.CHAT_TYPE:MessageHandler.chatType,
                                            CONSTANT.MESSAGES.STATUS:false,
                                           CONSTANT.MESSAGES.TEXT:text,
                                           CONSTANT.MESSAGES.TIME:time,
                                           CONSTANT.MESSAGES.RECEIVER_ID: MessageHandler.ReceiverID
                                           ];
        //let dic : Dictionary<String,Any> = ["\(key!)" : data]
        
//        DBProvider.Instance.messageRef.child(CurrentBooking.shared.selectedOrderId!).child(key!).setValue(data)
        DBProvider.Instance.messageRef.child(MessageHandler.orderID).child("\(MessageHandler.chatType)").child(key!).setValue(data)
 
    }
    
    func removeObserver()
    {
        DBProvider.Instance.messageRef.child(MessageHandler.orderID).child(CONSTANT.DBPROVIDER.MESSAGES).removeAllObservers()
    }
    
}


struct FirebaseMessage : Codable {
    
    var id : String = ""
    var isRead : Bool = false
    var message : String = ""
    var time : String = ""
    var chat_type : Int = 0
    var sender_type : Int = 0

    
    enum CodingKeys: String, CodingKey {
        case id = "id"
        case isRead = "is_read"
        case message = "message"
        case time = "time"
        case chat_type = "chat_type"
        case sender_type = "sender_type"
    }
    
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        id = try values.decodeIfPresent(String.self, forKey: .id) ?? ""
        isRead = try values.decodeIfPresent(Bool.self, forKey: .isRead) ?? false
        message = try values.decodeIfPresent(String.self, forKey: .message) ?? ""
        time = try values.decodeIfPresent(String.self, forKey: .time) ?? ""
        chat_type = try values.decodeIfPresent(Int.self, forKey: .chat_type) ?? 0
        sender_type = try values.decodeIfPresent(Int.self, forKey: .sender_type) ?? 0

    }
    
    
    
    init(fromDictionary dictionary: [String:Any]){
        id = (dictionary["id"] as? String) ?? ""
        isRead = (dictionary["is_read"] as? Bool) ?? false
        message = (dictionary["message"] as? String) ?? ""
        time = (dictionary["time"] as? String) ?? ""
        chat_type = (dictionary["chat_type"] as? Int) ?? 0
        sender_type = (dictionary["sender_type"] as? Int) ?? 0
    }
    
    /**
     * Returns all the available property values in the form of [String:Any] object where the key is the approperiate json key and the value is the value of the corresponding property
     */
    func toDictionary() -> [String:Any]
    {
        var dictionary = [String:Any]()
        //if id != nil{
            dictionary["id"] = id
        //}
        //if isRead != nil{
            dictionary["is_read"] = isRead
        //}
        //if message != nil{
            dictionary["message"] = message
        //}
        //if time != nil{
            dictionary["time"] = time
        //}
        //if type != nil{
//            dictionary["type"] = type
        //}
        
        dictionary["chat_type"] = chat_type
        dictionary["sender_type"] = sender_type

        return dictionary
    }
    
    
    
    
}
