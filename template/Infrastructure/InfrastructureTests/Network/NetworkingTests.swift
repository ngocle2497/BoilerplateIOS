import XCTest
import Alamofire
@testable import Infrastructure
@testable import Adapter

class GetUser: ApiEndpoint {
    var url: String
    
    var method: Alamofire.HTTPMethod
    
    var params: Alamofire.Parameters?
    
    var headers: Alamofire.HTTPHeaders?
    
    init(url: String, method: Alamofire.HTTPMethod, params: Alamofire.Parameters? = nil, headers: Alamofire.HTTPHeaders? = nil) {
        self.url = url
        self.method = method
        self.params = params
        self.headers = headers
    }
}

struct ErrorExample: Codable {
    var status: Int
    var message: String
}

struct UserPage: Codable {
    let info: Info
    let results: [UserDTO]
    struct Info: Codable {
        let seed: String
        let results: Int
        let page: Int
        let version: String
    }
    struct UserDTO: Codable {
        enum Gender: String, Codable {
            case male   = "male"
            case female = "female"
        }
        
        struct Name: Codable {
            let title: String
            let first: String
            let last: String
        }
        
        let phone: String
        let nat: String
        let gender: Gender
        let name: Name
        let email: String
    }
}

final class NetworkingTests: XCTestCase, Mockable {
    
    private var networkManager: NetworkManager!
    private var userResponseData: Data!
    
    override func setUp() {
        let configuration = URLSessionConfiguration.af.default
        configuration.protocolClasses = [MockURLProtocol.self] + (configuration.protocolClasses ?? [])
        let sessionManager = Session(configuration: configuration)
        userResponseData = loadJSON(fileName: "UserResponse")
        networkManager = .init(session: sessionManager)
    }
    
    func testFetchUserSuccess() async {
        MockURLProtocol.loadingHandler = {[weak self] request in
            let response = HTTPURLResponse(url: request.url!, statusCode: 200, httpVersion: nil, headerFields: nil)!
            return (response, self!.userResponseData)
        }
        
        let result = await networkManager.getNetworkConcurrency().request(GetUser(url: "https://examle.com/api", method: .get, headers: ["Content-Type": "application/json"]), type: UserPage.self)
        switch result {
        case .success(let userPage):
            XCTAssertNotNil(userPage)
            break
        case .failure(_):
            XCTAssertNotNil("Should success")
            break
        }
    }
    
    func testFetchUserDecodeFailed() async {
        MockURLProtocol.loadingHandler = { [weak self] request in
            let response = HTTPURLResponse(url: request.url!, statusCode: 200, httpVersion: nil, headerFields: nil)!
            return (response, self!.userResponseData)
        }
        
        let result = await networkManager.getNetworkConcurrency().request(GetUser(url: "https://examle.com/api", method: .get, headers: ["Content-Type": "application/json"]), type: ErrorExample.self)
        switch result {
        case .success(_):
            XCTAssertNotNil("Should decode error")
            break
        case .failure(let error):
            XCTAssertEqual(error.code, HttpStatusCode.DECODE_ERROR.rawValue)
            break
        }
    }
    
    func testRequestCancel() async {
        MockURLProtocol.loadingHandler = { [weak self]  request in
            let response = HTTPURLResponse(url: request.url!, statusCode: 200, httpVersion: nil, headerFields: nil)!
            return (response, self!.userResponseData)
        }
        
        let task = Task {
            let result = await networkManager.getNetworkConcurrency().request(GetUser(url: "https://examle.com/api", method: .get, headers: ["Content-Type": "application/json"]), type: ErrorExample.self)
            switch result {
            case .success(_):
                XCTAssertNotNil("Should cancel")
                break
            case .failure(let error):
                XCTAssertEqual(error.code, HttpStatusCode.CANCELED.rawValue)
                break
            }
        }
        task.cancel()
    }
    
    func testRequestUnknown() async {
        MockURLProtocol.loadingHandler = { [weak self]  request in
            return (nil, self!.userResponseData)
        }
        let result = await networkManager.getNetworkConcurrency().request(GetUser(url: "https://examle.com/api", method: .get, headers: ["Content-Type": "application/json"]), type: ErrorExample.self)
        switch result {
        case .success(_):
            XCTAssertNotNil("Should Unkown")
            break
        case .failure(let error):
            XCTAssertEqual(error.code, HttpStatusCode.UNKOWN.rawValue)
            break
        }
    }
    
    func testFetchUserFailed() async {
        let data = loadJSON(fileName: "ErrorRequest400")
        
        MockURLProtocol.loadingHandler = { request in
            let response = HTTPURLResponse(url: request.url!, statusCode: 400, httpVersion: nil, headerFields: nil)!
            return (response, data)
        }
        let result = await networkManager.getNetworkConcurrency().request(GetUser(url: "https://examle.com/api", method: .get, headers: ["Content-Type": "application/json"]), type: UserPage.self, typeError: ErrorExample.self)
        switch result {
        case .success(_):
            XCTAssertNotNil("Should error")
            break
        case .failure(let error):
            XCTAssertEqual(error.code, 400)
            XCTAssertEqual(error.error?.status, 400)
            break
        }
    }
    
}
