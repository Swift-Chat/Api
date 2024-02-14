import Vapor
import model
import CoreFoundation

func routes(
    _ app: Application,
    messageController: MessageController,
    authController: AuthController,
    socketController: SocketController
) throws {

    app
        .grouped(UserCredentialsAuthenticator(authController: authController))
        .grouped(User.guardMiddleware())
        .post("login") { req -> Token in
            let user = try! req.auth.require(User.self)
            
            return try authController.createToken(user: user)
        }

    app
        .grouped(UserTokenAuthenticator(authController: authController))
        .grouped(User.guardMiddleware())
        .get("conversations") { req -> [Conversation] in
            let user = try! req.auth.require(User.self)
            
            return messageController.getConversations(user: user)
        }
    
    app
        .grouped(UserTokenAuthenticator(authController: authController))
        .grouped(User.guardMiddleware())
        .webSocket("swift_chat") { req, webSocket in
            let user = try! req.auth.require(User.self)
            
            socketController.connect(user: user, webSocket: webSocket)
            
            webSocket.onClose.whenComplete { _ in
                socketController.disconnect(user: user)
            }
            
            webSocket.onBinary { _, data in
                do {
                    let message = try JSONDecoder().decode(MessageInput.self, from: data)
                    let newMessage = messageController.addMessage(messageInput: message)
                    
                    try socketController.sendMessage(message: newMessage)
                } catch {
                    print(error)
                }
            }
        }
}
