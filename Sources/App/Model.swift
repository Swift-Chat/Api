import Foundation
import model
import Vapor

extension User: Content, Authenticatable {}

extension Conversation: Content {}

extension Token: Content, Authenticatable {
    init(user: User) {
        self.init(value: Token.randomString(length: 50), user: user)
    }
    
    private static func randomString(length: Int) -> String {
      let letters = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789"
      return String((0..<length).map{ _ in letters.randomElement()! })
    }
}
