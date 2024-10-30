import Alamofire
import Adapter

class NetworkManager {
    static let shared = NetworkManager()
    private let session = Session.default
    func getNetworkSession() -> NetworkManagerConcurency {
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
    private let session: Session
    
    init(session: Session) {
        self.session = session
    }
    
    func request<T: Codable>(_ route: ApiEndpoint,
                                         type: T.Type,
                                         typeError: T.Type? = nil) async -> Result<T, ErrorRequest<T>> {
        let dataResponse = await self.session.request(route.baseURL, method: route.method, parameters: route.parameters, headers: route.headers).serializingData(automaticallyCancelling: true).response
        
        switch dataResponse.result {
        case .success(let data):
            if dataResponse.response?.statusCode == HttpStatusCode.OK.rawValue {
                do {
                    let jsonData =  try JSONDecoder.default.decode(type.self, from: data)
                    return .success(jsonData)
                } catch {
                    print(error.localizedDescription)
                    return .failure(.init(code: HttpStatusCode.DECODE_ERROR.rawValue, message: error.localizedDescription, error: nil))
                }
            }
            guard let typeError = typeError else {
                return .failure(.init(code: dataResponse.response?.statusCode ?? HttpStatusCode.UNKOWN.rawValue, message: dataResponse.error?.localizedDescription ?? "Unkown", error: nil))
            }
            do {
                let jsonData =  try JSONDecoder.default.decode(typeError.self, from: data)
                return .failure(.init(code: dataResponse.response?.statusCode ?? HttpStatusCode.UNKOWN.rawValue, message: dataResponse.error?.localizedDescription ?? "Unkown", error: jsonData))
            } catch {
                print(error.localizedDescription)
                return .failure(.init(code: dataResponse.response?.statusCode ?? HttpStatusCode.UNKOWN.rawValue, message: dataResponse.error?.localizedDescription ?? "Unkown", error: nil))
            }
        case .failure(let error):
            if error.isExplicitlyCancelledError {
                return .failure(.init(code: HttpStatusCode.CANCELED.rawValue, message: error.localizedDescription, error: nil))
            }
            print(error.localizedDescription)
            return .failure(.init(code: error.responseCode ?? HttpStatusCode.UNKOWN.rawValue, message: error.localizedDescription, error: nil))
        }
    }
}
extension JSONDecoder {
    static var `default`: JSONDecoder {
        let decoder = JSONDecoder()
        decoder.keyDecodingStrategy = .useDefaultKeys
        return decoder
    }
}
