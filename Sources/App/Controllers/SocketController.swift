import Foundation
import WebSocketKit
import model

class SocketController {
    private var clients: [User: WebSocket]
    
    public init() {
        self.clients = [:]
    }
    
    func connect(user: User, webSocket: WebSocket) {
        clients.updateValue(webSocket, forKey: user)
    }
    
    func sendMessage(message: Message) throws {
        if let senderClient = clients.first(where: { (user: User, webSocket: WebSocket) in
            user == message.sender
        }) {
            let encodedMessage = try JSONEncoder().encode(message)
            senderClient.value.send([UInt8](encodedMessage))
        }
        
        if let receiverClient = clients.first(where: { (user: User, webSocket: WebSocket) in
            user == message.receiver
        }) {
            let encodedMessage = try JSONEncoder().encode(message)
            receiverClient.value.send([UInt8](encodedMessage))
        }
    }
    
    func disconnect(user: User) {
        clients.removeValue(forKey: user)
    }
}
