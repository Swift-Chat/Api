import Foundation
import model
import WebSocketKit

class MessageController {
    public init(messages: Messages, users: Users) {
        self.messages = messages
        self.users = users
    }
    
    private var messages: Messages
    private var users: Users
    
    func getMessages(user: User) -> [Message] {
        return messages.getMessages(user: user)
    }
    
    func addMessage(messageInput: MessageInput) -> Message {
        return messages.addMessage(messageInput: messageInput)
    }
    
    func getConversations(user: User) -> [Conversation] {
        let otherUsers = users.users.filter { element in
            element.username != user.username
        }
        
        return otherUsers.map { otherUser in
            Conversation(
                messages: getMessages(user: user).filter({ message in
                    message.sender.username == otherUser.username || message.receiver.username == otherUser.username
                }),
                user: otherUser
            )
        }
    }
}
