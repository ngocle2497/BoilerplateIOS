import Alamofire
import Adapter
import Combine

struct NetworkResult {
    var status: Int
    var messages: String
    init(status: Int, messages: String) {
        self.status = status
        self.messages = messages
    }
}

class NetworkManager {
    var networkStatus = PassthroughSubject<NetworkResult, Never>()
    static let shared = NetworkManager(session: Session(interceptor: RetryInterceptor()))
    
    private let session: Session
    
    init(session: Session) {
        self.session = session
    }
    
    func cancelAllRequest() {
        session.session.getAllTasks { tasks in
            tasks.forEach({ $0.cancel() })
        }
    }
    
    func getNetworkConcurrency() -> NetworkManagerConcurency {
        return NetworkManagerConcurency(session: session)
    }
}

struct ErrorRequest<T: Codable>: Codable, Error {
    let code: Int
    let message: String
    let error: T?
    
    init(code: Int, message: String, error: T?) {
        self.code = code
        self.message = message
        self.error = error
    }
}

class NetworkManagerConcurency {
    private var cancelable: Task<Result<Codable, AFError>, Error>? = nil
    private weak var session: Session!
    
    init(session: Session) {
        self.session = session
    }
    
    private func handleRequest<T: Codable, E: Codable>(dataResponse: DataResponse<Data, AFError>, type: T.Type,
                                                       typeError: E.Type? = nil) -> Result<T, ErrorRequest<E>>{
        switch dataResponse.result {
        case .success(let data):
            if dataResponse.response?.statusCode == HttpStatusCode.OK.rawValue {
                do {
                    NetworkManager.shared.networkStatus.send(.init(status: HttpStatusCode.OK.rawValue, messages: ""))
                    let jsonData =  try JSONDecoder.default.decode(type.self, from: data)
                    return .success(jsonData)
                } catch {
                    print(error.localizedDescription)
                    NetworkManager.shared.networkStatus.send(.init(status: HttpStatusCode.DECODE_ERROR.rawValue, messages: error.localizedDescription))
                    return .failure(.init(code: HttpStatusCode.DECODE_ERROR.rawValue, message: error.localizedDescription, error: nil))
                }
            }
            guard let typeError = typeError else {
                NetworkManager.shared.networkStatus.send(.init(status: HttpStatusCode.UNKOWN.rawValue, messages: dataResponse.error?.localizedDescription ?? "Unkown"))
                return .failure(.init(code: dataResponse.response?.statusCode ?? HttpStatusCode.UNKOWN.rawValue, message: dataResponse.error?.localizedDescription ?? "Unkown", error: nil))
            }
            do {
                let jsonData =  try JSONDecoder.default.decode(typeError.self, from: data)
                NetworkManager.shared.networkStatus.send(.init(status: HttpStatusCode.UNKOWN.rawValue, messages: dataResponse.error?.localizedDescription ?? "Unkown"))
                return .failure(.init(code: dataResponse.response?.statusCode ?? HttpStatusCode.UNKOWN.rawValue, message: dataResponse.error?.localizedDescription ?? "Unkown", error: jsonData))
            } catch {
                print(error.localizedDescription)
                NetworkManager.shared.networkStatus.send(.init(status: HttpStatusCode.UNKOWN.rawValue, messages: dataResponse.error?.localizedDescription ?? "Unkown"))
                return .failure(.init(code: dataResponse.response?.statusCode ?? HttpStatusCode.UNKOWN.rawValue, message: dataResponse.error?.localizedDescription ?? "Unkown", error: nil))
            }
        case .failure(let error):
            if error.isExplicitlyCancelledError || error.localizedDescription.lowercased().contains("cancelled") {
                NetworkManager.shared.networkStatus.send(.init(status: HttpStatusCode.CANCELED.rawValue, messages: "Canceled"))
                return .failure(.init(code: HttpStatusCode.CANCELED.rawValue, message: error.localizedDescription, error: nil))
            }
            NetworkManager.shared.networkStatus.send(.init(status: error.responseCode ?? HttpStatusCode.UNKOWN.rawValue, messages: error.localizedDescription))
            print(error.localizedDescription)
            return .failure(.init(code: error.responseCode ?? HttpStatusCode.UNKOWN.rawValue, message: error.localizedDescription, error: nil))
        }
    }
    
    func request<T: Codable, E: Codable>(_ route: ApiEndpoint,
                                         type: T.Type,
                                         typeError: E.Type) async -> Result<T, ErrorRequest<E>> {
        let dataResponse = await self.session.request(route.url, method: route.method, parameters: route.params, headers: route.headers).validate().serializingData(automaticallyCancelling: true).response
        return handleRequest(dataResponse: dataResponse, type: type, typeError: typeError)
    }
    
    func request<T: Codable>(_ route: ApiEndpoint,
                                         type: T.Type ) async -> Result<T, ErrorRequest<T>> {
        let dataResponse = await self.session.request(route.url, method: route.method, parameters: route.params, headers: route.headers).validate().serializingData(automaticallyCancelling: true).response
        return handleRequest(dataResponse: dataResponse, type: type, typeError: nil)
    }
}
extension JSONDecoder {
    static var `default`: JSONDecoder {
        let decoder = JSONDecoder()
        decoder.keyDecodingStrategy = .useDefaultKeys
        return decoder
    }
}
