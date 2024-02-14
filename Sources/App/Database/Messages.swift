import Foundation
import model

class Messages {
    var messages: [Message] = []
    private var id = 0
    
    func addMessage(messageInput: MessageInput) -> Message {
        let message = Message(
            id: id,
            content: messageInput.content,
            sender: messageInput.sender,
            receiver: messageInput.receiver
        )

        messages.append(message)
        id += 1
        return message
    }
    
    func getMessages(user: User) -> [Message] {
        return messages
            .filter { message in
                message.sender == user || message.receiver == user
            }
            .sorted { message1, message2 in
                message1.id < message2.id
            }
    }
}
