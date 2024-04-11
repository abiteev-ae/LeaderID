import Alamofire
import Foundation

// Custom RequestInterceptor to add Bearer token to each request in Session
class BearerTokenInterceptor: RequestInterceptor {
    private let token: String
    
    init(token: String) {
        self.token = token
    }
    
    func adapt(_ urlRequest: URLRequest, for session: Session, completion: @escaping (Result<URLRequest, Error>) -> Void) {
        var modifiedURLRequest = urlRequest
        modifiedURLRequest.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        completion(.success(modifiedURLRequest))
    }
    
    
    func retry(_ request: Request, for session: Session, dueTo error: Error, completion: @escaping (RetryResult) -> Void) {
        completion(.doNotRetry) //TODO: нужна логика повтора запросов при неудаче
    }
}
/* Example of usage
// Set your Bearer token
let bearerToken = "your_token_here"

// Create an instance of the BearerTokenInterceptor
let interceptor = BearerTokenInterceptor(token: bearerToken)

// Create a session with the interceptor
let session = Session(interceptor: interceptor)

// Use the session to make a request
session.request("https://your-api-url.com")
    .responseJSON { response in
        // Handle the response
        print(response)
    }
*/
