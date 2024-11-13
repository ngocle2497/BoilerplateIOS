import Foundation
import Alamofire
import TrustKit

final class NetworkSessionDelegate: SessionDelegate {
    
    override func urlSession(_ session: URLSession, task: URLSessionTask, didReceive challenge: URLAuthenticationChallenge, completionHandler: @escaping (URLSession.AuthChallengeDisposition, URLCredential?) -> Void) {
        if NetworkManager.trustkitInstance == nil || !NetworkManager.trustkitInstance!.pinningValidator.handle(challenge, completionHandler: completionHandler){
            completionHandler(.performDefaultHandling, nil)
        }
    }
}
