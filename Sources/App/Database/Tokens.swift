import Foundation
import model

class Tokens {
    var tokens: [User: Token] = [:]
    
    func createToken(user: User) throws -> Token {
        let newToken = Token(user: user)
        tokens.updateValue(newToken, forKey: user)
        return newToken
    }
    
    func getAuthenticatedUser(token: String) throws -> User {
        guard let token = tokens.first(where: { (user: User, userToken: Token) in
            userToken.value == token
        }) else {
            throw TokenError.invalidToken
        }
        
        return token.key
    }
}

enum TokenError: Error {
    case invalidToken
}
