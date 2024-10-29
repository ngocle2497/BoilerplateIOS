import Foundation

public struct User {
    public init(id: String, gender: Gender?, name: String?, email: String?) {
        self.id = id
        self.gender = gender
        self.name = name
        self.email = email
    }
    
    public enum Gender {
        case male
        case female
    }
    public let id: String
    public let gender: Gender?
    public let name: String?
    public let email: String?
}

public struct UsersPage {
    public let page: Int
    public let totalPage: Int
    public let users: [User]
    
    public init(page: Int, totalPage: Int, users: [User]) {
        self.page = page
        self.totalPage = totalPage
        self.users = users
    }
}
