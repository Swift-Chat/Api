import Vapor

public func configure(_ app: Application) throws {
    let messages = Messages()
    let tokens = Tokens()
    let users = Users()
    
    let authController = AuthController(tokens: tokens, users: users)
    let messageController = MessageController(messages: messages, users: users)
    let socketController = SocketController()

    
    try routes(
        app,
        messageController: messageController,
        authController: authController,
        socketController: socketController
    )
}
