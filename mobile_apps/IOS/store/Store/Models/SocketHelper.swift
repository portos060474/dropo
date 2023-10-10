//
//  SocketHelper.swift
//  // SRC Store
//
//  Created by Jaydeep on 22/09/17.
//  Copyright © 2017 Elluminati iMac. All rights reserved.
//

import Foundation
import SocketIO

class SocketHelper: NSObject
{
    static let updateLatLong = "send";
    static let subscribe = "subscribe";
    static let shared = SocketHelper()
    var socket = SocketIOClient(socketURL: URL(string:"http://localhost:8001/")!)
    private override init() {
        super.init()
    }
    
    func establishConnection() {
        socket.connect()
        socket.emit("subscribe", preferenceHelper.getUserId())
    }
    
    func closeConnection()
    {
        socket.disconnect()
    }
    func sendMessage(key:String,data:[String:Any])
    {
        socket.emit(key,data)
    }
}
