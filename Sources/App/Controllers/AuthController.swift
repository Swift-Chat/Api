import Foundation
import model
import Vapor

struct UserCredentialsAuthenticator: AsyncBasicAuthenticator {
    private var authController: AuthController
    
    public init(authController: AuthController) {
        self.authController = authController
    }
    
    func authenticate(basic: BasicAuthorization, for request: Request) async throws {
        let user = try authController.authenticate(username: basic.username, password: basic.password)
        request.auth.login(user)
    }
}

struct UserTokenAuthenticator: AsyncBearerAuthenticator {
    private var authController: AuthController
    
    public init(authController: AuthController) {
        self.authController = authController
    }

    func authenticate(bearer: BearerAuthorization, for request: Request) async throws {
        let user = try authController.getUser(token: bearer.token)
        request.auth.login(user)
    }
}

class AuthController {
    public init(tokens: Tokens, users: Users) {
        self.tokens = tokens
        self.users = users
    }
    
    private var tokens: Tokens
    private var users: Users
    
    func createToken(user: User) throws -> Token {
        return try tokens.createToken(user: user)
    }
    
    func authenticate(username: String, password: String) throws -> User {
        guard let user = users.users.first(where: { user in
            user.username == username
        }) else {
            throw Abort(.unauthorized, reason: "User \(username) cannot be found")
        }
        
        if (password == "password") {
            return user
        } else {
            throw Abort(.unauthorized, reason: "Incorrect password")
        }
    }
    
    func getUser(token: String) throws -> User {
        do {
            return try tokens.getAuthenticatedUser(token: token)
        } catch TokenError.invalidToken {
            throw Abort(.unauthorized, reason: "Invalid token")
        } catch {
            throw Abort(.internalServerError, reason: "\(error.localizedDescription)")
        }
    }
}
