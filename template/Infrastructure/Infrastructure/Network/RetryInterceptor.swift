import Foundation
import Alamofire

struct RefreshTokenResponse: Codable {
    var data: String
    var status: Int
}

final class RetryInterceptor: RequestInterceptor {
    
    private let retryLimit = 2
    static var refreshTask: Task<Bool, Never>?
    
    func adapt(_ urlRequest: URLRequest, for session: Session, completion: @escaping (Result<URLRequest, Error>) -> Void) {
        var request = urlRequest
        guard let token = MMKV_STORAGE.appToken else {
            completion(.success(urlRequest))
            return
        }
        let bearerToken = "Bearer \(token)"
        request.setValue(bearerToken, forHTTPHeaderField: "Authorization")
        completion(.success(request))
    }
    
    func retry(_ request: Request, for session: Session, dueTo error: any Error, completion: @escaping (RetryResult) -> Void) {
        guard let statusCode = request.response?.statusCode else {
            completion(.doNotRetry)
            return
        }
        
        guard request.retryCount < retryLimit else {
            completion(.doNotRetry)
            return
        }
        switch statusCode {
        case 200...299:
            completion(.doNotRetry)
        case HttpStatusCode.UN_AUTHORIZED.rawValue:
            if NetworkService.shared.delegate?.getApiRouteForRefreshToken() == nil {
                completion(.doNotRetry)
                return
            }
            refreshTokenIfNecessary { isSuccess in isSuccess ? completion(.retry) : completion(.doNotRetry) }
            break
        default:
            completion(.retry)
        }
    }
    
    private func afRefreshToken() async -> Bool {
        // we check NetworkService.shared.delegate above, so we can force value here
        let route = NetworkService.shared.delegate!.getApiRouteForRefreshToken()!
        let dataResponse = await AF.request(route.url, method: route.method, parameters: route.params, headers: route.headers).serializingData(automaticallyCancelling: true).response
        switch dataResponse.result {
        case .success(let data):
            if dataResponse.response?.statusCode == HttpStatusCode.OK.rawValue {
                do {
                    let jsonData =  try JSONDecoder.default.decode(RefreshTokenResponse.self, from: data)
                    MMKV_STORAGE.appToken = jsonData.data
                    return true
                } catch {
                    print(error.localizedDescription)
                    NetworkManager.shared.networkStatus.send(.init(status: HttpStatusCode.DECODE_ERROR.rawValue, messages: error.localizedDescription))
                    return false
                }
            }
            return false
        case .failure(_):
            return false
        }
    }
    
    private func refreshTokenTask() async -> Bool {
        if let task = RetryInterceptor.refreshTask {
            return await task.value
        }
        let task = Task {
            await afRefreshToken()
        }
        RetryInterceptor.refreshTask = task
        return await withTaskCancellationHandler {
            let value = await task.value
            RetryInterceptor.refreshTask = nil
            return value
        } onCancel: {
            task.cancel()
        }
    }
    
    private func refreshTokenIfNecessary(completion: @escaping (_ isSuccess: Bool) -> Void) {
        Task {
            let value = await refreshTokenTask()
            completion(value)
        }
    }
}
